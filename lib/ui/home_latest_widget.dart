import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

class HomeLatestWidgetState extends State<StatefulWidget> {
  List<FriendStatModel> topFiveFriends = List<FriendStatModel>();
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
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return ListTile(
                    leading: Icon(Icons.favorite),
                    title: Text(snapshot.data[index].friend.displayName +
                        ':' +
                        snapshot.data[index].thoughtSent.toString()),
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

  void viewThought(ThoughtModel latestThought) {
    var currentFriend = CommonBloc.of(context).allFriends.value.firstWhere(
        (element) => element.friendUserId == latestThought.fromUserId);

    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: Container(
                    child: (currentFriend != null &&
                            currentFriend.thumbnail.isEmpty == true)
                        ? Image.asset('graphics/default_user_thumbnail.png')
                        : Image.network(currentFriend.thumbnail),
                  )),
                  Expanded(
                    child: Container(child: Text(latestThought.fromUserId)),
                  )
                ],
              ));
        });
  }
}
