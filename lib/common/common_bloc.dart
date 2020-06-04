import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yvrconnected/blocs/friend/index.dart';
import 'package:yvrconnected/blocs/interaction/interaction_model.dart';
import 'package:yvrconnected/blocs/thought/index.dart';
import 'package:yvrconnected/blocs/thought/thought_option_model.dart';
import 'package:yvrconnected/common/global_object.dart' as globals;

class CommonBloc extends InheritedWidget {
  StreamController friendsController;
  StreamController thoughtsController;
  final FriendProvider friendProvider = new FriendProvider();
  final ThoughtRepository thoughtRepository = new ThoughtRepository();

  final BehaviorSubject<List<FriendModel>> allFriends =
      BehaviorSubject<List<FriendModel>>();
  final BehaviorSubject<List<FriendModel>> allSenders =
      BehaviorSubject<List<FriendModel>>();
  final BehaviorSubject<List<ThoughtModel>> allReceivedThoughts =
      BehaviorSubject<List<ThoughtModel>>();
  final BehaviorSubject<List<ThoughtModel>> allSentThoughts =
      BehaviorSubject<List<ThoughtModel>>();
  final BehaviorSubject<List<InteractionModel>> allSentInteractions =
      BehaviorSubject<List<InteractionModel>>();
  final BehaviorSubject<List<FriendStatModel>> topFiveFriends =
      BehaviorSubject<List<FriendStatModel>>();

  final thoughtOptions = [
    ThoughtOptionModel('MISS', 'Miss you', FaIcon(FontAwesomeIcons.solidSmileWink)),
    ThoughtOptionModel(
        'WISH', 'Wish U were here', FaIcon(FontAwesomeIcons.streetView)),
    ThoughtOptionModel(
        'GOLD', 'Good old time', FaIcon(FontAwesomeIcons.glassCheers)),
    ThoughtOptionModel(
        'GRAT', 'Grateful for you', FaIcon(FontAwesomeIcons.prayingHands))
  ];

  final interactionOptions = [
    ThoughtOptionModel(
        'CALL', 'Phone Call', FaIcon(FontAwesomeIcons.phoneVolume)),
    ThoughtOptionModel('VIDEO', 'Video Call', FaIcon(FontAwesomeIcons.video)),
    ThoughtOptionModel(
        'IRL', 'In Person', FaIcon(FontAwesomeIcons.userFriends)),
  ];

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
        allFriends.add(newFriendsList);

        var newSendersList = new List<FriendModel>();
        event.data['senders'].forEach((f) {
          newSendersList.add(FriendModel.fromJson(f));
        });
        allSenders.add(newSendersList);
      }
    });

    thoughtsController = StreamController.broadcast();
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
        try {
          var newSentInteractionsList = new List<InteractionModel>();
          docs.data['sentInteractions'].forEach((t) {
            newSentInteractionsList.add(InteractionModel.fromJson(t));
          });
          allSentInteractions.add(newSentInteractionsList);
        } catch (e) {
          // assume not exist, we have to add it to this
          this
              .thoughtRepository
              .updateSentInteractions(new List<InteractionModel>());
        }

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

    var currentFriends = allFriends.value;
    List<FriendStatModel> newStat = List<FriendStatModel>();
    thoughtsSentByFriend.forEach((index, value) {
      // only care about my currentFriends
      if (currentFriends.any((f) => f.friendUserId == index)) {
        FriendModel myFriend =
            allFriends.value.where((f) => f.friendUserId == index).first;
        newStat.add(new FriendStatModel(myFriend, value.length));
      }
    });
    newStat.sort((a, b) {
      return b.thoughtSent
          .compareTo(a.thoughtSent); //order from most thought sent to
    });
    return newStat.take(5).toList();
  }

  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  void markThoughtAsRead(String thoughtId) {
    var readThought = this.allReceivedThoughts.value.firstWhere(
        (element) => element.thoughtId == thoughtId,
        orElse: () => null);
    if (readThought != null) {
      readThought.readFlag = true;
      // now update the received thoughts
      thoughtRepository.updateReceivedThoughts(this.allReceivedThoughts.value);
    }
  }
}
