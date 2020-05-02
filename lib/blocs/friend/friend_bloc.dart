import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:yvrconnected/blocs/friend/index.dart';

class FriendBloc extends Bloc<FriendEvent, FriendState> {
  // todo: check singleton for logic in project
  static final FriendBloc _friendBlocSingleton = FriendBloc._internal();
  factory FriendBloc() {
    return _friendBlocSingleton;
  }
  FriendBloc._internal();
  
  @override
  Future<void> close() async{
    // dispose objects
    await super.close();
  }

  @override
  FriendState get initialState => UninitFriendState();

  @override
  Stream<FriendState> mapEventToState(
    FriendEvent event,
  ) async* {
    try {
      yield* await event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'FriendBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }
}
