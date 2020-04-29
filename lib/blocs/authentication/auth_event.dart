import 'package:equatable/equatable.dart';

import 'package:meta/meta.dart';

@immutable
abstract class AuthEvent extends Equatable {
  AuthEvent([List props = const []]) : super();
}

class AppStartedEvent extends AuthEvent {
  @override
  String toString() => 'AppStartedEvent';

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoggedInEvent extends AuthEvent {
  @override
  String toString() => 'LoggedInEvent';

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoggedOutEvent extends AuthEvent {
  @override
  String toString() => 'LoggedOutEvent';

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LogInWithGooglePressedEvent extends AuthEvent {
  @override
  String toString() => 'LogInWithGooglePressedEvent';

  @override
  // TODO: implement props
  List<Object> get props => null;
}
