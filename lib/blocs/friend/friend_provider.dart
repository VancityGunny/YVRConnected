import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:ui';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:yvrconnected/blocs/thought/index.dart';
import 'package:yvrconnected/blocs/user/user_model.dart';
import 'package:yvrconnected/blocs/user/user_provider.dart';
import 'package:yvrconnected/common/global_object.dart' as globals;
import 'friend_model.dart';

import 'dart:developer' as developer;

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

    var friendsRef = await _firestore
        .collection('/users')
        .document(globals.currentUserId)
        .get(source: Source.cache);
    var friends = friendsRef.data['friends'];

    List<FriendModel> foundFriends = [];

    for (var friend in friends) {
      foundFriends.add(new FriendModel(
        friend["friendId"],
        friend["friendEmail"],
        friend["friendName"],
        friend["thumbnail"],
        (friend["lastSent"] == null) ? null : friend["lastSent"].toDate(),
      ));
    }
    // save friends to global
    globals.allFriends = foundFriends;
    return foundFriends;
  }

  Future<bool> addFriend(FriendModel newFriend, Uint8List thumbnail) async {
    var user = await _firebaseAuth.currentUser();
    var friendId = null;
    // check if user record does not exist then create the record
    var friendsRef = await _firestore
        .collection('/users')
        .where('email', isEqualTo: newFriend.email)
        .limit(1)
        .getDocuments();

    if (friendsRef.documents.length == 0) {
      // if it's not already exists then add new user first
      UserProvider userProvider = UserProvider();
      friendId = await userProvider.addUser(UserModel(
          null, newFriend.email, newFriend.displayName, null, [], []));
    } else {
      friendId = friendsRef.documents[0].documentID;
    }

    FirebaseStorage _storage =
        FirebaseStorage(storageBucket: 'gs://yvrconnected.appspot.com');
    //File newThumbnail = File.fromRawPath(thumbnail);
    String thumbPath = (thumbnail == null)
        ? null
        : 'images/users/' + friendId.toString() + '/thumbnail.png';
    var uploadTask = _storage.ref().child(thumbPath).putData(thumbnail);
    //.putFile(newThumbnail);
    var thumbUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

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
            'thumbnail': thumbUrl.toString()
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
  void updateFriendLastSent(String toUserId) async {
    var user = await _firebaseAuth.currentUser();
    var userRef =
        _firestore.collection('/users').document(globals.currentUserId);
    var userDoc = await userRef.get();
    var currentFriends = userDoc.data['friends'];
    List<Map<String, dynamic>> newFriends = new List<Map<String, dynamic>>();
    currentFriends.forEach((f) {
      var friendObj = FriendModel.fromJson(f);
      if (friendObj.friendUserId == toUserId) {
        friendObj.lastSent = DateTime.now();
      }
      newFriends.add(friendObj.toJson());
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
    //           f.lastSent = DateTime.now();
    //         }
    //     });
    //     // List<FriendModel> newFriends = doc.data['friends'].cast<FriendModel>();
    //     // newFriends
    //     //     .where((element) => element.friendUserId == toUserId)
    //     //     .first
    //     //     .lastSent = DateTime.now();
    //     t.update(userRef, {'friends': newFriends});
    //   });
    // }).then((result) {
    //   developer.log('Transaction success!');
    // }).catchError((err) {
    //   developer.log('Transaction failure:' + err);
    // });
  }
}
