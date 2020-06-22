import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yvrfriends/blocs/friend/friend_model.dart';
import 'package:yvrfriends/blocs/thought/thought_model.dart';
import 'package:yvrfriends/common/common_bloc.dart';

import 'package:yvrfriends/common/global_object.dart' as globals;
import 'package:yvrfriends/generated/l10n.dart';

class FriendOptionsDialog extends StatefulWidget {
  final FriendModel friend;
  @override
  FriendOptionsDialogState createState() {
    // TODO: implement createState
    return FriendOptionsDialogState();
  }

  FriendOptionsDialog(this.friend);
}

class FriendOptionsDialogState extends State<FriendOptionsDialog> {
  bool includeImageFlag;
  bool isProcessing = false;
  CommonBloc pageCommonBloc;
  @override
  void initState() {
    super.initState();
    includeImageFlag = globals.includeImageFlag ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final delegate = S.of(context);
    pageCommonBloc = CommonBloc.of(context);
    var thoughtOptions = CommonBloc.thoughtOptions;
    // TODO: implement build
    if (isProcessing) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(delegate.includeImageLable + '? '),
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
      var picker = ImagePicker();
      var pickedFile = await picker.getImage(
          source: ImageSource.camera, maxWidth: 200.0, maxHeight: 300.0);
      imageFile = File(pickedFile.path);
      //imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    }
    if (includeImageFlag == false || imageFile != null) {
      await pageCommonBloc.thoughtRepository
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
