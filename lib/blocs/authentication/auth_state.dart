import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthState extends Equatable {
  AuthState([List props = const []]) : super();
}

class UninitAuthState extends AuthState {
  @override
  String toString() => 'UninitAuthState';

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class AuthenticatedState extends AuthState {
  final String displayName;

  AuthenticatedState(this.displayName) : super([displayName]);

  @override
  String toString() => 'AuthenticatedState { displayName: $displayName }';

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class UnauthenticatedState extends AuthState {
  @override
  String toString() => 'UnauthenticatedState';

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LogInSuccessState extends AuthState {
  @override
  String toString() => 'LogInSuccessState';

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LogInFailureState extends AuthState {
  @override
  String toString() => 'LogInFailureState';

  @override
  // TODO: implement props
  List<Object> get props => null;
}
