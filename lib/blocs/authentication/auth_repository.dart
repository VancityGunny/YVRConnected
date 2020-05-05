import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  static final _firestore = Firestore.instance;
  final GoogleSignIn _googleSignIn;

  AuthRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignin})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn();

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await _firebaseAuth.signInWithCredential(credential);
    var user = await _firebaseAuth.currentUser();

    var foundUsers = await _firestore
        .collection('/users')
        .where('uid', isEqualTo: user.uid)
        .getDocuments();
    var newUser = null;
    if (foundUsers.documents.length == 0) {
// check if user record does not exist then create the record
      newUser = _firestore.collection('/users').document().setData({
        'uid': user.uid,
        'email': user.email,
        'phone': user.phoneNumber,
        'displayName': user.displayName
      });
    }

    return newUser;
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();

    return currentUser != null;
  }

  Future<String> getUser() async {
    return (await _firebaseAuth.currentUser()).email;
  }
}
