import 'package:flutter/material.dart';
import 'package:yvrconnected/blocs/thought/index.dart';

class ThoughtPage extends StatefulWidget {
  static const String routeName = '/thought';

  @override
  _ThoughtPageState createState() => _ThoughtPageState();
}

class _ThoughtPageState extends State<ThoughtPage> {
  final _thoughtBloc = ThoughtBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thought'),
      ),
      body: ThoughtScreen(thoughtBloc: _thoughtBloc),
    );
  }
}
