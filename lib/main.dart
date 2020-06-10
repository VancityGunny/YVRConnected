import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:yvrconnected/blocs/authentication/auth_bloc.dart';
import 'package:yvrconnected/blocs/authentication/auth_repository.dart';
import 'package:yvrconnected/simple_bloc_delegate.dart';
import 'package:yvrconnected/ui/home_screen.dart';
import 'package:yvrconnected/ui/login_screen.dart';
import 'package:yvrconnected/ui/splash_screen.dart';
import 'blocs/authentication/auth_event.dart';
import 'blocs/authentication/auth_state.dart';
import 'common/common_bloc.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final AuthRepository _authRepository = AuthRepository();

  AuthBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();

    _authenticationBloc = AuthBloc(authRepository: _authRepository);

    _authenticationBloc.add(AppStartedEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) =>
            _authenticationBloc, //bloc: _authenticationBloc,
        child: CommonBloc(
            child: MaterialApp(
          theme: ThemeData(
              primaryColor: Colors.yellow[800],
              accentColor: Colors.yellow[600]),
          debugShowCheckedModeBanner: false,
          home: BlocBuilder(
            bloc: _authenticationBloc,
            builder: (BuildContext context, AuthState state) {
              if (state is UninitAuthState) {
                return SplashScreen();
              }
              if (state is UnauthenticatedState) {
                return LoginScreen();
              }
              if (state is AuthenticatedState) {
                return HomeScreen(state.displayName);
              }
              return Scaffold(
                  body: Container(
                child: Text('Login Failed'),
              ));
            },
          ),
        )));
  }

  @override
  void dispose() {
    _authenticationBloc.close();
    super.dispose();
  }
}

void _listContacts() async {
  // Get all contacts on device
  Iterable<Contact> contacts = await ContactsService.getContacts();
  contacts.forEach((contact) {
    print(contact.displayName);
  });
}

void _requestContactPermission() async {
  if (await Permission.contacts.request().isGranted) {
    // Either the permission was already granted before or the user just granted it.
  }
}
