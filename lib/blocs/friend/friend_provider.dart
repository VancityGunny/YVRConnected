import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yvrconnected/blocs/friend/friend_repository.dart';

import 'friend_model.dart';

Firestore _firestore = Firestore.instance;
FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class FriendProvider {
  Future<void> loadAsync(String token) async {
    /// write from keystore/keychain
    await Future.delayed(Duration(seconds: 2));
  }

  Future<void> saveAsync(String token) async {
    /// write from keystore/keychain
    await Future.delayed(Duration(seconds: 2));
  }

  Future<List<FriendModel>> fetchFriends() async {
    var user = await _firebaseAuth.currentUser();
    // check if user record does not exist then create the record
    var friendsRef = await _firestore
        .collection('/users')
        .document(user.uid)
        .collection('friends')
        .getDocuments();

    List<FriendModel> foundFriends = [];

    var allFriends = friendsRef.documents;
    allFriends.forEach((f)=> foundFriends.add(FriendModel.fromJson(f.data)));
    // final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
    //   functionName: 'getFriends',
    // );
    // dynamic resp = await callable.call();

    // resp.data.forEach((f) => foundFriends.add(FriendModel.fromJson(f)));
    return foundFriends;
  }

  Future<bool> addFriend(FriendModel newFriend) async {
    var user = await _firebaseAuth.currentUser();
    // check if user record does not exist then create the record
    var friendsRef = await _firestore
        .collection('/users')
        .document(user.uid)
        .collection('friends')
        .where('friendEmail', isEqualTo: newFriend.email)
        .getDocuments();
    if (friendsRef.documents.length == 0) {
      // if it's not already exists then add it
      _firestore
          .collection('/users')
          .document(user.uid)
          .collection('friends')
          .document()
          .setData({
        'friendEmail': newFriend.email,
        'friendName': newFriend.displayName
      });
    }

    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'addFriend',
    );
    dynamic success = await callable.call(<String, dynamic>{
      'friendName': newFriend.displayName,
      'friendEmail': newFriend.email,
    });
    return success.data;
  }

  void test(bool isError) {
    if (isError == true) {
      throw Exception('manual error');
    }
  }
}
