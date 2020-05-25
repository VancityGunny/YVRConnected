import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yvrconnected/blocs/friend/index.dart';
import 'package:yvrconnected/blocs/thought/index.dart';

import 'package:image/image.dart' as IM;
import 'package:yvrconnected/common/common_bloc.dart';
import 'package:yvrconnected/common/global_object.dart' as globals;

class ThoughtRepository {
  final ThoughtProvider _thoughtProvider = ThoughtProvider();

  ThoughtRepository();

  void test(bool isError) {
    this._thoughtProvider.test(isError);
  }

  Future<String> addThought(
      ThoughtModel newThought, File newImage, BuildContext context) async {
    var newThoughtId = await this._thoughtProvider.addThought(newThought);
    var localPath = await CommonBloc.of(context).localPath;
    if (newImage != null) {
      IM.Image originalImage = IM.decodeImage(newImage.readAsBytesSync());
      IM.Image thumbnail = IM.copyResize(originalImage, width: 200);

      var thumbImageFile = new File('$localPath/temp.png')
        ..writeAsBytesSync(IM.encodePng(thumbnail));

      String thumbPath = 'images/thoughts/' + newThoughtId + '.png';
      var uploadTask =
          globals.storage.ref().child(thumbPath).putFile(thumbImageFile);
      var thumbUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      newThought.imageUrl = thumbUrl;
    }

    if (newThoughtId != null) {
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
