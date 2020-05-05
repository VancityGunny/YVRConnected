import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yvrconnected/blocs/thought/thought_model.dart';

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

  Future<bool> addThought(ThoughtModel newThought) async {
    //TODO: add checking so you can't send thought to the same person within 24 hours of each thoughs
    var user = await _firebaseAuth.currentUser();
    var newDoc = await _firestore
        .collection('/thoughts')
        .document(user.uid)
        .collection('sent')
        .document();
        newDoc.setData({
      'fromUserId': user.uid,
      'toUserId': newThought.toUserId,
      'thoughtOptionCode': newThought.thoughtOptionCode,
      'createdDate': DateTime.now()
    });
    // try {
    //   await _firestore.collection('/posts').add(newPost.toMap());
    //   return true;
    // } catch (e) {
    //   return e.toString();
    // }
    //TODO: to be implement
    //return newDoc.documentID;
    return true;
  }
}
