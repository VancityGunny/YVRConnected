import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yvrconnected/blocs/friend/index.dart';
import 'package:yvrconnected/blocs/thought/index.dart';
import 'package:yvrconnected/common/global_object.dart' as globals;

class CommonBloc extends InheritedWidget {
  final StreamController friendsController = StreamController.broadcast();
  final StreamController thoughtsController = StreamController.broadcast();
  final FriendProvider friendProvider = new FriendProvider();

  final BehaviorSubject<List<FriendModel>> allFriends =
      BehaviorSubject<List<FriendModel>>();
  final BehaviorSubject<List<ThoughtModel>> allReceivedThoughts =
      BehaviorSubject<List<ThoughtModel>>();
  final BehaviorSubject<List<ThoughtModel>> allSentThoughts =
      BehaviorSubject<List<ThoughtModel>>();
  final BehaviorSubject<List<FriendStatModel>> topFiveFriends =
      BehaviorSubject<List<FriendStatModel>>();

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  CommonBloc({Key key, Widget child}) : super(key: key, child: child);

  static CommonBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CommonBloc>();
  }

  initStream() {
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
        allFriends.add(newFriendsList);
      }
    });

    thoughtsController.addStream(Firestore.instance
        .collection('/thoughts')
        .document(globals.currentUserId)
        .snapshots());
    thoughtsController.stream.listen((event) {
      DocumentSnapshot docs = event;
      if (docs.data != null) {
        var newReceivedThoughtsList = new List<ThoughtModel>();
        var newSentThoughtsList = new List<ThoughtModel>();
        docs.data['receivedThoughts'].forEach((t) {
          newReceivedThoughtsList.add(ThoughtModel.fromJson(t));
        });
        docs.data['sentThoughts'].forEach((t) {
          newSentThoughtsList.add(ThoughtModel.fromJson(t));
        });

        allReceivedThoughts.add(newReceivedThoughtsList);
        allSentThoughts.add(newSentThoughtsList);
        topFiveFriends.add(fetchTopFive());
      }
    });
  }

  List<FriendStatModel> fetchTopFive() {
    var thoughtsSentLastMonth = allSentThoughts.value.where((t) =>
        t.createdDate.add(new Duration(days: 30)).compareTo(DateTime.now()) >=
        0);
    var thoughtsSentByFriend =
        groupBy(thoughtsSentLastMonth, (t) => t.toUserId);

    List<FriendStatModel> newStat = List<FriendStatModel>();
    thoughtsSentByFriend.forEach((index, value) {
      FriendModel myFriend =
          allFriends.value.where((f) => f.friendUserId == index).first;
      newStat.add(new FriendStatModel(myFriend, value.length));
    });
    newStat.sort((a, b) {
      return b.thoughtSent
          .compareTo(a.thoughtSent); //order from most thought sent to
    });
    return newStat.take(5).toList();
  }
}
