import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yvrconnected/blocs/friend/index.dart';
import 'package:yvrconnected/blocs/thought/index.dart';

class FriendScreen extends StatefulWidget {
  @override
  FriendScreenState createState() {
    return FriendScreenState();
  }
}

class FriendScreenState extends State<FriendScreen> {
  ThoughtBloc _thoughtBloc;

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
    return BlocBuilder<FriendBloc, FriendState>(
        bloc: BlocProvider.of<FriendBloc>(context),
        builder: (
          BuildContext context,
          FriendState currentState,
        ) {
          if (currentState is UninitFriendState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentState is ErrorFriendState) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(currentState.errorMessage ?? 'Error'),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: RaisedButton(
                    color: Colors.blue,
                    child: Text('reload'),
                    onPressed: () => this._load(),
                  ),
                ),
              ],
            ));
          }
          if (currentState is FriendsLoadedState) {
            FriendPage.of(context).friends = currentState.friends;
            return GridView.builder(
              itemCount: currentState.friends.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                    onLongPress: () {
                      openActionOptions(currentState.friends[index]);
                    }, // open action option, miss, remind, grateful
                    onLongPressUp:
                        selectActionOption, // long press release so select whatever was selected
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          Container(
                              child: Image.asset(
                                  'graphics/default_user_thumbnail.png'),
                              height: 80),
                          Text(
                              FriendPage.of(context).friends[index].displayName,
                              style: TextStyle(color: Colors.deepPurple))
                        ],
                      ),
                    ));
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  void _load([bool isError = false]) {
    BlocProvider.of<FriendBloc>(context).add(LoadFriendEvent(isError));
  }

  void openActionOptions(FriendModel friend) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: ListView(
                children: <Widget>[
                  InkWell(
                      onTap: () {
                        sendThought(friend, 'MIS');
                      },
                      child: ListTile(
                        leading: Icon(Icons.favorite),
                        title: Text('Miss You'),
                      )),
                  InkWell(
                      onTap: () {
                        sendThought(friend, 'THN');
                      },
                      child: ListTile(
                        leading: Icon(Icons.favorite),
                        title: Text('Thinking of You'),
                      )),
                  InkWell(
                      onTap: () {
                        sendThought(friend, 'RMN');
                      },
                      child: ListTile(
                        leading: Icon(Icons.favorite),
                        title: Text('Reminded of You'),
                      )),
                  InkWell(
                      onTap: () {
                        sendThought(friend, 'NST');
                      },
                      child: ListTile(
                        leading: Icon(Icons.favorite),
                        title: Text('Nostalgia over old time'),
                      )),
                ],
              ));
        });
  }

  void selectActionOption() {}

  sendThought(FriendModel friend, String thoughtOptionCode) {
    _thoughtBloc.add(AddingThoughtEvent(new ThoughtModel(
        null, friend.friendUserId, thoughtOptionCode, DateTime.now())));

    Navigator.of(context).pop();
  }
}
