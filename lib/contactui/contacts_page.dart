import 'package:flutter/material.dart';
import 'package:yvrconnected/common/commonfunctions.dart';

class ContactsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ContactsPageState();
  }
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YVRHuman'),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: viewHome,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.favorite),
            color: Colors.white,
            onPressed: showContactListPage,
          )
        ],
      ),
      body: SafeArea(child: LoveSentList()),
    );
  }

  void viewHome() {
    
    CommonFunctions.goHome(context);
  }

  void showContactListPage() {}
}

// List of all the statistic of love sent out from user
class LoveSentList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView (
      children: [Text('miss 19 people'), Text('remind of 12 people'), Text('grateful for 5 people')]
    );
  }
}
