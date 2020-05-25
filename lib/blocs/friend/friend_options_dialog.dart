import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yvrconnected/blocs/friend/friend_model.dart';
import 'package:yvrconnected/blocs/thought/thought_model.dart';
import 'package:yvrconnected/common/common_bloc.dart';
import 'package:image/image.dart' as IM;
import 'package:yvrconnected/common/global_object.dart' as globals;

class FriendOptionsDialog extends StatefulWidget {
  final FriendModel friend;
  @override
  FriendOptionsDialogState createState() {
    // TODO: implement createState
    return FriendOptionsDialogState();
  }

  FriendOptionsDialog(FriendModel this.friend);
}

class FriendOptionsDialogState extends State<FriendOptionsDialog> {
  bool includeImageFlag = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var thoughtOptions = CommonBloc.of(context).thoughtOptions;
    // TODO: implement build
    return Column(children: <Widget>[
      Row(
        children: <Widget>[
          Text('Include Image? '),
          Switch(
              value: includeImageFlag,
              onChanged: (newValue) {
                setState(() {
                  includeImageFlag = newValue;
                });
              }),
        ],
      ),
      Column(
          children: thoughtOptions.map((opt) {
        return SimpleDialogOption(
            onPressed: () {
              sendThought(widget.friend, opt.code);
            },
            child: ListTile(
              leading: opt.icon,
              title: Text(opt.caption),
            ));
      }).toList())
    ]);
  }

  sendThought(FriendModel friend, String thoughtOptionCode) async {
    var newThoughtId = await CommonBloc.of(context)
        .thoughtRepository
        .addThought(
            new ThoughtModel(
                null, friend.friendUserId, thoughtOptionCode, DateTime.now()),
            context);

    if (includeImageFlag) {
      // upload and resize image first
      var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

      IM.Image originalImage = IM.decodeImage(imageFile.readAsBytesSync());
      IM.Image thumbnail = IM.copyResize(originalImage, width: 200);      
      var localPath = await CommonBloc.of(context).localPath;
      var thumbImageFile = new File('$localPath/temp.png')
        ..writeAsBytesSync(IM.encodePng(thumbnail));

      String thumbPath = 'images/thoughts/' + newThoughtId + '.png';
      var uploadTask =
          globals.storage.ref().child(thumbPath).putFile(thumbImageFile);
    }

    Navigator.of(context).pop();
  }
}
