import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:yvrconnected/blocs/authentication/auth_repository.dart';
import 'package:yvrconnected/blocs/authentication/index.dart';


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
    }
  }

  Stream<AuthState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _authRepository.isSignedIn();

      if (isSignedIn) {
        final user = await _authRepository.getUser();

        yield AuthenticatedState(user.displayName);
      } else {
        yield UnauthenticatedState();
      }
    } catch (_) {
      yield UnauthenticatedState();
    }
  }

  Stream<AuthState> _mapLoggedInToState() async* {
    final user = await _authRepository.getUser();

    yield AuthenticatedState(user.displayName);
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
}
