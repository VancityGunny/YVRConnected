import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yvrconnected/blocs/friend/friend_bloc.dart';
import 'package:yvrconnected/blocs/friend/friend_event.dart';
import 'package:yvrconnected/blocs/friend/friend_stat_model.dart';
import 'package:yvrconnected/blocs/thought/index.dart';

import 'package:yvrconnected/common/global_object.dart' as globals;
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

    thoughtProvider.fetchTopFive().then((result) {
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
          child: ListView.builder(
              itemCount: topFiveFriends.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return ListTile(
                  leading: Icon(Icons.favorite),
                  title: Text(topFiveFriends[index].friend.displayName +
                      ':' +
                      topFiveFriends[index].thoughtSent.toString()),
                );
              }),
        )),
        Expanded(
          child: Container(
            child: StreamBuilder(stream: Firestore.instance.collection('/thoughts')
        .document(globals.currentUserId)
        .snapshots(),
        builder: (context,snapshot){
          if(!snapshot.hasData){ return Center(
              child: CircularProgressIndicator(),
            );}
            return GridView.builder(
              itemCount: snapshot.data.data['receivedThoughts'].length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      viewThought(ThoughtModel.fromJson(snapshot.data.data['receivedThoughts'][index]));
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
                          Container(child: Icon(Icons.email), height: 80),
                          Text(snapshot.data.data['receivedThoughts'][index]['thoughtOptionCode'],
                              style: TextStyle(color: Colors.deepPurple))
                        ],
                      ),
                    ));
              },
            );
        })
            
          ),
        ),
      ],
    );
  }

  void viewThought(ThoughtModel latestThought) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(child: Text(latestThought.fromUserId)),
                  )
                ],
              ));
        });
  }
}
