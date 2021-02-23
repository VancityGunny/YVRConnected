import 'dart:io';
import 'dart:typed_data';
import 'package:contacts_service/contacts_service.dart' as CS;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart' as IPI;
import 'package:permission_handler/permission_handler.dart';
import 'package:yvrfriends/blocs/friend/index.dart';
import 'package:yvrfriends/common/common_bloc.dart';
import 'package:yvrfriends/generated/l10n.dart';

class FriendPage extends StatefulWidget {
  static const String routeName = '/friend';

  @override
  _FriendPageState createState() => _FriendPageState();

  static _FriendPageState of(BuildContext context) {
    final _FriendPageState navigator =
        context.findAncestorStateOfType<_FriendPageState>();

    assert(() {
      if (navigator == null) {
        throw new FlutterError(
            'MyStatefulWidgetState operation requested with a context that does '
            'not include a MyStatefulWidget.');
      }
      return true;
    }());

    return navigator;
  }
}

class _FriendPageState extends State<FriendPage> {
  List<FriendModel> friends;
  Uint8List friendThumbnail;
  String friendEmail;
  bool isMaxFriends = false;
  CommonBloc pageCommonBloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final delegate = S.of(context);
    pageCommonBloc = CommonBloc.of(context);
    pageCommonBloc.allFriends.listen((friendList) {
      if (friendList.length >= 50) {
        setState(() {
          isMaxFriends = true;
        });
      } else {
        setState(() {
          isMaxFriends = false;
        });
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(delegate.friendsLabel),
      ),
      body: FriendScreen(),
      floatingActionButton: new Visibility(
          visible: !isMaxFriends,
          child: FloatingActionButton(
              child: Icon(Icons.add), onPressed: _addFriend)),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _addFriend() async {
    // make sure that the friend is not already in the list
    final PhoneContact contact = await FlutterContactPicker.pickPhoneContact();
    CS.Contact foundContact;
    Uint8List thumbnail;
    // fetch more contact detail
    if (await Permission.contacts.request().isGranted) {
      Iterable<CS.Contact> foundContacts =
          await CS.ContactsService.getContacts(query: contact.fullName);
      foundContact = foundContacts.first;
      if (foundContacts.length > 0) {
        thumbnail = foundContacts.first.avatar;
        this.friendEmail = (foundContacts.first.emails.isEmpty
            ? null
            : foundContacts.first.emails.first.value);
        this.friendThumbnail = (thumbnail.isEmpty == true) ? null : thumbnail;
      }

      // Either the permission was already granted before or the user just granted it.
    }
    //add dialog to confirm contact phone number, to catch any number without country code
    var result = await showDialog(
        context: context,
        builder: (_) {
          return FriendAddDialog(foundContact);
        });
    var newFriend;
    if (result != null) {
      newFriend = result["newFriend"];
      thumbnail = result["thumbnail"];
    } else {
      return;
    }
    FriendModel dupFriend = pageCommonBloc.allFriends.value.firstWhere(
        (f) => f.phone == newFriend.phone || f.email == newFriend.email,
        orElse: () => null);

    if (dupFriend == null) {
      BlocProvider.of<FriendBloc>(context)
          .add(AddingFriendEvent(newFriend, thumbnail));
    } else {
      //return duplicate contact error
    }
  }
}

class FriendAddDialog extends StatefulWidget {
  final CS.Contact contact;
  FriendAddDialog(this.contact);

  @override
  FriendAddDialogState createState() {
    return FriendAddDialogState();
  }
}

class FriendAddDialogState extends State<FriendAddDialog> {
  List<String> allowedCountryCodes = ['JP', 'TH', 'CA', 'US', 'GB', 'HU'];

  final TextEditingController txtPhoneController = TextEditingController();
  final intRegex = RegExp(r'(\d+)', multiLine: true);
  String phoneNumber;
  String phoneISOCode;
  bool isValidPhoneNumber = false;
  Uint8List _image;
  String errorMessage;

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'CA';
  IPI.PhoneNumber _number = IPI.PhoneNumber(isoCode: 'CA');
  Future<IPI.PhoneNumber> _formattedPhoneNumber;
  final _friendFormKey = GlobalKey<FormState>();
  var newFriend =
      new FriendModel(null, null, null, null, null, null, null, null, null);
  List<Country> allowedCountries = new List<Country>();

  @override
  void initState() {
    super.initState();
    _image = widget.contact.avatar;
    _formattedPhoneNumber = PhoneService.fetchCountryData(
            context, 'packages/international_phone_input/assets/countries.json')
        .then((list) {
      // only match allowed country code
      allowedCountries.addAll(
          list.where((element) => allowedCountryCodes.contains(element.code)));
      if (widget.contact.phones.length == 0) {
        //phone not found
        return IPI.PhoneNumber();
      }
      var tempPhoneNumber = widget.contact.phones.first?.value;
      var tempCountryCode = 'CA';
      var tempCountryDialCode = '+1';
      var pureNumber =
          intRegex.allMatches(tempPhoneNumber).map((m) => m.group(0));
      var pureNumberString = pureNumber.fold(
          '', (previousValue, element) => previousValue + element);
      List<Country> countries = PhoneService.getPotentialCountries(
          pureNumberString, allowedCountries);
      Map<String, dynamic> result = new Map<String, dynamic>();
      if (countries.length > 0) {
        tempCountryDialCode = countries.first.dialCode;
        tempCountryCode = countries.first.code;
        // result.putIfAbsent('formattedCountryCode', () => countries.first.code);
        // //guessing this so extract that number out.
        // pureNumberString = pureNumberString
        //     .toString()
        //     .substring(countries.first.dialCode.length - 1);
      } else {
        //if can't find country, maybe append default +1 country code rather than guessing
        tempPhoneNumber = tempCountryDialCode + tempPhoneNumber;
      }
      result.putIfAbsent('formattedPhoneNumber', () => pureNumberString);
      return IPI.PhoneNumber(
          dialCode: tempCountryDialCode,
          isoCode: tempCountryCode,
          phoneNumber: tempPhoneNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    FriendModel newFriend =
        new FriendModel(null, null, null, null, null, null, null, null, null);
    return SimpleDialog(
      children: <Widget>[
        Form(
          key: _friendFormKey,
          child: Column(
            children: <Widget>[
              new TextFormField(
                initialValue: widget.contact.displayName,
                decoration: const InputDecoration(
                  icon: const FaIcon(FontAwesomeIcons.idCard),
                  hintText: 'You can change your friend display name here',
                  labelText: 'Friend Name',
                ),
                inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                validator: (val) =>
                    val.isEmpty ? 'Friend name is required' : null,
                onSaved: (String value) {
                  newFriend.displayName = value;
                },
              ),
              new TextFormField(
                initialValue: (widget.contact.emails.isEmpty
                    ? null
                    : widget.contact.emails.first.value),
                decoration: const InputDecoration(
                  icon: const FaIcon(FontAwesomeIcons.idCard),
                  hintText: 'You can change your friend email address here',
                  labelText: 'Friend Email',
                ),
                inputFormatters: [new LengthLimitingTextInputFormatter(50)],
                validator: (val) =>
                    val.isEmpty ? 'Friend email is required' : null,
                onSaved: (String value) {
                  newFriend.email = value;
                },
              ),
              FutureBuilder(
                  future: this._formattedPhoneNumber,
                  builder: (BuildContext context,
                      AsyncSnapshot<IPI.PhoneNumber> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    // phoneNumber = snapshot.data['formattedPhoneNumber'];
                    // if (snapshot.data['formattedCountryCode'] == null) {
                    //   phoneISOCode = 'CA'; // currently default is CA +1
                    // } else {
                    //   phoneISOCode = snapshot.data['formattedCountryCode'];
                    // }
                    var pureNumberString = snapshot.data.phoneNumber
                        .substring(snapshot.data.dialCode.length);
                    controller.text = pureNumberString;
                    return IPI.InternationalPhoneNumberInput(
                      onInputChanged: (IPI.PhoneNumber number) {
                        phoneNumber = number.phoneNumber;
                        phoneISOCode = number.isoCode;
                        //print(number);
                      },
                      onInputValidated: (bool value) {
                        print(value);
                      },
                      selectorConfig: IPI.SelectorConfig(
                        selectorType: IPI.PhoneInputSelectorType.BOTTOM_SHEET,
                        backgroundColor: Colors.white,
                      ),
                      ignoreBlank: false,
                      autoValidateMode: AutovalidateMode.disabled,
                      selectorTextStyle: TextStyle(color: Colors.black),
                      initialValue: snapshot.data,
                      textFieldController: controller,
                      inputBorder: OutlineInputBorder(),
                      onSaved: (IPI.PhoneNumber value) {
                        newFriend.phone = value.phoneNumber;
                      },
                    );
                  }),
              Container(
                child: OutlineButton(
                  child: Text('Add Image'),
                  onPressed: getImage,
                ),
              ),
              Center(
                child: _image.isEmpty
                    ? Text('No image selected.')
                    : Image.memory(_image),
              ),
              Text(
                (errorMessage == null) ? "" : errorMessage,
                style: TextStyle(color: Colors.red),
              ),
              RaisedButton(
                onPressed: () {
                  try {
                    final form = _friendFormKey.currentState;
                    if (!form.validate()) {
                      return;
                    }
                    form.save();
                    if (phoneNumber.length > 0) {
                      // PhoneService.parsePhoneNumber(phoneNumber, phoneISOCode)
                      //     .then((value) {
                      //   isValidPhoneNumber = value;
                      //   if (isValidPhoneNumber) {
                      //     newFriend.phone = this
                      //             .allowedCountries
                      //             .firstWhere(
                      //                 (element) => element.code == phoneISOCode)
                      //             .dialCode +
                      //         phoneNumber.trim();
                      //   }

                      //   if (isValidPhoneNumber) {
                      // do save
                      newFriend.phone =
                          phoneNumber; // dont know why onsaved for phone textbox doesn't call before this
                      if (_image == null) {
                        Navigator.of(context)
                            .pop({"newFriend": newFriend, "thumbnail": null});
                      } else {
                        Navigator.of(context)
                            .pop({"newFriend": newFriend, "thumbnail": _image});
                      }
                      //   } else {
                      //     // do nothing
                      //     setState(() {
                      //       errorMessage = "Invalid phone number";
                      //     });
                      //   }
                      // });
                    } else {
                      isValidPhoneNumber = false;
                    }
                  } catch (e) {
                    isValidPhoneNumber = false;
                  }
                },
                child: Text('Submit'),
              )
            ],
          ),
        )
      ],
    );
  }

  // void onPhoneNumberChange(
  //     String number, String internationalizedPhoneNumber, String isoCode) {
  //   phoneNumber = number;
  //   phoneISOCode = isoCode;
  // }

  Future getImage() async {
    var picker = ImagePicker();
    var pickedFile = await picker.getImage(
        source: ImageSource.gallery, maxWidth: 200.0, maxHeight: 200.0);
    if (pickedFile != null) {
      await File(pickedFile.path).readAsBytes().then((value) {
        setState(() {
          _image = value;
        });
      });
    }
  }
}
