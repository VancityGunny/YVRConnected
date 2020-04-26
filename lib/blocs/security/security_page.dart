import 'package:flutter/material.dart';
import 'package:yvrconnected/blocs/security/index.dart';

class SecurityPage extends StatefulWidget {
  static const String routeName = '/security';

  @override
  _SecurityPageState createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  final _securityBloc = SecurityBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Security'),
      ),
      body: SecurityScreen(securityBloc: _securityBloc),
    );
  }
}
