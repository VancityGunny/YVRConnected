import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:yvrconnected/blocs/friend/index.dart';
import 'dart:developer' as developer;

class FriendBloc extends Bloc<FriendEvent, FriendState> {
  @override
  FriendState get initialState => UninitFriendState();

  @override
  Stream<FriendState> mapEventToState(
    FriendEvent event,
  ) async* {
    try {
      yield* event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'FriendBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }
}
