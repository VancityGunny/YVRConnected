import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yvrconnected/blocs/authentication/index.dart';
import 'package:yvrconnected/blocs/friend/friend_screen.dart';
import 'package:yvrconnected/blocs/friend/index.dart';

class HomeScreen extends StatelessWidget {
  final String name;


  HomeScreen({Key key, @required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.contacts),
            onPressed: () {
              _goToContactScreen(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(
                LoggedOutEvent(),
              );
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(child: Text('Welcome $name!')),
        ],
      ),
    );
  }

  void _goToContactScreen(context) {
    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => FriendPage(),
                    ),
                  );
  }
}
