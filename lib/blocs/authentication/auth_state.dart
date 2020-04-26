import 'package:equatable/equatable.dart';

import 'package:meta/meta.dart';

@immutable
abstract class AuthState extends Equatable {
  AuthState([List props = const []]) : super();
}

class Uninitialized extends AuthState {
  @override
  String toString() => 'Uninitialized';

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class Authenticated extends AuthState {
  final String displayName;

  Authenticated(this.displayName) : super([displayName]);

  @override
  String toString() => 'Authenticated { displayName: $displayName }';

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class Unauthenticated extends AuthState {
  @override
  String toString() => 'Unauthenticated';

  @override
  // TODO: implement props
  List<Object> get props => null;
}
