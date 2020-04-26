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
  AuthState get initialState => Uninitialized();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    } else if (event is LogInWithGooglePressed) {
      yield* _mapLoginWithGooglePressedToState();
    }
  }

  Stream<AuthState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _authRepository.isSignedIn();

      if (isSignedIn) {
        final name = await _authRepository.getUser();

        yield Authenticated(name);
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthState> _mapLoggedInToState() async* {
    final name = await _authRepository.getUser();
    yield Authenticated(name);
  }

  Stream<AuthState> _mapLoggedOutToState() async* {
    yield Unauthenticated();

    _authRepository.signOut();
  }

  Stream<AuthState> _mapLoginWithGooglePressedToState() async* {
    try {
      await _authRepository.signInWithGoogle();

      yield LogInSuccess();
    } catch (_) {
      yield LogInFailure();
    }
  }
}
