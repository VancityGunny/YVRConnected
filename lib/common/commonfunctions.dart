import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';




class CommonFunctions {
  static void pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  static void goHome(BuildContext context) {
    CommonFunctions.pushPage(
        context, MyHomePage(title: 'Flutter Demo Home Page'));
  }
  static void signOut(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();
    CommonFunctions.pushPage(
        context, MyHomePage(title: 'Flutter Demo Home Page'));
  }
 
}
