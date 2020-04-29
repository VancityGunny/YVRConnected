import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:yvrconnected/blocs/friend/index.dart';

class FriendPage extends StatefulWidget {
  static const String routeName = '/friend';

  @override
  _FriendPageState createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  FriendBloc _friendBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _friendBloc = FriendBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friend'),
      ),
      body: FriendScreen(
        friendBloc: this._friendBloc,
      ),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: _addFriend),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _addFriend() async {
    final EmailContact contact = await FlutterContactPicker.pickEmailContact();
    FriendModel newFriend = new FriendModel(contact.email.email, contact.fullName);
    _friendBloc.add(AddingFriend(newFriend));
  }
}
