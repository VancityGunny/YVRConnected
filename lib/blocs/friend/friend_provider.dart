import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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

    var friendsRef =
        await _firestore.collection('/users').document(user.uid).get();
    var friendsUserId = friendsRef.data['friends'];

    List<FriendModel> foundFriends = [];

    for (var friendUserId in friendsUserId) {
      var eachFriend = await _firestore.collection('/users').document(friendUserId).get();
      foundFriends.add(new FriendModel(
          eachFriend.data['email'], eachFriend.data['displayName']));
    }
    return foundFriends;
  }

  Future<bool> addFriend(FriendModel newFriend) async {
    var user = await _firebaseAuth.currentUser();
    var friendId = null;
    // check if user record does not exist then create the record
    var friendsRef = await _firestore
        .collection('/users')
        .where('email', isEqualTo: newFriend.email)
        .getDocuments();

    if (friendsRef.documents.length == 0) {
      // if it's not already exists then add new user first
      var newFriendUserObj = _firestore.collection('/users').document();
      newFriendUserObj.setData(
          {'email': newFriend.email, 'displayName': newFriend.displayName});
      friendId = newFriendUserObj.documentID;
    } else {
      friendId = friendsRef.documents[0].documentID;
    }

    if (friendId != null) {
      // now add that new user id as your friend
      _firestore.collection('/users').document(user.uid).updateData({
        'friends': FieldValue.arrayUnion([friendId])
      });
    }

    return true;
  }

  void test(bool isError) {
    if (isError == true) {
      throw Exception('manual error');
    }
  }
}
