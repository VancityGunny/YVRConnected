import 'package:equatable/equatable.dart';

abstract class SecurityState extends Equatable {
  /// notify change state without deep clone state
  final int version;
  
  final List propss;
  SecurityState(this.version,[this.propss]);

  /// Copy object for use in action
  /// if need use deep clone
  SecurityState getStateCopy();

  SecurityState getNewVersion();

  @override
  List<Object> get props => ([version, ...propss ?? []]);
}

/// UnInitialized
class UnSecurityState extends SecurityState {

  UnSecurityState(int version) : super(version);

  @override
  String toString() => 'UnSecurityState';

  @override
  UnSecurityState getStateCopy() {
    return UnSecurityState(0);
  }

  @override
  UnSecurityState getNewVersion() {
    return UnSecurityState(version+1);
  }
}

/// Initialized
class InSecurityState extends SecurityState {
  final String hello;

  InSecurityState(int version, this.hello) : super(version, [hello]);

  @override
  String toString() => 'InSecurityState $hello';

  @override
  InSecurityState getStateCopy() {
    return InSecurityState(this.version, this.hello);
  }

  @override
  InSecurityState getNewVersion() {
    return InSecurityState(version+1, this.hello);
  }
}

class ErrorSecurityState extends SecurityState {
  final String errorMessage;

  ErrorSecurityState(int version, this.errorMessage): super(version, [errorMessage]);
  
  @override
  String toString() => 'ErrorSecurityState';

  @override
  ErrorSecurityState getStateCopy() {
    return ErrorSecurityState(this.version, this.errorMessage);
  }

  @override
  ErrorSecurityState getNewVersion() {
    return ErrorSecurityState(version+1, this.errorMessage);
  }
}
