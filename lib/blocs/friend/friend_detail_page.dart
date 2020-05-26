import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yvrconnected/blocs/friend/index.dart';
import 'package:yvrconnected/blocs/thought/index.dart';
import 'package:yvrconnected/common/common_bloc.dart';

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
    var thoughtOptions = CommonBloc.of(context).thoughtOptions;

    var isRecent = true;
    BoxDecoration friendDecoration = BoxDecoration();
    if (widget.currentFriend.lastThoughtSentDate == null ||
        widget.currentFriend.lastThoughtSentDate
                .add(new Duration(hours: 24))
                .compareTo(DateTime.now()) <
            0) {
      isRecent = false;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.currentFriend.displayName),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                child: Column(
              children: <Widget>[
                Container(
                    color: Colors.red,
                    alignment: Alignment.topCenter,
                    child: (widget.currentFriend.thumbnail.isEmpty == true)
                        ? Image.asset('graphics/default_user_thumbnail.png')
                        : Image.network(widget.currentFriend.thumbnail,
                            width: 200)),
                Text(widget.currentFriend.displayName)
              ],
            )),
            Expanded(
              child: Column(
                children: <Widget>[
                  (isRecent == true)
                      ? Text(widget.currentFriend.lastThoughtSentOption)
                      : Container(
                          child: RaisedButton(
                              child: Text('Thinking of You'),
                              onPressed: () {
                                openActionOptions(widget.currentFriend);
                              })),
                  Expanded(child: Text('')),
                  RaisedButton(
                    onPressed: deleteFriend,
                    child: Text('DELETE FRIEND'),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  void openActionOptions(FriendModel friend) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
              title: Text("Send Thought"),
              children: <Widget>[new FriendOptionsDialog(friend)]);
        });
  }

  deleteFriend() {
    CommonBloc.of(context)
        .friendProvider
        .removeFriend(widget.currentFriend.friendUserId, context);
  }
}
