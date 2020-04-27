import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'friend_model.dart';

abstract class FriendState extends Equatable {
  final List propss;
  FriendState([this.propss]);

  @override
  List<Object> get props => null;
}

/// Loaded all friends
class Loaded extends FriendState {
  final List<FriendModel> friends;

  Loaded({@required this.friends});

  @override
  List<Object> get props => [friends];

  @override
  String toString() => 'Loaded';
}

class FriendAdded extends FriendState {
  final FriendModel friend;
  FriendAdded({@required this.friend});
  @override
  List<Object> get props => [friend];

  @override
  String toString() => 'FriendAdded';
}

class Uninitialized extends FriendState {
  @override
  String toString() => 'Uninitialized';

  @override
  // TODO: implement props
  List<Object> get props => null;
}


class ErrorFriendState extends FriendState {
  final String errorMessage;

  ErrorFriendState( this.errorMessage)
      : super([errorMessage]);

  @override
  String toString() => 'ErrorFriendState';
}
