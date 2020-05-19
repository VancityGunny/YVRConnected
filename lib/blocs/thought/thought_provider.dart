import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:yvrconnected/blocs/friend/index.dart';
import 'package:yvrconnected/blocs/thought/thought_model.dart';
import 'package:yvrconnected/common/common_bloc.dart';

import 'package:yvrconnected/common/global_object.dart' as globals;

class ThoughtProvider {
  static final _firestore = Firestore.instance;
  static final _firebaseAuth = FirebaseAuth.instance;

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

  Future<List<String>> getThoughtOptions() async {}

  Future<List<ThoughtModel>> fetchThoughtsReceived() async {
    var user = await _firebaseAuth.currentUser();

    var thoughtsRef = await _firestore
        .collection('/thoughts')
        .document(globals.currentUserId)
        .get();
    List<ThoughtModel> foundThoughtsReceived = [];
    if (thoughtsRef.data != null) {
      for (var thought in thoughtsRef.data['receivedThoughts']) {
        // only return unread
        foundThoughtsReceived.add(ThoughtModel.fromJson(thought));
      }
    }

    return foundThoughtsReceived;
  }

  Future<List<FriendStatModel>> fetchTopFive(BuildContext context) async {
    var thoughtSent = await fetchThoughtsSent();
    var thoughtsSentLastMonth = await thoughtSent.where((t) =>
        t.createdDate.add(new Duration(days: 30)).compareTo(DateTime.now()) >=
        0);
    var thoughtsSentByFriend =
        groupBy(thoughtsSentLastMonth, (t) => t.toUserId);
    
    List<FriendStatModel> newStat = List<FriendStatModel>();
    thoughtsSentByFriend.forEach((index, value) {
      FriendModel myFriend =
          CommonBloc.of(context).allFriends.value.where((f) => f.friendUserId == index).first;
      newStat.add(new FriendStatModel(myFriend, value.length));
    });
    return newStat;
    //thoughtsSentByFriend.map((f)=>{friend = f.key, sent = f.})
  }

  Future<List<ThoughtModel>> fetchThoughtsSent() async {
    var user = await _firebaseAuth.currentUser();

    var thoughtsRef = await _firestore
        .collection('/thoughts')
        .document(globals.currentUserId)
        .get();

    List<ThoughtModel> foundThoughtsSent = [];
    if (thoughtsRef.data != null) {
      for (var thought in thoughtsRef.data['sentThoughts']) {
        foundThoughtsSent.add(ThoughtModel.fromJson(thought));
      }
    }

    return foundThoughtsSent;
  }

  Future<bool> addThought(ThoughtModel newThought) async {
    //TODO: add checking so you can't send thought to the same person within 24 hours of each thoughs
    var user = await _firebaseAuth.currentUser();

    // add thought to sentThought collection
    var newSentThoughtDoc = await _firestore
        .collection('/thoughts')
        .document(globals.currentUserId);
    newSentThoughtDoc.updateData({
      'sentThoughts': FieldValue.arrayUnion([
        {
          'toUserId': newThought.toUserId,
          'thoughtOptionCode': newThought.thoughtOptionCode,
          'createdDate': newThought.createdDate
        }
      ])
    });

    // add thought to receivedThought collection
    var newReceivedThoughtDoc =
        await _firestore.collection('/thoughts').document(newThought.toUserId);
    newReceivedThoughtDoc.updateData({
      'receivedThoughts': FieldValue.arrayUnion([
        {
          'fromUserId': globals.currentUserId,
          'thoughtOptionCode': newThought.thoughtOptionCode,
          'createdDate': newThought.createdDate,
          'readFlag': false // new message always unread
        }
      ])
    });

    return true;
  }
}
