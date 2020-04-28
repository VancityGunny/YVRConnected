import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yvrconnected/blocs/friend/index.dart';

class FriendScreen extends StatefulWidget {
    final FriendBloc _friendBloc;

   const FriendScreen({
    Key key,
    @required FriendBloc friendBloc,
  })  : _friendBloc = friendBloc,
        super(key: key);



  @override
  FriendScreenState createState() {
    return FriendScreenState();
  }
}

class FriendScreenState extends State<FriendScreen> {

  List<FriendModel> _friends;
  @override
  void initState() {
    super.initState();
    this._load();
    widget._friendBloc.add(LoadingFriends()); // default to load all friends
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendBloc, FriendState>(
        bloc: widget._friendBloc,
        builder: (
          BuildContext context,
          FriendState currentState,
        ) {
          if (currentState is Uninitialized) {
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
          if (currentState is Loaded) {
            _friends = currentState.friends;
            return Column(children: <Widget>[
              
              ListView.builder(
                shrinkWrap: true,
                itemBuilder: (BuildContext ctxt, int index) {
                  return Card(
                    child: Column(
                      children: <Widget>[
                        Image.asset('assets/macbook.jpg'),
                        Text(_friends[index].displayName,
                            style: TextStyle(color: Colors.deepPurple))
                      ],
                    ),
                  );
                },
                itemCount: currentState.friends.length,
              )
            ]);
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  void _load([bool isError = false]) {
    widget._friendBloc.add(LoadFriendEvent(isError));
  }

}
