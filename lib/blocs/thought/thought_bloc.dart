import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:yvrconnected/blocs/thought/index.dart';

class ThoughtBloc extends Bloc<ThoughtEvent, ThoughtState> {
  // todo: check singleton for logic in project
  static final ThoughtBloc _thoughtBlocSingleton = ThoughtBloc._internal();
  factory ThoughtBloc() {
    return _thoughtBlocSingleton;
  }
  ThoughtBloc._internal();
  
  @override
  Future<void> close() async{
    // dispose objects
    await super.close();
  }

  @override
  ThoughtState get initialState => UninitThoughtState();

  @override
  Stream<ThoughtState> mapEventToState(
    ThoughtEvent event,
  ) async* {
    try {
      yield* await event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'ThoughtBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }
}
