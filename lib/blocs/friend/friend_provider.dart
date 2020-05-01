import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';

import 'friend_model.dart';

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
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'getFriends',
    );
    dynamic resp = await callable.call();
    List<FriendModel> foundFriends = [];
    resp.data.forEach((f)=> foundFriends.add(FriendModel.fromJson(f)));
    return foundFriends;
  }

  Future<bool> addFriend(FriendModel newFriend) async {
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
