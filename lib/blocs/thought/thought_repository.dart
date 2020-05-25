import 'package:flutter/material.dart';
import 'package:yvrconnected/blocs/friend/index.dart';
import 'package:yvrconnected/blocs/thought/index.dart';

class ThoughtRepository {
  final ThoughtProvider _thoughtProvider = ThoughtProvider();

  ThoughtRepository();

  void test(bool isError) {
    this._thoughtProvider.test(isError);
  }

  Future<String> addThought(ThoughtModel newThought, BuildContext context) async {
    var newThoughtId = await this._thoughtProvider.addThought(newThought);
    if (newThoughtId!=null) {
      // update lastThoughtSentDate for that friend
      var friendProvider = FriendProvider();
      friendProvider.updateFriendLastSent(
          newThought.toUserId, newThought.thoughtOptionCode, context);
    }
    return newThoughtId;
  }

  Future<List<FriendStatModel>> fetchTopFive(BuildContext context) async {
    return this._thoughtProvider.fetchTopFive(context);
  }
}
