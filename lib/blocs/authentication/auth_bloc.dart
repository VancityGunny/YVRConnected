import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:yvrfriends/blocs/authentication/auth_repository.dart';
import 'package:yvrfriends/blocs/authentication/index.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({@required AuthRepository authRepository})
      : assert(AuthRepository != null),
        _authRepository = authRepository;

  @override
  AuthState get initialState => UninitAuthState();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AppStartedEvent) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedInEvent) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOutEvent) {
      yield* _mapLoggedOutToState();
    } else if (event is LogInWithGooglePressedEvent) {
      yield* _mapLoginWithGooglePressedToState();
    } else if (event is LogInWithPhonePressedEvent) {
      yield* _mapLoginWithPhonePressedToState(event);
    }
  }

  Stream<AuthState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _authRepository.isSignedIn();

      if (isSignedIn) {
        final user = await _authRepository.getUser();
        if (user.phone != null) {
          // as long as we have phone number, whether it be from gmail account or verified by phone we don't care
          yield AuthenticatedState(user.displayName);
        } else {
          yield PhoneVerificationAuthState();
        }
      } else {
        yield UnauthenticatedState();
      }
    } catch (_) {
      yield UnauthenticatedState();
    }
  }

  Stream<AuthState> _mapLoggedInToState() async* {
    final user = await _authRepository.getUser();
    if (user.phone != null) {
      // as long as we have phone number, whether it be from gmail account or verified by phone we don't care
      yield AuthenticatedState(user.displayName);
    } else {
      yield PhoneVerificationAuthState();
    }
  }

  Stream<AuthState> _mapLoggedOutToState() async* {
    yield UnauthenticatedState();

    _authRepository.signOut();
  }

  Stream<AuthState> _mapLoginWithGooglePressedToState() async* {
    try {
      await _authRepository.signInWithGoogle();

      yield LogInSuccessState();
    } catch (_) {
      yield LogInFailureState();
    }
  }

  Stream<AuthState> _mapLoginWithPhonePressedToState(
      LogInWithPhonePressedEvent event) async* {
    try {
      await _authRepository.signInWithPhoneNumber(
          event.credential, event.phoneNumber);

      final user = await _authRepository.getUser();
      yield AuthenticatedState(user.displayName);
    } catch (_) {
      yield LogInFailureState();
    }
  }
}
