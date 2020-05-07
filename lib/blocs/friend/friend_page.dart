import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:yvrconnected/blocs/friend/index.dart';

class FriendPage extends StatefulWidget {
  static const String routeName = '/friend';

  @override
  _FriendPageState createState() => _FriendPageState();

  static _FriendPageState of(BuildContext context) {
    final _FriendPageState navigator = context.findAncestorStateOfType<_FriendPageState>();

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
  FriendBloc _friendBloc;
  List<FriendModel> friends;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _friendBloc = FriendBloc();
    _friendBloc.add(LoadingFriendsEvent()); // default to load all friends
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
    // make sure that the friend is not already in the list
    final EmailContact contact = await FlutterContactPicker.pickEmailContact();
    
    FriendModel newFriend = new FriendModel(null, contact.email.email, contact.fullName);
    FriendModel dupFriend = friends.firstWhere((f) => f.email == newFriend.email, orElse: () => null);
    if(dupFriend==null){
      _friendBloc.add(AddingFriendEvent(newFriend));
    }
    else{
      //return duplicate contact error
    }
    
  }
}
