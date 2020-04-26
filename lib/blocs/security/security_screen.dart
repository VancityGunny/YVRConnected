import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yvrconnected/blocs/security/index.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({
    Key key,
    @required SecurityBloc securityBloc,
  })  : _securityBloc = securityBloc,
        super(key: key);

  final SecurityBloc _securityBloc;

  @override
  SecurityScreenState createState() {
    return SecurityScreenState();
  }
}

class SecurityScreenState extends State<SecurityScreen> {
  SecurityScreenState();

  @override
  void initState() {
    super.initState();
    this._load();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SecurityBloc, SecurityState>(
        bloc: widget._securityBloc,
        builder: (
          BuildContext context,
          SecurityState currentState,
        ) {
          if (currentState is UnSecurityState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentState is ErrorSecurityState) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(currentState.errorMessage ?? 'Error'),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: RaisedButton(
                    color: Colors.blue,
                    child: Text('reload'),
                    onPressed: () => this._load(),
                  ),
                ),
              ],
            ));
          }
           if (currentState is InSecurityState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(currentState.hello),
                  Text('Flutter files: done'),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: RaisedButton(
                      color: Colors.red,
                      child: Text('throw error'),
                      onPressed: () => this._load(true),
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(
              child: CircularProgressIndicator(),
          );
          
        });
  }

  void _load([bool isError = false]) {
    widget._securityBloc.add(LoadSecurityEvent(isError));
  }
}
