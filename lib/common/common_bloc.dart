import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yvrconnected/blocs/friend/index.dart';
import 'package:yvrconnected/blocs/user/user_model.dart';

import 'package:yvrconnected/common/global_object.dart' as globals;

class CommonBloc extends InheritedWidget {
  StreamController friendsController;
  FriendProvider friendProvider = new FriendProvider();
  FriendBloc friendBloc = FriendBloc();
  UserModel loggedInUser = null;
  String currentUserId = null;
  BehaviorSubject<List<FriendModel>> allFriends =
      BehaviorSubject<List<FriendModel>>();
  //List<FriendModel> allFriends = null;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  CommonBloc({Key key, Widget child}) : super(key: key, child: child);

  static CommonBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CommonBloc>();
  }

  initStream() {
    friendsController = StreamController.broadcast();
    friendsController.addStream(Firestore.instance
        .collection('/users')
        .document(globals.currentUserId)
        .snapshots());
    friendsController.stream.listen((event) {
      DocumentSnapshot docs = event;
      if (docs.data != null) {
        var newFriendsList = new List<FriendModel>();

        event.data['friends'].forEach((f) {
          newFriendsList.add(FriendModel.fromJson(f));
        });
        // var newSet =
        //     event.data['friends'].map((f) => FriendModel.fromJson(f));

        allFriends.add(newFriendsList);
      }
    });
  }
}
