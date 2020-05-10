import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yvrconnected/blocs/user/user_model.dart';
import 'package:yvrconnected/blocs/user/user_provider.dart';
import 'package:yvrconnected/common/global_object.dart' as globals;
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

    var friendsRef = await _firestore
        .collection('/users')
        .document(globals.currentUserId)
        .get();
    var friends = friendsRef.data['friends'];

    List<FriendModel> foundFriends = [];

    for (var friend in friends) {
      foundFriends.add(new FriendModel(
          friend["friendId"],
          friend["friendEmail"],
          friend["friendName"],
          Uint8List.fromList(friend["thumbnail"].cast<int>())));
    }
    // save friends to global
    globals.allFriends = foundFriends;
    return foundFriends;
  }

  Future<bool> addFriend(FriendModel newFriend) async {
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
      friendId = await userProvider.addUser(
          UserModel(null, newFriend.email, newFriend.displayName, null, []));
    } else {
      friendId = friendsRef.documents[0].documentID;
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
            'thumbnail': newFriend.thumbnail
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
}
