import 'dart:typed_data';

import 'package:yvrconnected/blocs/friend/index.dart';

class FriendRepository {
  final FriendProvider _friendProvider = FriendProvider();

  FriendRepository();


  Future<List<FriendModel>> fetchFriends() => _friendProvider.fetchFriends();

  void test(bool isError) {
    this._friendProvider.test(isError);
  }

  Future<bool> AddFriend(FriendModel newFriend, Uint8List thumbnail){
    return this._friendProvider.addFriend(newFriend, thumbnail);
  }
}