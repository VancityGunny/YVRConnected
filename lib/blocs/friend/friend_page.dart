import 'package:flutter/material.dart';
import 'package:yvrconnected/blocs/friend/index.dart';

class FriendPage extends StatefulWidget {
  static const String routeName = '/friend';

  @override
  _FriendPageState createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  final _friendBloc = FriendBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friend'),
      ),
      body: FriendScreen(friendBloc: _friendBloc),
    );
  }
}
