import 'dart:io';
import 'dart:typed_data';
import 'package:contacts_service/contacts_service.dart' as CS;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
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
    Uint8List thumbnail;
    // fetch more contact detail
    if (await Permission.contacts.request().isGranted) {
      Iterable<CS.Contact> foundContacts =
          await CS.ContactsService.getContacts(query: contact.fullName);
      if (foundContacts.length > 0) {
        thumbnail = foundContacts.first.avatar;
        this.friendThumbnail = (thumbnail.isEmpty == true) ? null : thumbnail;
      }

      // Either the permission was already granted before or the user just granted it.
    }
    //add dialog to confirm contact phone number, to catch any number without country code
    var result = await showDialog(
        context: context,
        builder: (_) {
          return FriendAddDialog(contact, thumbnail);
        });
    var newFriend;
    if (result != null) {
      newFriend = result["newFriend"];
      thumbnail = result["thumbnail"];
    } else {
      return;
    }
    FriendModel dupFriend = pageCommonBloc.allFriends.value
        .firstWhere((f) => f.phone == newFriend.phone, orElse: () => null);

    if (dupFriend == null) {
      BlocProvider.of<FriendBloc>(context)
          .add(AddingFriendEvent(newFriend, thumbnail));
    } else {
      //return duplicate contact error
    }
  }
}

class FriendAddDialog extends StatefulWidget {
  final PhoneContact contact;
  Uint8List thumbnail;
  FriendAddDialog(this.contact, this.thumbnail);

  @override
  FriendAddDialogState createState() {
    return FriendAddDialogState();
  }
}

class FriendAddDialogState extends State<FriendAddDialog> {
  List<String> allowedCountryCodes = ['JP', 'TH', 'CA', 'US', 'GB'];
  Future<Map<String, dynamic>> _formattedPhoneNumber;
  final TextEditingController txtPhoneController = TextEditingController();
  final intRegex = RegExp(r'(\d+)', multiLine: true);
  String phoneNumber;
  String phoneISOCode;
  bool isValidPhoneNumber = false;
  Uint8List _image;
  String errorMessage;
  final _friendFormKey = GlobalKey<FormState>();
  var newFriend =
      new FriendModel(null, null, null, null, null, null, null, null);
  List<Country> allowedCountries = new List<Country>();

  @override
  void initState() {
    super.initState();
    _image = widget.thumbnail;
    _formattedPhoneNumber = PhoneService.fetchCountryData(
            context, 'packages/international_phone_input/assets/countries.json')
        .then((list) {
      // only match allowed country code
      allowedCountries.addAll(
          list.where((element) => allowedCountryCodes.contains(element.code)));
      var pureNumber = intRegex
          .allMatches(widget.contact.phoneNumber.number)
          .map((m) => m.group(0));
      var pureNumberString = pureNumber.fold(
          '', (previousValue, element) => previousValue + element);
      List<Country> countries = PhoneService.getPotentialCountries(
          pureNumberString, allowedCountries);
      Map<String, dynamic> result = new Map<String, dynamic>();
      if (countries.length > 0) {
        result.putIfAbsent('formattedCountryCode', () => countries.first.code);
        //guessing this so extract that number out.
        pureNumberString = pureNumberString
            .toString()
            .substring(countries.first.dialCode.length - 1);
      }
      result.putIfAbsent('formattedPhoneNumber', () => pureNumberString);
      return result;
    });
  }

  @override
  Widget build(BuildContext context) {
    FriendModel newFriend =
        new FriendModel(null, null, null, null, null, null, null, null);
    return SimpleDialog(
      children: <Widget>[
        Form(
          key: _friendFormKey,
          child: Column(
            children: <Widget>[
              new TextFormField(
                initialValue: widget.contact.fullName,
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
              FutureBuilder(
                future: this._formattedPhoneNumber,
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, dynamic>> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  phoneNumber = snapshot.data['formattedPhoneNumber'];
                  if (snapshot.data['formattedCountryCode'] == null) {
                    phoneISOCode = 'CA'; // currently default is CA +1
                  } else {
                    phoneISOCode = snapshot.data['formattedCountryCode'];
                  }

                  return InternationalPhoneInput(
                    decoration:
                        InputDecoration.collapsed(hintText: '(123) 123-1234'),
                    initialPhoneNumber: snapshot.data['formattedPhoneNumber'],
                    initialSelection: snapshot.data['formattedCountryCode'],
                    enabledCountries: allowedCountryCodes,
                    showCountryCodes: true,
                    showCountryFlags: true,
                    onPhoneNumberChange: onPhoneNumberChange,
                    errorText: (isValidPhoneNumber != true)
                        ? "Invalid Phone Number"
                        : "",
                  );
                },
              ),
              Container(
                child: OutlineButton(
                  child: Text('Add Image'),
                  onPressed: getImage,
                ),
              ),
              Center(
                child: _image == null
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
                      PhoneService.parsePhoneNumber(phoneNumber, phoneISOCode)
                          .then((value) {
                        isValidPhoneNumber = value;
                        if (isValidPhoneNumber) {
                          newFriend.phone = this
                                  .allowedCountries
                                  .firstWhere(
                                      (element) => element.code == phoneISOCode)
                                  .dialCode +
                              phoneNumber.trim();
                        }

                        if (isValidPhoneNumber) {
                          // do save
                          if (_image == null) {
                            Navigator.of(context).pop(
                                {"newFriend": newFriend, "thumbnail": null});
                          } else {
                            Navigator.of(context).pop(
                                {"newFriend": newFriend, "thumbnail": _image});
                          }
                        } else {
                          // do nothing
                          setState(() {
                            errorMessage = "Invalid phone number";
                          });
                        }
                      });
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

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    phoneNumber = number;
    phoneISOCode = isoCode;
  }

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
