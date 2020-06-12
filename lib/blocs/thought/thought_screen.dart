import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yvrfriends/blocs/thought/index.dart';

class ThoughtScreen extends StatefulWidget {
  const ThoughtScreen({
    Key key,
    @required ThoughtBloc thoughtBloc,
  })  : _thoughtBloc = thoughtBloc,
        super(key: key);

  final ThoughtBloc _thoughtBloc;

  @override
  ThoughtScreenState createState() {
    return ThoughtScreenState();
  }
}

class ThoughtScreenState extends State<ThoughtScreen> {
  ThoughtScreenState();

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
    return BlocBuilder<ThoughtBloc, ThoughtState>(
        bloc: widget._thoughtBloc,
        builder: (
          BuildContext context,
          ThoughtState currentState,
        ) {
          if (currentState is UninitThoughtState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentState is ErrorThoughtState) {
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
           if (currentState is InitThoughtState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
    widget._thoughtBloc.add(InitThoughtEvent(isError));
  }
}
