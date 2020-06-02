import 'package:equatable/equatable.dart';

class InteractionModel extends Equatable {
  String interactionId;
  final String fromUserId;
  final String toUserId;
  final String interactionOptionCode;
  final DateTime createdDate;

  InteractionModel(this.fromUserId, this.toUserId, this.interactionOptionCode,
      this.createdDate,
      [this.interactionId]);

  @override
  List<Object> get props => [
        interactionId,
        fromUserId,
        toUserId,
        interactionOptionCode,
        createdDate
      ];

  factory InteractionModel.fromJson(Map<String, dynamic> json) {
    return InteractionModel(
        json['fromUserId'] as String,
        json['toUserId'] as String,
        json['interactionOptionCode'] as String,
        json['createdDate'].toDate() as DateTime,
        json['interactionId'] as String);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['fromUserId'] = this.fromUserId;
    data['toUserId'] = this.toUserId;
    data['interactionOptionCode'] = this.interactionOptionCode;
    data['createdDate'] = this.createdDate;
    data['interactionId'] = this.interactionId;
    return data;
  }
}
