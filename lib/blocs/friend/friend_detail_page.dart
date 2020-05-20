import 'package:flutter/cupertino.dart';
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
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.currentFriend.displayName),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                  child: (widget.currentFriend.thumbnail.isEmpty == true)
                      ? Image.asset('graphics/default_user_thumbnail.png')
                      : Image.network(widget.currentFriend.thumbnail),
                  height: 200),
            ),
            Text(widget.currentFriend.displayName),
            Expanded(
                flex: 2,
                child: Container(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: thoughtOptions.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return Container(
                              width: 90.0,
                              child: InkWell(
                                  onTap: () {
                                    sendThought(widget.currentFriend,
                                        thoughtOptions[index].code);
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

  sendThought(FriendModel friend, String thoughtOptionCode) {
    CommonBloc.of(context).thoughtRepository.addThought(
        new ThoughtModel(
            null, friend.friendUserId, thoughtOptionCode, DateTime.now()),
        context);
    Navigator.of(context).pop();
  }

  deleteFriend() {
    CommonBloc.of(context)
        .friendProvider
        .removeFriend(widget.currentFriend.friendUserId, context);
  }
}
