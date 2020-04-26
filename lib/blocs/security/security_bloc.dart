import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:yvrconnected/blocs/security/index.dart';

class SecurityBloc extends Bloc<SecurityEvent, SecurityState> {
  // todo: check singleton for logic in project
  static final SecurityBloc _securityBlocSingleton = SecurityBloc._internal();
  factory SecurityBloc() {
    return _securityBlocSingleton;
  }
  SecurityBloc._internal();
  
  @override
  Future<void> close() async{
    // dispose objects
    await super.close();
  }

  @override
  SecurityState get initialState => UnSecurityState(0);

  @override
  Stream<SecurityState> mapEventToState(
    SecurityEvent event,
  ) async* {
    try {
      yield* await event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'SecurityBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }
}
