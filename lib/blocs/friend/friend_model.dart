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
   String phone;
   String displayName;
   String friendUserId;
   String thumbnail;
  DateTime lastThoughtSentDate;
  String lastThoughtSentOption;
  DateTime lastInteractionSentDate;
  String lastInteractionSentOption;

  FriendModel(
      this.friendUserId,
      this.phone,
      this.displayName,
      this.thumbnail,
      this.lastThoughtSentDate,
      this.lastThoughtSentOption,
      this.lastInteractionSentDate,
      this.lastInteractionSentOption);

  @override
  List<Object> get props => [
        friendUserId,
        phone,
        displayName,
        thumbnail,
        lastThoughtSentDate,
        lastThoughtSentOption,
        lastInteractionSentDate,
        lastInteractionSentOption
      ];

  factory FriendModel.fromJson(Map<dynamic, dynamic> json) {
    var tmpLastInteractionSentDate;
    try {
      tmpLastInteractionSentDate = json['lastInteractionSentDate'].toDate();
    } catch (e) {
      // just set to null
      tmpLastInteractionSentDate = null;
    }
    var tmpLastInteractionOption;
    try {
      tmpLastInteractionOption = json['lastInteractionSentOption'];
    } catch (e) {
      // just set to null
      tmpLastInteractionOption = null;
    }
    return FriendModel(
        json['friendId'] as String,
        json['friendPhone'] as String,
        json['friendName'] as String,
        json['thumbnail'] as String,
        (json['lastThoughtSentDate'] == null)
            ? null
            : json['lastThoughtSentDate'].toDate(),
        json['lastThoughtSentOption'] as String,
        tmpLastInteractionSentDate,
        tmpLastInteractionOption);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['friendId'] = this.friendUserId;
    data['friendPhone'] = this.phone;
    data['friendName'] = this.displayName;
    data['thumbnail'] = this.thumbnail;
    data['lastThoughtSentDate'] = this.lastThoughtSentDate;
    data['lastThoughtSentOption'] = this.lastThoughtSentOption;
    data['lastInteractionSentDate'] = this.lastThoughtSentDate;
    data['lastInteractionSentOption'] = this.lastThoughtSentOption;
    return data;
  }
}
