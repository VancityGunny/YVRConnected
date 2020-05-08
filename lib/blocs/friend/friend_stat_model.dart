import 'package:equatable/equatable.dart';
import 'package:yvrconnected/blocs/friend/friend_model.dart';

class FriendStatModel extends Equatable {
  final FriendModel friend;
  final int thoughtSent;
  
  FriendStatModel(this.friend, this.thoughtSent);

  @override
  List<Object> get props => [friend, thoughtSent];

  factory FriendStatModel.fromJson(Map<dynamic, dynamic> json) {
    return FriendStatModel(json['friend'] as FriendModel, json['thoughtSent'] as int);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['friend'] = this.friend;
    data['thoughtSent'] = this.thoughtSent;
    return data;
  }
  
}
