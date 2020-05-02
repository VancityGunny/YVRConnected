import 'dart:async';
import 'dart:developer' as developer;
import 'package:yvrconnected/blocs/friend/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FriendEvent {
  Stream<FriendState> applyAsync({FriendState currentState, FriendBloc bloc});
  final FriendRepository _friendRepository = FriendRepository();
}

class AddingFriendEvent extends FriendEvent {
  @override
  String toString() => 'AddingFriendEvent';

  final FriendModel newFriend;

  AddingFriendEvent(this.newFriend);
  @override
  Stream<FriendState> applyAsync(
      {FriendState currentState, FriendBloc bloc}) async* {
    var success = await _friendRepository.AddFriend(this.newFriend);
    if (success) {
      yield FriendAddedState(friend: this.newFriend);
      bloc.add(LoadingFriendsEvent()); // refresh Friends List
    }
  }
}

class LoadingFriendsEvent extends FriendEvent {
  @override
  String toString() => 'LoadingFriendsEvent';

  @override
  Stream<FriendState> applyAsync(
      {FriendState currentState, FriendBloc bloc}) async* {
    List<FriendModel> friends = await this._friendRepository.fetchFriends();
    yield FriendsLoadedState(friends: friends);
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
      yield FriendsLoadedState(friends: friends);
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadFriendEvent', error: _, stackTrace: stackTrace);
      yield ErrorFriendState(_?.toString());
    }
  }
}
