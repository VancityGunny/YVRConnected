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
    List<FriendModel> result = new List<FriendModel>();
    result.add(FriendModel('Kobe@gmail.com','Kobe'));
      result.add(FriendModel('Ooh@gmail.com','Ooh'));
        result.add(FriendModel('Ab@gmail.com','Ab'));
    return result;
  }

  void test(bool isError) {
    if (isError == true) {
      throw Exception('manual error');
    }
  }
}
