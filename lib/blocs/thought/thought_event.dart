import 'dart:async';
import 'dart:developer' as developer;

import 'package:yvrconnected/blocs/thought/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ThoughtEvent {
  Stream<ThoughtState> applyAsync(
      {ThoughtState currentState, ThoughtBloc bloc});
  final ThoughtRepository _thoughtRepository = ThoughtRepository();
}

class AddingThoughtEvent extends ThoughtEvent {
  @override
  String toString() => 'AddingThoughtEvent';

  final ThoughtModel newThought;

  AddingThoughtEvent(this.newThought);

  @override
  Stream<ThoughtState> applyAsync(
      {ThoughtState currentState, ThoughtBloc bloc}) async* {
    var success = await _thoughtRepository.AddThought(this.newThought);
    if (success) {
      yield ThoughtAddedState(thought: this.newThought);
      //bloc.add(LoadingFriendsEvent()); // refresh friends List to reflect new thought update
    }
  }
}

class UninitThoughtEvent extends ThoughtEvent {
  @override
  Stream<ThoughtState> applyAsync(
      {ThoughtState currentState, ThoughtBloc bloc}) async* {
    yield UninitThoughtState();
  }
}

class InitThoughtEvent extends ThoughtEvent {
  final bool isError;
  @override
  String toString() => 'InitThoughtEvent';

  InitThoughtEvent(this.isError);

  @override
  Stream<ThoughtState> applyAsync(
      {ThoughtState currentState, ThoughtBloc bloc}) async* {
    try {
      yield UninitThoughtState();
      await Future.delayed(Duration(seconds: 1));
      this._thoughtRepository.test(this.isError);
      yield InitThoughtState();
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'InitThoughtEvent', error: _, stackTrace: stackTrace);
      yield ErrorThoughtState(_?.toString());
    }
  }
}
