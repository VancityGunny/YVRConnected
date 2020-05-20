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
class FriendsLoadedState extends FriendState {
  final List<FriendModel> friends;

  FriendsLoadedState({@required this.friends});

  @override
  List<Object> get props => [friends];

  @override
  String toString() => 'LoadedState';
}

class FriendAddedState extends FriendState {
  final FriendModel friend;
  FriendAddedState({@required this.friend});
  @override
  List<Object> get props => [friend];

  @override
  String toString() => 'FriendAddedState';
}

class UninitFriendState extends FriendState {
  @override
  String toString() => 'UninitFriendState';

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
