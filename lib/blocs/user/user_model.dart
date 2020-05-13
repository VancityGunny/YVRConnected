import 'package:equatable/equatable.dart';
import 'package:yvrconnected/blocs/friend/friend_model.dart';
import 'package:yvrconnected/blocs/thought/index.dart';

class UserModel extends Equatable {
  final String uid;
  final String email;
  final String displayName;
  final String phone;
  final List<FriendModel> friends;
  final List<ThoughtModel> thoughts;

  UserModel(this.uid, this.email, this.displayName, this.phone, this.friends,
      this.thoughts);

  @override
  List<Object> get props => [uid, email, displayName, phone, friends, thoughts];

  factory UserModel.fromJson(Map<dynamic, dynamic> json) {
    return UserModel(
        json['uid'] as String,
        json['email'] as String,
        json['displayName'] as String,
        json['phone'] as String,
        json['friends'].cast<FriendModel>() as List<FriendModel>,
        json['thoughts']
            .map((entry) => ThoughtModel(null, entry['toUserId'],
                entry['thoughtOptionCode'], entry['createdDate']))
            .cast<ThoughtModel>()
            .toList() as List<ThoughtModel>);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['uid'] = this.uid;
    data['email'] = this.email;
    data['displayName'] = this.displayName;
    data['phone'] = this.phone;
    data['friends'] = this.friends;
    data['thoughts'] = this
        .thoughts
        .map((e) => {
              'toUserId': e.toUserId,
              'thoughtOptionCode': e.thoughtOptionCode,
              'createdDate': e.createdDate
            })
        .toList();
    return data;
  }
}
