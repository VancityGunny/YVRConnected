import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yvrconnected/blocs/friend/index.dart';

class FriendDetailPage extends StatefulWidget {
  static const String routeName = '/friendDetail';
  final FriendModel currentFriend;

  @override
  FriendDetailPage(this.currentFriend);

  @override
  FriendDetailPageState createState() => FriendDetailPageState();
}

class FriendDetailPageState extends State<FriendDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text(widget.currentFriend.displayName),
      ),
        body: Column(
      children: <Widget>[
        Expanded(
          child: Container(
            
              child: (widget.currentFriend.thumbnail.isEmpty == true)
                  ? Image.asset('graphics/default_user_thumbnail.png')
                  : Image.network(widget.currentFriend.thumbnail),
              height: 200),
        ),
        Expanded(
          child: Text(widget.currentFriend.displayName),
        ),
      ],
    ));
  }
}
