import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yvrconnected/blocs/friend/friend_model.dart';
import 'package:yvrconnected/blocs/thought/thought_model.dart';
import 'package:yvrconnected/common/common_bloc.dart';

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
  bool includeImageFlag;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    includeImageFlag = globals.includeImageFlag??false;
  }

  @override
  Widget build(BuildContext context) {
    var thoughtOptions = CommonBloc.of(context).thoughtOptions;
    // TODO: implement build
    if (isProcessing) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Column(children: <Widget>[
        Row(
          children: <Widget>[
            Text('Include Image? '),
            Switch(
                value: includeImageFlag,
                onChanged: (newValue) {
                  setState(() {
                    globals.includeImageFlag = newValue;
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
  }

  sendThought(FriendModel friend, String thoughtOptionCode) async {
    setState(() {
      isProcessing = true;
    });
    File imageFile;
    if (includeImageFlag) {
      // upload and resize image first
      imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    }
    if (includeImageFlag == false || imageFile != null) {
      await CommonBloc.of(context)
          .thoughtRepository
          .addThought(
              new ThoughtModel(null, friend.friendUserId, thoughtOptionCode,
                  DateTime.now(), null),
              imageFile,
              context)
          .then((value) => isProcessing = false);
    }

    Navigator.of(context).pop(thoughtOptionCode);
  }
}
