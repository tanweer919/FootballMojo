import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/User.dart';

class FirebaseService {
  FirebaseAuth _auth;
  GoogleSignIn googleSignIn;
  String name;
  String email;
  String imageUrl;

  FirebaseService() {
    _auth = FirebaseAuth.instance;
    googleSignIn = GoogleSignIn();
  }

  Future<User> getCurrentUser() async {
    String name;
    User currentUser = null;
    final FirebaseUser _firebaseUser = await _auth.currentUser();
    if (_firebaseUser != null) {
      name = _firebaseUser.displayName;
      currentUser = User(
          uid: _firebaseUser.uid,
          name: name,
          email: _firebaseUser.email,
          profilePic: _firebaseUser.photoUrl);
    }
    return currentUser;
  }


  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoUrl != null);
    name = user.displayName;
    email = user.email;
    imageUrl = user.photoUrl;
    return User(uid: user.uid, name: name, email: email, profilePic: imageUrl);
  }

  void signOutGoogle() async {
    await _auth.signOut();
    await googleSignIn.signOut();
  }
}