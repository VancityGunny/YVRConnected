import 'dart:async';
import 'contact_api_provider.dart';
import '../models/friend_model.dart';

class Repository { 

  final contactApiProvider = ContactApiProvider();

  Future<FriendModel> fetchFriends() => contactApiProvider.fetchFriends();
}