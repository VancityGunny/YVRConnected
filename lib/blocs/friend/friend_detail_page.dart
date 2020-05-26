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
              child: Container(
                alignment: Alignment.topCenter,
                  child: (widget.currentFriend.thumbnail.isEmpty == true)
                      ? Image.asset('graphics/default_user_thumbnail.png')
                      : Image.network(widget.currentFriend.thumbnail, width:200)),
            ),
            Text(widget.currentFriend.displayName),
            (isRecent==true)?Text(widget.currentFriend.lastThoughtSentOption):
            Expanded(
                child: Container(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: thoughtOptions.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return Container(
                              width: 90.0,
                              child: InkWell(
                                  onTap: () {
                                    if (!isRecent) {
                                      sendThought(widget.currentFriend,
                                          thoughtOptions[index].code, null);
                                    }
                                  },
                                  child: ListTile(
                                    title: thoughtOptions[index].icon,
                                    subtitle:
                                        Text(thoughtOptions[index].caption),
                                  )));
                        }))),
            Container(
              child: RaisedButton(
                onPressed: deleteFriend,
                child: Text('DELETE FRIEND'),
              ),
            )
          ],
        ));
  }

  sendThought(FriendModel friend, String thoughtOptionCode, File image) {
    CommonBloc.of(context).thoughtRepository.addThought(
        new ThoughtModel(
            null, friend.friendUserId, thoughtOptionCode, DateTime.now(), null),
        image,
        context);
    Navigator.of(context).pop();
  }

  deleteFriend() {
    CommonBloc.of(context)
        .friendProvider
        .removeFriend(widget.currentFriend.friendUserId, context);
  }
}
