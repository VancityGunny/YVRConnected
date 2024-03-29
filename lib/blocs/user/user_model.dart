import 'package:equatable/equatable.dart';
import 'package:yvrfriends/blocs/friend/friend_model.dart';

class UserModel extends Equatable {
  final String uid;
  final String email;
  final String displayName;
  final String phone;
  final String photoUrl;
  final List<FriendModel> friends;
  final List<FriendModel> senders;

  UserModel(this.uid, this.email, this.displayName, this.phone, this.friends, this.senders, this.photoUrl);

  @override
  List<Object> get props => [uid, email, displayName, phone, friends,senders, photoUrl];

  factory UserModel.fromJson(Map<dynamic, dynamic> json) {
    return UserModel(
        json['uid'] as String,
        json['email'] as String,
        json['displayName'] as String,
        json['phone'] as String,
        json['friends'].cast<FriendModel>() as List<FriendModel>,
        json['senders'].cast<FriendModel>() as List<FriendModel>,
        json['photoUrl'] as String);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['uid'] = this.uid;
    data['email'] = this.email;
    data['displayName'] = this.displayName;
    data['phone'] = this.phone;
    data['friends'] = this.friends;
    data['senders'] = this.senders;
    data['photoUrl'] = this.photoUrl;
    return data;
  }
}
