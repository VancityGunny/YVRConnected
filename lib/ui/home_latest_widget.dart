import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yvrconnected/blocs/friend/friend_stat_model.dart';
import 'package:yvrconnected/blocs/thought/index.dart';
import 'package:yvrconnected/common/common_bloc.dart';

// Widget to show all latest thoughts received
class HomeLatestWidget extends StatefulWidget {
  @override
  HomeLatestWidgetState createState() {
    // TODO: implement createState
    return HomeLatestWidgetState();
  }
}

class HomeLatestWidgetState extends State<HomeLatestWidget> {
  List<FriendStatModel> topFiveFriends = List<FriendStatModel>();

  final RelativeRectTween relativeRectTween = RelativeRectTween(
    begin: RelativeRect.fromLTRB(0, 10, 0, 0),
    end: RelativeRect.fromLTRB(0, 0, 0, 0),
  );

  Animation<RelativeRect> headBobingAnimation;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    //load latest thoughts
    ThoughtProvider thoughtProvider = ThoughtProvider();

    thoughtProvider.fetchTopFive(context).then((result) {
      // If we need to rebuild the widget with the resulting data,
      // make sure to use `setState`
      setState(() {
        topFiveFriends = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            child: RichText(
                text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
              TextSpan(text: 'Your'),
              TextSpan(text: ' Top'),
              TextSpan(text: ' Friends')
            ]))),
        Expanded(
            child: Container(
                child: StreamBuilder(
          stream: CommonBloc.of(context).topFiveFriends.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data.length == 0) {
              return Container(
                  alignment: Alignment.center,
                  child: FaIcon(FontAwesomeIcons.userPlus,
                      size: 150, color: Color.fromARGB(15, 0, 0, 0)));
            }
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return Container(
                    width: 70.0,
                    child: Stack(children: <Widget>[
                      FlareActor(
                        "graphics/Shinchan.flr",
                        animation: 'idle',
                        fit: BoxFit.contain,
                      ),
                      Positioned(
                          top: 60,
                          left: 12,
                          child: ClipOval(
                              child: Align(
                                  alignment: Alignment.center,
                                  widthFactor: 0.85,
                                  heightFactor: 1.0,
                                  child: (snapshot
                                              .data[index].friend.thumbnail ==
                                          null)
                                      ? Image.asset(
                                          'graphics/default_user_thumbnail.png',
                                          width: 50.0,
                                          height: 50.0,
                                        )
                                      : Image.network(
                                          snapshot.data[index].friend.thumbnail,
                                          width: 50.0,
                                          height: 50.0,
                                        )))),
                      Positioned(
                        top: 52.0,
                        left: 5.0,
                        child: (index % 2 == 0)
                            ? Image.asset(
                                'graphics/boyhair.png',
                                width: 60.0,
                                height: 60.0,
                              )
                            : Image.asset(
                                'graphics/girlhair.png',
                                width: 60.0,
                                height: 60.0,
                              ),
                      )
                    ]),
                  );
                });
          },
        ))),
        Expanded(
          child: Container(
              child: StreamBuilder(
                  stream: CommonBloc.of(context).allReceivedThoughts.stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data.length == 0) {
                      return Container(
                          alignment: Alignment.center,
                          child: FaIcon(FontAwesomeIcons.folderPlus,
                              size: 150, color: Color.fromARGB(15, 0, 0, 0)));
                    }
                    return GridView.builder(
                      itemCount: snapshot.data.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              viewThought(snapshot.data[index]);
                            },
                            onLongPress: () {
                              //TODO: open the message
                            }, // open action option, miss, remind, grateful
                            onLongPressUp: () {
                              //TODO: selectActionOption, // long press release so select whatever was selected
                            },
                            child: Card(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      child: Icon(Icons.email), height: 80),
                                  Text(snapshot.data[index].thoughtOptionCode,
                                      style:
                                          TextStyle(color: Colors.deepPurple))
                                ],
                              ),
                            ));
                      },
                    );
                  })),
        ),
      ],
    );
  }

  Future linkInstagramFeed(String postId) {
    //print something
    var linkUrl = postId;
  }

  void viewThought(ThoughtModel latestThought) async {
    var currentFriend = CommonBloc.of(context).allFriends.value.firstWhere(
        (element) => element.friendUserId == latestThought.fromUserId);
    var selectedThoughtType = CommonBloc.of(context).thoughtOptions.firstWhere(
        (element) => latestThought.thoughtOptionCode == element.code);

    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: new LayoutBuilder(builder: (context, constraint) {
                    return new Icon(selectedThoughtType.icon.icon,
                        size: constraint.biggest.height);
                  })),
                  Expanded(
                    child:
                        Text(selectedThoughtType.caption, textScaleFactor: 2.0),
                  ),
                  Expanded(
                      child: Container(
                    child: (currentFriend != null &&
                            currentFriend.thumbnail == null)
                        ? Image.asset('graphics/default_user_thumbnail.png')
                        : Image.network(currentFriend.thumbnail),
                  )),
                  (latestThought.imageUrl != null) ??
                      Expanded(child: Image.network(latestThought.imageUrl)),
                  Expanded(
                    child: Container(child: Text(latestThought.fromUserId)),
                  ),
                  Expanded(
                    child: Text(latestThought.createdDate.toString()),
                  )
                ],
              ));
        });
  }
}
