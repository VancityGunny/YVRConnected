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
    // add sentThoughts and receivedThought colleciton for the user too
    var newThoughtsObj =
        _firestore.collection('/thoughts').document(newUserObj.documentID);
    newThoughtsObj.setData({'sentThoughts': [], 'receivedThoughts': []});
    return newUserObj.documentID;
  }

  void assumeUser(String foundUserId, UserModel userModel) {
    _firestore.collection('/users').document(foundUserId).updateData({
      'uid': userModel.uid,
      'phone': userModel.phone,
      'displayName': userModel.displayName,
      'photoUrl': userModel.photoUrl
    });
  }
}
