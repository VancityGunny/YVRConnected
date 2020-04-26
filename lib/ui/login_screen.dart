import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yvrconnected/blocs/authentication/auth_bloc.dart';
import 'package:yvrconnected/blocs/authentication/auth_repository.dart';

import 'login_form.dart';

class LoginScreen extends StatefulWidget {
  final AuthRepository _authRepository;

  LoginScreen({Key key, @required AuthRepository authRepository})
      : assert(authRepository != null),
        _authRepository = authRepository,
        super(key: key);

  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  AuthRepository get _authRepository => widget._authRepository;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: BlocProvider<AuthBloc>(
        create: (BuildContext context) => BlocProvider.of<AuthBloc>(context), //bloc: _authBloc,

        child: LoginForm(userRepository: _authRepository),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
