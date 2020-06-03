import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:yvrconnected/blocs/user/user_model.dart';
import 'package:yvrconnected/blocs/user/user_provider.dart';
import 'package:yvrconnected/common/common_bloc.dart';
import 'package:yvrconnected/common/global_object.dart' as globals;
import 'friend_model.dart';

Firestore _firestore = Firestore.instance;

class FriendProvider {
  Future<void> loadAsync(String token) async {
    /// write from keystore/keychain
    await Future.delayed(Duration(seconds: 2));
  }

  Future<void> saveAsync(String token) async {
    /// write from keystore/keychain
    await Future.delayed(Duration(seconds: 2));
  }

  Future<bool> addFriend(FriendModel newFriend, Uint8List thumbnail) async {
    var friendId;
    String thumbUrl;

    // check if user record does not exist then create the record
    var friendsRef = await _firestore
        .collection('/users')
        .where('email', isEqualTo: newFriend.email)
        .limit(1)
        .getDocuments();
    var newFriendFlag = (friendsRef.documents.length == 0);
    if (newFriendFlag) {
      var uuid = new Uuid();
      friendId = uuid.v1();
    } else {
      friendId = friendsRef.documents[0].documentID;
    }

    String thumbPath = (thumbnail.isEmpty == true)
        ? null
        : 'images/users/' + friendId.toString() + '/thumbnail.png';
    //File newThumbnail = File.fromRawPath(thumbnail);
    if (thumbnail.isEmpty != true) {
      var uploadTask =
          globals.storage.ref().child(thumbPath).putData(thumbnail);
      //.putFile(newThumbnail);
      thumbUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    }

    if (newFriendFlag) {
      // if it's not already exists then add new user first
      UserProvider userProvider = UserProvider();
      await userProvider.addUser(
          friendId,
          UserModel(null, newFriend.email, newFriend.displayName, null, [], [],
              thumbPath));
    }

    if (friendId != null) {
      // now add that new user id as your friend
      _firestore
          .collection('/users')
          .document(globals.currentUserId)
          .updateData({
        'friends': FieldValue.arrayUnion([
          {
            'friendId': friendId,
            'friendName': newFriend.displayName,
            'friendEmail': newFriend.email,
            'thumbnail': thumbUrl
          }
        ])
      });
    }

    return true;
  }

  void test(bool isError) {
    if (isError == true) {
      throw Exception('manual error');
    }
  }

  // update friendLast sent and the thoughts stat
  void updateFriendLastSent(
      String toUserId, String thoughtOptionCode, BuildContext context) async {
   
    var userRef =
        _firestore.collection('/users').document(globals.currentUserId);
    var currentFriends = CommonBloc.of(context).allFriends.value;
    List<Map<String, dynamic>> newFriends = new List<Map<String, dynamic>>();
    currentFriends.forEach((f) {
      if (f.friendUserId == toUserId) {
        f.lastThoughtSentDate = DateTime.now();
        f.lastThoughtSentOption = thoughtOptionCode;
      }
      newFriends.add(f.toJson());
    });
    userRef.updateData({'friends': newFriends});
    // _firestore.runTransaction((transaction) async {
    //   await transaction.update(userRef, {'friends': newFriends});
    // });
    // var transaction = _firestore.runTransaction((t) {
    //   return t.get(userRef).then((doc) {
    //     List<FriendModel> newFriends = doc.data['friends'].cast<FriendModel>();
    //     newFriends.forEach((FriendModel f){
    //         if(f.friendUserId==toUserId){
    //           f.lastThoughtSentDate = DateTime.now();
    //         }
    //     });
    //     // List<FriendModel> newFriends = doc.data['friends'].cast<FriendModel>();
    //     // newFriends
    //     //     .where((element) => element.friendUserId == toUserId)
    //     //     .first
    //     //     .lastThoughtSentDate = DateTime.now();
    //     t.update(userRef, {'friends': newFriends});
    //   });
    // }).then((result) {
    //   developer.log('Transaction success!');
    // }).catchError((err) {
    //   developer.log('Transaction failure:' + err);
    // });
  }

  void removeFriend(String friendUserId, BuildContext context) {
    var currentFriends = CommonBloc.of(context).allFriends.value;
    var newFriends = currentFriends
        .where((element) => element.friendUserId != friendUserId)
        .map((e) => e.toJson())
        .toList();
    _firestore
        .collection('/users')
        .document(globals.currentUserId)
        .updateData({'friends': newFriends});
  }

  void addSender(String senderId, FriendModel sender, BuildContext context) {
    if (senderId != null) {
      // now add that new user id as your friend
      _firestore
          .collection('/users')
          .document(globals.currentUserId)
          .updateData({
        'senders': FieldValue.arrayUnion([
          {
            'friendId': senderId,
            'friendName': sender.displayName,
            'friendEmail': sender.email,
            'thumbnail': sender.thumbnail
          }
        ])
      });
    }
  }

  Future<FriendModel> lookupFriendById(String fromUserId) async {
    var foundFriend =
        await _firestore.collection('/users').document(fromUserId).get();
    var foundUser = UserModel.fromJson(foundFriend.data);

    return FriendModel(fromUserId, foundUser.email, foundUser.displayName,
        foundUser.photoUrl, null, null, null, null);
  }

  void updateFriendLastInteracted(String toUserId, String interactionOptionCode,
      BuildContext context) async {
    
    var userRef =
        _firestore.collection('/users').document(globals.currentUserId);
    var currentFriends = CommonBloc.of(context).allFriends.value;
    List<Map<String, dynamic>> newFriends = new List<Map<String, dynamic>>();
    currentFriends.forEach((f) {
      if (f.friendUserId == toUserId) {
        f.lastInteractionSentDate = DateTime.now();
        f.lastInteractionSentOption = interactionOptionCode;
      }
      newFriends.add(f.toJson());
    });
    userRef.updateData({'friends': newFriends});
  }
}
