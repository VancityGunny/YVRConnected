import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yvrconnected/common/commonfunctions.dart';
import 'package:yvrconnected/models/friend_model.dart';
import '../blocs/contact_bloc.dart';

class PortalPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PortalPageState();
  }
}

class _PortalPageState extends State<PortalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YVRHuman'),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: viewHome,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.favorite),
            color: Colors.white,
            onPressed: showContactListPage,
          ),
           IconButton(
            icon: const Icon(Icons.remove_circle),
            color: Colors.white,
            onPressed: logout,
                      )
                    ],
                  ),
                  body: FriendList(),
                );
              }
            
              void viewHome() {
                CommonFunctions.goHome(context);
              }
            
              void showContactListPage() {}
            
              void logout() {
                CommonFunctions.signOut(context);
  }
}

// List of all the statistic of love sent out from user
class LoveSentList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView (
      children: [Text('miss 19 people'), Text('remind of 12 people'), Text('grateful for 5 people')]
    );
  }
}

class FriendList extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    bloc.fetchAllFriends();
    return StreamBuilder(
        stream: bloc.allFriends,
        builder: (context, AsyncSnapshot<FriendModel> snapshot) {
          if (snapshot.hasData) {
            return buildList(snapshot);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        },
      );   
  }
  Widget buildList(AsyncSnapshot<FriendModel> snapshot) {
    return GridView.builder(
        itemCount: 2,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return Text(snapshot.data.name);
        });
  }
}
