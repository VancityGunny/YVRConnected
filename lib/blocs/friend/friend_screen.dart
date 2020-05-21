import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yvrconnected/blocs/friend/index.dart';
import 'package:yvrconnected/blocs/thought/index.dart';
import 'package:yvrconnected/common/common_bloc.dart';

class FriendScreen extends StatefulWidget {
  @override
  FriendScreenState createState() {
    return FriendScreenState();
  }
}

class FriendScreenState extends State<FriendScreen> {
  ThoughtBloc _thoughtBloc;
  StreamController controller;
  @override
  void initState() {
    super.initState();
    _thoughtBloc = new ThoughtBloc();
    this._load();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: CommonBloc.of(context).allFriends.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return GridView.builder(
            itemCount: snapshot.data.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemBuilder: (context, index) {
              var isRecent = true;
              FriendModel curFriend = snapshot.data[index];
              BoxDecoration friendDecoration = BoxDecoration();
              if (curFriend.lastThoughtSentDate == null ||
                  curFriend.lastThoughtSentDate
                          .add(new Duration(hours: 24))
                          .compareTo(DateTime.now()) <
                      0) {
                isRecent = false;
                friendDecoration = BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                  backgroundBlendMode: BlendMode.saturation,
                );
              }

              return GestureDetector(
                  onTap: () {
                    goToFriendDetail(curFriend);
                  },
                  onLongPress: () {
                    // not allow resend thought within 24 hours
                    if (isRecent == false) {
                      openActionOptions(curFriend);
                    }
                  }, // open action option, miss, remind, grateful
                  // onLongPressUp:
                  //     selectActionOption, // long press release so select whatever was selected
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Container(
                            foregroundDecoration: friendDecoration,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  image: (curFriend.thumbnail.isEmpty == true)
                                      ? Image.asset(
                                              'graphics/default_user_thumbnail.png')
                                          .image
                                      : Image.network(curFriend.thumbnail)
                                          .image,
                                  fit: BoxFit.cover),
                            ),
                            width: 80,
                            height: 80),
                        Container(
                          child: Flexible(
                            child: Align(
                                child: Text(curFriend.displayName,
                                    style: TextStyle(color: Colors.deepPurple)),
                                alignment: Alignment.topLeft),
                          ),
                        )
                      ],
                    ),
                  ));
            },
          );
        });
  }

  void _load([bool isError = false]) {
    BlocProvider.of<FriendBloc>(context).add(LoadFriendEvent(isError));
  }

  void openActionOptions(FriendModel friend) {
    var thoughtOptions = CommonBloc.of(context).thoughtOptions;
    List<Widget> thoughtWidgets = new List<Widget>();
    thoughtOptions.forEach((thoughtOption) {
      var newThoughtWidget = new SimpleDialogOption(
          onPressed: () {
            sendThought(friend, thoughtOption.code);
          },
          child: ListTile(
            leading: thoughtOption.icon,
            title: Text(thoughtOption.caption),
          ));
      thoughtWidgets.add(newThoughtWidget);
    });
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
              title: Text("Send Thought"), children: thoughtWidgets);
        });
  }

  sendThought(FriendModel friend, String thoughtOptionCode) {
    _thoughtBloc.add(
      AddingThoughtEvent(
          new ThoughtModel(
              null, friend.friendUserId, thoughtOptionCode, DateTime.now()),
          context),
    );

    Navigator.of(context).pop();
  }

  goToFriendDetail(FriendModel friend) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return MultiBlocProvider(providers: [
          BlocProvider<FriendBloc>(
            create: (BuildContext context) =>
                BlocProvider.of<FriendBloc>(context),
          ),
          BlocProvider<ThoughtBloc>(
            create: (BuildContext context) => _thoughtBloc,
          ),
        ], child: FriendDetailPage(friend));
      }),
    );
  }
}
