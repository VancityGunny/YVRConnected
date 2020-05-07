import 'package:equatable/equatable.dart';

/// generate by https://javiercbk.github.io/json_to_dart/
class AutogeneratedFriend {
  final List<FriendModel> results;

  AutogeneratedFriend({this.results});

  factory AutogeneratedFriend.fromJson(Map<String, dynamic> json) {
    List<FriendModel> temp;
    if (json['results'] != null) {
      temp = <FriendModel>[];
      json['results'].forEach((v) {
        temp.add(FriendModel.fromJson(v as Map<String, dynamic>));
      });
    }
    return AutogeneratedFriend(results: temp);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FriendModel extends Equatable {
  final String email;
  final String displayName;
  final String friendUserId;

  FriendModel(this.friendUserId, this.email, this.displayName);

  @override
  List<Object> get props => [friendUserId, email, displayName];

  factory FriendModel.fromJson(Map<dynamic, dynamic> json) {
    return FriendModel(json['friendUserId'] as String, json['friendEmail'] as String, json['friendName'] as String);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
data['friendUserId'] = this.friendUserId;
    data['friendEmail'] = this.email;
    data['friendName'] = this.displayName;
    return data;
  }
  
}
