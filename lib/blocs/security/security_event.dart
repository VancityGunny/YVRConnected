import 'dart:async';
import 'dart:developer' as developer;

import 'package:yvrconnected/blocs/security/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SecurityEvent {
  Stream<SecurityState> applyAsync(
      {SecurityState currentState, SecurityBloc bloc});
  final SecurityRepository _securityRepository = SecurityRepository();
}

class UnSecurityEvent extends SecurityEvent {
  @override
  Stream<SecurityState> applyAsync({SecurityState currentState, SecurityBloc bloc}) async* {
    yield UnSecurityState(0);
  }
}

class LoadSecurityEvent extends SecurityEvent {
   
  final bool isError;
  @override
  String toString() => 'LoadSecurityEvent';

  LoadSecurityEvent(this.isError);

  @override
  Stream<SecurityState> applyAsync(
      {SecurityState currentState, SecurityBloc bloc}) async* {
    try {
      yield UnSecurityState(0);
      await Future.delayed(Duration(seconds: 1));
      this._securityRepository.test(this.isError);
      yield InSecurityState(0, 'Hello world');
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadSecurityEvent', error: _, stackTrace: stackTrace);
      yield ErrorSecurityState(0, _?.toString());
    }
  }
}
