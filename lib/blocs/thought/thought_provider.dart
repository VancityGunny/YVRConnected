import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:yvrconnected/blocs/friend/index.dart';
import 'package:yvrconnected/blocs/interaction/interaction_model.dart';
import 'package:yvrconnected/blocs/thought/thought_model.dart';
import 'package:yvrconnected/common/common_bloc.dart';
import 'package:yvrconnected/common/global_object.dart' as globals;

class ThoughtProvider {
  static final _firestore = Firestore.instance;

  Future<void> loadAsync(String token) async {
    /// write from keystore/keychain
    await Future.delayed(Duration(seconds: 2));
  }

  Future<void> saveAsync(String token) async {
    /// write from keystore/keychain
    await Future.delayed(Duration(seconds: 2));
  }

  void test(bool isError) {
    if (isError == true) {
      throw Exception('manual error');
    }
  }

  Future<List<FriendStatModel>> fetchTopFive(BuildContext context) async {
    var thoughtSent = CommonBloc.of(context).allSentThoughts.value;
    var thoughtsSentLastMonth = thoughtSent.where((t) =>
        t.createdDate.add(new Duration(days: 30)).compareTo(DateTime.now()) >=
        0);
    var thoughtsSentByFriend =
        groupBy(thoughtsSentLastMonth, (t) => t.toUserId);

    List<FriendStatModel> newStat = List<FriendStatModel>();
    thoughtsSentByFriend.forEach((index, value) {
      FriendModel myFriend = CommonBloc.of(context)
          .allFriends
          .value
          .where((f) => f.friendUserId == index)
          .first;
      newStat.add(new FriendStatModel(myFriend, value.length));
    });
    return newStat;
    //thoughtsSentByFriend.map((f)=>{friend = f.key, sent = f.})
  }

  Future<String> addThought(
      String newThoughtId, ThoughtModel newThought) async {
    //TODO: add checking so you can't send thought to the same person within 24 hours of each thoughs
    // add thought to sentThought collection
    var newSentThoughtDoc =
        _firestore.collection('/thoughts').document(globals.currentUserId);
    newSentThoughtDoc.updateData({
      'sentThoughts': FieldValue.arrayUnion([
        {
          'thoughtId': newThoughtId,
          'toUserId': newThought.toUserId,
          'thoughtOptionCode': newThought.thoughtOptionCode,
          'createdDate': newThought.createdDate
        }
      ])
    });

    // add thought to receivedThought collection
    var newReceivedThoughtDoc =
        _firestore.collection('/thoughts').document(newThought.toUserId);
    newReceivedThoughtDoc.updateData({
      'receivedThoughts': FieldValue.arrayUnion([
        {
          'thoughtId': newThoughtId,
          'fromUserId': globals.currentUserId,
          'thoughtOptionCode': newThought.thoughtOptionCode,
          'createdDate': newThought.createdDate,
          'imageUrl': newThought.imageUrl,
          'readFlag': false // new message always unread
        }
      ])
    });

    return newThoughtId;
  }

  Future<String> addInteraction(
      String newInteractionId, InteractionModel newInteraction) async {
    //TODO: add checking so you can't send thought to the same person within 24 hours of each thoughs
    // add thought to sentThought collection
    var newSentThoughtDoc =
        _firestore.collection('/thoughts').document(globals.currentUserId);
    newSentThoughtDoc.updateData({
      'sentInteractions': FieldValue.arrayUnion([
        {
          'interactionId': newInteractionId,
          'toUserId': newInteraction.toUserId,
          'interactionOptionCode': newInteraction.interactionOptionCode,
          'createdDate': newInteraction.createdDate
        }
      ])
    });

    return newInteractionId;
  }

  void updateReceivedThoughts(List<ThoughtModel> updatedThoughts) {
    // add thought to receivedThought collection
    var newReceivedThoughtDoc =
        _firestore.collection('/thoughts').document(globals.currentUserId);
    var newThoughtsCollection = updatedThoughts.map((e) => e.toJson()).toList();
    newReceivedThoughtDoc.updateData({
      'receivedThoughts': newThoughtsCollection
    });
  }

  void updateSentInteractions(List<InteractionModel> updatedInteractions) {
     var newSentInteractionDocs =
        _firestore.collection('/thoughts').document(globals.currentUserId);
    var newInteractionsCollection = updatedInteractions.map((e) => e.toJson()).toList();
    newSentInteractionDocs.updateData({
      'sentInteractions': newInteractionsCollection
    });
  }
}
