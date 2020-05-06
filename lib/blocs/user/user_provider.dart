import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yvrconnected/blocs/user/user_model.dart';

Firestore _firestore = Firestore.instance;

class UserProvider {
  Future<String> addUser(UserModel newUser) async {
     // if it's not already exists then add new user first
     var newUserObj = _firestore.collection('/users').document();
     newUserObj.setData({
        'uid': newUser.uid,
        'email': newUser.email,
        'phone': newUser.phone,
        'displayName': newUser.displayName,
        'friends': []
      });
      return newUserObj.documentID;
  }

}