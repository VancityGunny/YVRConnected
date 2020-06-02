import 'package:equatable/equatable.dart';

/// generate by https://javiercbk.github.io/json_to_dart/
class AutogeneratedThought {
  final List<ThoughtModel> results;

  AutogeneratedThought({this.results});

  factory AutogeneratedThought.fromJson(Map<String, dynamic> json) {
    List<ThoughtModel> temp;
    if (json['results'] != null) {
      temp = <ThoughtModel>[];
      json['results'].forEach((v) {
        temp.add(ThoughtModel.fromJson(v as Map<String, dynamic>));
      });
    }
    return AutogeneratedThought(results: temp);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ThoughtModel extends Equatable {
  String thoughtId;
  String imageUrl;
  final String fromUserId;
  final String toUserId;
  final String thoughtOptionCode;
  final DateTime createdDate;

  bool readFlag;

  ThoughtModel(this.fromUserId, this.toUserId, this.thoughtOptionCode,
      this.createdDate, this.imageUrl,
      [this.readFlag = false, this.thoughtId]);

  @override
  List<Object> get props => [
        thoughtId,
        fromUserId,
        toUserId,
        thoughtOptionCode,
        createdDate,
        imageUrl,
        readFlag
      ];

  factory ThoughtModel.fromJson(Map<String, dynamic> json) {
    return ThoughtModel(
        json['fromUserId'] as String,
        json['toUserId'] as String,
        json['thoughtOptionCode'] as String,
        json['createdDate'].toDate() as DateTime,
        json['imageUrl'] as String,
        json['readFlag'] as bool,
        json['thoughtId'] as String);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['fromUserId'] = this.fromUserId;
    data['toUserId'] = this.toUserId;
    data['thoughtOptionCode'] = this.thoughtOptionCode;
    data['createdDate'] = this.createdDate;
    data['thoughtId'] = this.thoughtId;
    data['imageUrl'] = this.imageUrl;
    data['readFlag'] = this.readFlag;
    return data;
  }
}
