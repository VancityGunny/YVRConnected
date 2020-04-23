import 'dart:async';
//import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'package:cloud_functions/cloud_functions.dart';

import '../models/friend_model.dart';
import 'package:http/http.dart';

class ContactApiProvider {
  String fakeFriendList =
      "{friends:[{'name':'Kobe Wanlop','email': 'kobe@gmail.com'},{'name':'Ooh Supachok','email': 'ooh@gmail.com'},{'name':'Ab oat','email': 'ab@gmail.com'}]}";

  Future<FriendModel> fetchFriends() async {
    // var friendsJson = jsonDecode(fakeFriendList)['friends'] as List;
    // List<FriendModel> friendList =
    //     friendsJson.map((tagJson) => FriendModel.fromJson(tagJson)).toList();
    // return friendList.first;

    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'getFriends',
    );
    dynamic resp = await callable.call();
    // var data = await get(
    //     'https://us-central1-yvrhuman-6887a.cloudfunctions.net/getFriends');
    //     var company = new Company.fromJson(json.decode(data.body));
    // setState(() {
    //   _data = company.name;
    // });
    return new  FriendModel('Kobe', 'Kobe@gmail.com');
  }
}
