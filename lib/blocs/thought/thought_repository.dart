import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:yvrfriends/blocs/friend/index.dart';
import 'package:yvrfriends/blocs/interaction/interaction_model.dart';
import 'package:yvrfriends/blocs/thought/index.dart';

import 'package:image/image.dart' as IM;
import 'package:yvrfriends/common/common_bloc.dart';
import 'package:yvrfriends/common/global_object.dart' as globals;

class ThoughtRepository {
  final ThoughtProvider _thoughtProvider = ThoughtProvider();

  ThoughtRepository();

  void test(bool isError) {
    this._thoughtProvider.test(isError);
  }

  Future<String> addThought(
      ThoughtModel newThought, File newImage, BuildContext context) async {
    var uuid = new Uuid();
    var newThoughtId = uuid.v1();

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
    await this._thoughtProvider.addThought(newThoughtId, newThought);

    if (newThoughtId != null) {
      // update lastThoughtSentDate for that friend
      var friendProvider = FriendProvider();
      friendProvider.updateFriendLastSent(
          newThought.toUserId, newThought.thoughtOptionCode, context);
    }
    return newThoughtId;
  }

  Future<String> addInteraction(
      InteractionModel newInteraction, BuildContext context) async {
    var uuid = new Uuid();
    var newInteractionId = uuid.v1();

    await this
        ._thoughtProvider
        .addInteraction(newInteractionId, newInteraction);

    if (newInteractionId != null) {
      // update latestInteractionSent for that friend
      var friendProvider = FriendProvider();
      friendProvider.updateFriendLastInteracted(newInteraction.toUserId,
          newInteraction.interactionOptionCode, context);
    }
    return newInteractionId;
  }

  Future<List<FriendStatModel>> fetchTopFive(BuildContext context) async {
    return this._thoughtProvider.fetchTopFive(context);
  }

  void updateReceivedThoughts(List<ThoughtModel> updatedThoughts) {
    this._thoughtProvider.updateReceivedThoughts(updatedThoughts);
  }

  void updateSentInteractions(List<InteractionModel> updatedInteractions) {
    this._thoughtProvider.updateSentInteractions(updatedInteractions);
  }
}
