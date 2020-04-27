import 'dart:async';
import 'dart:developer' as developer;

import 'package:yvrconnected/blocs/friend/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FriendEvent {
  Stream<FriendState> applyAsync({FriendState currentState, FriendBloc bloc});
  final FriendRepository _friendRepository = FriendRepository();
}

class LoadingFriends extends FriendEvent {
  @override
  String toString() => 'LoadingFriends';

  @override
  Stream<FriendState> applyAsync(
      {FriendState currentState, FriendBloc bloc}) async* {
    List<FriendModel> friends = await this._friendRepository.fetchFriends();
    yield Loaded(friends: friends);
  }
}

class LoadFriendEvent extends FriendEvent {
  final bool isError;
  @override
  String toString() => 'LoadFriendEvent';

  LoadFriendEvent(this.isError);

  @override
  Stream<FriendState> applyAsync(
      {FriendState currentState, FriendBloc bloc}) async* {
    try {
      List<FriendModel> friends = await _friendRepository.fetchFriends();
      yield Loaded(friends: friends);
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadFriendEvent', error: _, stackTrace: stackTrace);
      yield ErrorFriendState(_?.toString());
    }
  }
}
