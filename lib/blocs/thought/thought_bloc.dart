import 'dart:async';
import 'dart:developer' as developer;
import 'package:bloc/bloc.dart';
import 'package:yvrconnected/blocs/thought/index.dart';

class ThoughtBloc extends Bloc<ThoughtEvent, ThoughtState> {
  @override
  ThoughtState get initialState => UninitThoughtState();

  @override
  Stream<ThoughtState> mapEventToState(
    ThoughtEvent event,
  ) async* {
    try {
      yield* event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'ThoughtBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }
}
