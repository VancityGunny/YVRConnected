import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';
import 'package:yvrconnected/blocs/user/user_model.dart';
import 'package:yvrconnected/blocs/user/user_provider.dart';
import 'package:yvrconnected/common/global_object.dart' as globals;

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
    if (foundUsers.documents.length == 0) {
      var findByEmail = await _firestore
          .collection('/users')
          .where('email', isEqualTo: user.email)
          .getDocuments();
      var userProvider = UserProvider();
      if (findByEmail.documents.length == 0) {
        // check if user record does not exist then create the record
        var uuid = new Uuid();
        var userId = uuid.v1();
        await userProvider.addUser(
            userId.toString(),
            new UserModel(user.uid, user.email, user.displayName,
                user.phoneNumber, [], [], user.photoUrl));
        globals.currentUserId = userId;
      } else {
        // assume account found by the email
        userProvider.assumeUser(
            findByEmail.documents.first.documentID,
            new UserModel(user.uid, user.email, user.displayName,
                user.phoneNumber, [], [], user.photoUrl));
        globals.currentUserId = findByEmail.documents.first.documentID;
      }
    }
    return user;
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

  Future<UserModel> getUser() async {
    var user = await _firebaseAuth.currentUser();

    var foundUsers = await _firestore
        .collection('/users')
        .where('uid', isEqualTo: user.uid)
        .getDocuments();
    var loggedInUser = UserModel.fromJson(foundUsers.documents[0].data);
    globals.loggedInUser = loggedInUser;
    globals.currentUserId = foundUsers.documents[0].documentID;
    return loggedInUser;
  }
}
