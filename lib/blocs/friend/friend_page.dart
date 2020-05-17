import 'dart:typed_data';

import 'package:contacts_service/contacts_service.dart' as CS;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yvrconnected/blocs/friend/index.dart';

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<FriendBloc>(context)
        .add(LoadingFriendsEvent()); // default to load all friends
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friend'),
      ),
      body: FriendScreen(),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: _addFriend),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _addFriend() async {
    // make sure that the friend is not already in the list
    final EmailContact contact = await FlutterContactPicker.pickEmailContact();

    FriendModel dupFriend = friends
        .firstWhere((f) => f.email == contact.email.email, orElse: () => null);

    if (dupFriend == null) {
      Uint8List thumbnail;
      // fetch more contact detail
      if (await Permission.contacts.request().isGranted) {
        Iterable<CS.Contact> foundContacts =
            await CS.ContactsService.getContacts(query: contact.fullName);
        if (foundContacts.length > 0) {
          thumbnail = foundContacts.first.avatar;
          this.friendThumbnail = thumbnail;
        }
        // Either the permission was already granted before or the user just granted it.
      }
      FriendModel newFriend = new FriendModel(
          null, contact.email.email, contact.fullName, null, null, null);
      BlocProvider.of<FriendBloc>(context)
          .add(AddingFriendEvent(newFriend, thumbnail));
    } else {
      //return duplicate contact error
    }
  }
}
