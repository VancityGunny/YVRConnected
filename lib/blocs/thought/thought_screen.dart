import 'package:flutter/material.dart';
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
    return Text('');
  }

  void _load([bool isError = false]) {
    widget._thoughtBloc.add(InitThoughtEvent(isError));
  }
}
