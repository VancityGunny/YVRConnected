import 'package:equatable/equatable.dart';

import 'package:meta/meta.dart';

@immutable
abstract class AuthEvent extends Equatable {
  AuthEvent([List props = const []]) : super();
}

class AppStarted extends AuthEvent {
  @override
  String toString() => 'AppStarted';

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoggedIn extends AuthEvent {
  @override
  String toString() => 'LoggedIn';

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoggedOut extends AuthEvent {
  @override
  String toString() => 'LoggedOut';

  @override
  // TODO: implement props
  List<Object> get props => null;
}
