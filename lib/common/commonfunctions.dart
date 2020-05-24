import 'package:flutter/material.dart';

class CommonFunctions {
  static void pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  static void goHome(BuildContext context) {
    // CommonFunctions.pushPage(
    //     context, HomeScreen(title: 'Flutter Demo Home Page'));
  }
  static void signOut(BuildContext context) async {
    // final FirebaseAuth _auth = FirebaseAuth.instance;
    // await _auth.signOut();
    // CommonFunctions.pushPage(
    //     context, MyHomePage(title: 'Flutter Demo Home Page'));
  }
}
