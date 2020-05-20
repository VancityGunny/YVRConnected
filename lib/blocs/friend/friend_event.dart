import 'dart:async';
import 'dart:developer' as developer;
import 'dart:typed_data';
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
  final Uint8List thumbnail;
  AddingFriendEvent(this.newFriend, this.thumbnail);
  @override
  Stream<FriendState> applyAsync(
      {FriendState currentState, FriendBloc bloc}) async* {
    var success = await _friendRepository.AddFriend(this.newFriend, this.thumbnail);
    if (success) {
      yield FriendAddedState(friend: this.newFriend);
    }
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

      //yield FriendsLoadedState(friends: friends);
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadFriendEvent', error: _, stackTrace: stackTrace);
      yield ErrorFriendState(_?.toString());
    }
  }
}
