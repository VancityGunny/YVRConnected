import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yvrconnected/blocs/friend/index.dart';
import 'package:yvrconnected/blocs/thought/thought_model.dart';

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
        .where('toUserId', isEqualTo: globals.currentUserId)
        .getDocuments();

    List<ThoughtModel> foundThoughtsReceived = [];
    for (var thought in thoughtsRef.documents) {
      foundThoughtsReceived.add(ThoughtModel.fromJson(thought.data));
    }
    return foundThoughtsReceived;
  }

  Future<List<FriendStatModel>> fetchTopFive() async {
    var thoughtSent = await fetchThoughtsSent();
    var thoughtsSentLastMonth = await thoughtSent.where((t) =>
        t.createdDate.add(new Duration(days: 30)).compareTo(DateTime.now()) >=
        0);
    var thoughtsSentByFriend =
        groupBy(thoughtsSentLastMonth, (t) => t.toUserId);
    if (globals.allFriends == null) {
      FriendProvider friendProvider = FriendProvider();
      await friendProvider.fetchFriends();
    }
    List<FriendStatModel> newStat = List<FriendStatModel>();
    thoughtsSentByFriend.forEach((index, value) {
      FriendModel myFriend =
          globals.allFriends.where((f) => f.friendUserId == index).first;
      newStat.add(new FriendStatModel(myFriend, value.length));
    });
    return newStat;
    //thoughtsSentByFriend.map((f)=>{friend = f.key, sent = f.})
  }

  Future<List<ThoughtModel>> fetchThoughtsSent() async {
    var user = await _firebaseAuth.currentUser();

    var thoughtsRef = await _firestore
        .collection('/users')
        .document(globals.currentUserId)
        .get(source: Source.cache);

    var foundThoughtsSent = thoughtsRef.data['thoughts']
        .map((t) => ThoughtModel(null, t['toUserId'], t['thoughtOptionCode'],
            t['createdDate'].toDate()))
        .cast<ThoughtModel>()
        .toList();

    return foundThoughtsSent;
  }

  Future<bool> addThought(ThoughtModel newThought) async {
    //TODO: add checking so you can't send thought to the same person within 24 hours of each thoughs
    var user = await _firebaseAuth.currentUser();
    var newDoc = await _firestore.collection('/thoughts').document();
    newDoc.setData({
      'fromUserId': globals.currentUserId,
      'toUserId': newThought.toUserId,
      'thoughtOptionCode': newThought.thoughtOptionCode,
      'createdDate': DateTime.now()
    });
    // update thoughts collection in sender obj too
    _firestore.collection('/users').document(globals.currentUserId).updateData({
      'thoughts': FieldValue.arrayUnion([
        {
          'toUserId': newThought.toUserId,
          'thoughtOptionCode': newThought.thoughtOptionCode,
          'createdDate': DateTime.now()
        }
      ])
    });

    return true;
  }
}
