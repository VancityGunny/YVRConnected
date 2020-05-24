import 'package:flutter/material.dart';
import 'package:yvrconnected/blocs/friend/friend_model.dart';
import 'package:yvrconnected/blocs/thought/thought_model.dart';
import 'package:yvrconnected/common/common_bloc.dart';

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

  sendThought(FriendModel friend, String thoughtOptionCode) {
    if(includeImageFlag)
    {
        // upload and resize image first

    }
    CommonBloc.of(context).thoughtRepository.addThought(
        new ThoughtModel(
            null, friend.friendUserId, thoughtOptionCode, DateTime.now()),
        context);

    Navigator.of(context).pop();
  }
}
