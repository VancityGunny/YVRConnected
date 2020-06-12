import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:yvrfriends/blocs/thought/index.dart';
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
  final BuildContext context;

  AddingThoughtEvent(this.newThought, this.context);

  @override
  Stream<ThoughtState> applyAsync(
      {ThoughtState currentState, ThoughtBloc bloc}) async* {
    var newThoughtId = await _thoughtRepository.addThought(
        this.newThought,null, this.context);
    if (newThoughtId != null) {
      this.newThought.thoughtId = newThoughtId;
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
