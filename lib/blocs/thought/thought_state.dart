import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:yvrfriends/blocs/thought/thought_model.dart';

abstract class ThoughtState extends Equatable {
  final List propss;
  ThoughtState([this.propss]);

  @override
  List<Object> get props => null;
}

class ThoughtAddedState extends ThoughtState {
  final ThoughtModel thought;
  ThoughtAddedState({@required this.thought});

  @override
  String toString() => 'ThoughtAddedState';
}

/// UnInitialized
class UninitThoughtState extends ThoughtState {
  @override
  String toString() => 'UninitThoughtState';
}

/// Initialized
class InitThoughtState extends ThoughtState {
  @override
  String toString() => 'InitThoughtState';
}

class ErrorThoughtState extends ThoughtState {
  final String errorMessage;
  ErrorThoughtState(this.errorMessage) : super([errorMessage]);
  @override
  String toString() => 'ErrorThoughtState';
}
