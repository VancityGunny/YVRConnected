import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yvrfriends/blocs/authentication/index.dart';
import 'package:yvrfriends/blocs/friend/index.dart';
import 'package:yvrfriends/blocs/thought/index.dart';
import 'package:yvrfriends/common/common_bloc.dart';
import 'package:yvrfriends/generated/l10n.dart';
import 'package:yvrfriends/ui/home_latest_widget.dart';

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _friendBloc = FriendBloc();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _friendBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final delegate = S.of(context);
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
              title: Text('YVRFriends'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.contacts,
                  ),
                  onPressed: () {
                    _goToContactScreen(context);
                  },
                ),
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.infoCircle),
                  onPressed: () {
                    // go to about page
                    showAboutDialog(
                        context: context,
                        applicationName: 'YVRFriends',
                        applicationVersion: '0.0.1b');
                  },
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.signOutAlt),
                  onPressed: () {
                    // confirm before sign out
                    showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: Text(delegate.signOutLabel + '?'),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  BlocProvider.of<AuthBloc>(context).add(
                                    LoggedOutEvent(),
                                  );
                                  Navigator.of(context).pop();
                                },
                                child: Text(delegate.yesButton),
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(delegate.noButton),
                              ),
                            ],
                          );
                        },
                        barrierDismissible: false);
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
