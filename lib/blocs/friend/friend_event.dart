import 'dart:async';
import 'dart:developer' as developer;

import 'package:yvrconnected/blocs/friend/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FriendEvent {
  Stream<FriendState> applyAsync({FriendState currentState, FriendBloc bloc});
  final FriendRepository _friendRepository = FriendRepository();
}

class AddingFriendEvent extends FriendEvent{
    @override
  String toString() => 'AddingFriendEvent';

  final FriendModel newFriend;

  AddingFriendEvent(this.newFriend);
  @override
  Stream<FriendState> applyAsync({FriendState currentState, FriendBloc bloc}) {
    // TODO: implement applyAsync
    _friendRepository.AddFriend(this.newFriend);
    return null;
  }

}

class LoadingFriendsEvent extends FriendEvent {
  @override
  String toString() => 'LoadingFriendsEvent';

  @override
  Stream<FriendState> applyAsync(
      {FriendState currentState, FriendBloc bloc}) async* {
    List<FriendModel> friends = await this._friendRepository.fetchFriends();
    yield LoadedState(friends: friends);
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
      yield LoadedState(friends: friends);
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadFriendEvent', error: _, stackTrace: stackTrace);
      yield ErrorFriendState(_?.toString());
    }
  }
}
