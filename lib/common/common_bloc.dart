import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yvrfriends/blocs/friend/index.dart';
import 'package:yvrfriends/blocs/interaction/interaction_model.dart';
import 'package:yvrfriends/blocs/thought/index.dart';
import 'package:yvrfriends/blocs/thought/thought_option_model.dart';
import 'package:yvrfriends/common/global_object.dart' as globals;
import 'package:yvrfriends/generated/l10n.dart';

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
  final BehaviorSubject<List<FriendStatModel>> needAttentionFriends =
      BehaviorSubject<List<FriendStatModel>>();

  static List<ThoughtOptionModel> thoughtOptions =
      new List<ThoughtOptionModel>();

  static List<ThoughtOptionModel> interactionOptions =
      new List<ThoughtOptionModel>();

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  CommonBloc({Key key, Widget child}) : super(key: key, child: child);

  static CommonBloc of(BuildContext context) {
    if (thoughtOptions.length == 0) {
      populateOptions(context);
    }
    return context.dependOnInheritedWidgetOfExactType<CommonBloc>();
  }

  static void populateOptions(BuildContext context) {
    final delegate = S.of(context);
    thoughtOptions.add(ThoughtOptionModel('MISS', delegate.codeMissYouShort,
        FaIcon(FontAwesomeIcons.solidSmileWink), delegate.codeMissYouLong));
    thoughtOptions.add(ThoughtOptionModel(
        'WISH',
        delegate.codeWishUWereHereShort,
        FaIcon(FontAwesomeIcons.streetView),
        delegate.codeWishUWereHereLong));
    thoughtOptions.add(ThoughtOptionModel('GOLD', delegate.codeGoodOldTimeShort,
        FaIcon(FontAwesomeIcons.glassCheers), delegate.codeGoodOldTimeLong));
    thoughtOptions.add(ThoughtOptionModel(
        'GRAT',
        delegate.codeGratefulForYouShort,
        FaIcon(FontAwesomeIcons.prayingHands),
        delegate.codeGratefulForYouLong));

    interactionOptions.add(ThoughtOptionModel(
        'CALL',
        delegate.codePhoneCallShort,
        FaIcon(FontAwesomeIcons.phoneVolume),
        delegate.codePhoneCallShort));

    interactionOptions.add(ThoughtOptionModel(
        'VIDEO',
        delegate.codeVideoCallShort,
        FaIcon(FontAwesomeIcons.video),
        delegate.codeVideoCallShort));
    interactionOptions.add(ThoughtOptionModel('IRL', delegate.codeInPersonShort,
        FaIcon(FontAwesomeIcons.userFriends), delegate.codeInPersonShort));
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
        needAttentionFriends.add(fetchLowestFive());
      }
    });
  }

  List<FriendStatModel> fetchLowestFive() {
    var currentFriends = allFriends.value;
    currentFriends.sort((a, b) {
      return ((a.lastInteractionSentDate == null)
              ? DateTime(1900)
              : a.lastInteractionSentDate)
          .compareTo((b.lastInteractionSentDate == null)
              ? DateTime(1900)
              : b.lastInteractionSentDate);
      //return a.lastInteractionSentDate.compareTo(b.lastInteractionSentDate);
    });
    List<FriendStatModel> newStat = List<FriendStatModel>();
    currentFriends.take(5).forEach((myFriend) {
      // only care about my currentFriends
      newStat.add(new FriendStatModel(myFriend, 0));
    });
    return newStat;
  }

  List<FriendStatModel> fetchTopFive() {
    var interactionsSentLastMonth = allSentInteractions.value.where((t) =>
        t.createdDate.add(new Duration(days: 30)).compareTo(DateTime.now()) >=
        0);
    // var thoughtsSentLastMonth = allSentThoughts.value.where((t) =>
    //     t.createdDate.add(new Duration(days: 30)).compareTo(DateTime.now()) >=
    //     0);
    var interactionsSentByFriend =
        groupBy(interactionsSentLastMonth, (t) => t.toUserId);

    // var thoughtsSentByFriend =
    // groupBy(thoughtsSentLastMonth, (t) => t.toUserId);

    var currentFriends = allFriends.value;
    List<FriendStatModel> newStat = List<FriendStatModel>();
    interactionsSentByFriend.forEach((index, value) {
      // only care about my currentFriends
      if (currentFriends.any((f) => f.friendUserId == index)) {
        FriendModel myFriend =
            allFriends.value.where((f) => f.friendUserId == index).first;
        newStat.add(new FriendStatModel(myFriend, value.length));
      }
    });
    // thoughtsSentByFriend.forEach((index, value) {
    //   // only care about my currentFriends
    //   if (currentFriends.any((f) => f.friendUserId == index)) {
    //     FriendModel myFriend =
    //         allFriends.value.where((f) => f.friendUserId == index).first;
    //     newStat.add(new FriendStatModel(myFriend, value.length));
    //   }
    // });
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
