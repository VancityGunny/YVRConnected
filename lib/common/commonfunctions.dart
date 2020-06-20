import 'package:flutter/material.dart';
import 'package:yvrfriends/generated/l10n.dart';

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
  static String formatPostDateForDisplay(
      DateTime postedDate, BuildContext context) {
    final delegate = S.of(context);
    var timeElapsed = DateTime.now().difference(postedDate);
    if (timeElapsed.inDays < 1) {
      if (timeElapsed.inHours < 1) {
        if (timeElapsed.inMinutes < 1) {
          return delegate.justNowLabel;
        } else {
          return timeElapsed.inMinutes.toString() +
              ' ' +
              delegate.minutesAgoSuffix;
        }
      } else {
        return timeElapsed.inHours.toString() + ' ' + delegate.hoursAgoSuffix;
      }
    } else {
      return timeElapsed.inDays.toString() + ' ' + delegate.daysAgoSuffix;
    }
  }
}
