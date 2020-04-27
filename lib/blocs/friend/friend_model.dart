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

  FriendModel(this.email, this.displayName);

  @override
  List<Object> get props => [email, displayName];

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(json['email'] as String, json['displayName'] as String);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['email'] = this.email;
    data['displayName'] = this.displayName;
    return data;
  }
  
}