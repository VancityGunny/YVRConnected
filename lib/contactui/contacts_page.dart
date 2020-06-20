import 'package:flutter/material.dart';
import 'package:yvrfriends/common/commonfunctions.dart';

class ContactsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ContactsPageState();
  }
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    return Text('');
  }

  void viewHome() {
    
    CommonFunctions.goHome(context);
  }

  void showContactListPage() {}
}

