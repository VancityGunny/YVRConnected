import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yvrconnected/blocs/authentication/index.dart';
import 'package:yvrconnected/blocs/friend/index.dart';
import 'package:yvrconnected/blocs/thought/index.dart';
import 'package:yvrconnected/common/common_bloc.dart';
import 'package:yvrconnected/ui/home_latest_widget.dart';

class HomeScreen extends StatefulWidget {
  final String name;

  HomeScreen(this.name);
  @override
  HomeScreenState createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  FriendBloc _friendBloc;
  StreamController ctrl;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _friendBloc = FriendBloc();
  }
  
  @override
  Widget build(BuildContext context) {
    // set user stream
    CommonBloc.of(context).initStream();

    return MultiBlocProvider(
        providers: [
          BlocProvider<FriendBloc>(
            create: (BuildContext context) => _friendBloc,
          ),
          BlocProvider<ThoughtBloc>(
            create: (BuildContext context) => ThoughtBloc(),
          ),
        ],
        child: Scaffold(
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
            body: HomeLatestWidget()));
  }

  void _goToContactScreen(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return BlocProvider(
            create: (BuildContext context) => FriendBloc(),
            child: FriendPage());
      }),
    );
  }
}
