import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/User.dart';

class FirebaseService {
  final FirebaseAuth _auth;
  final GoogleSignIn googleSignIn;
  String? name;
  String? email;
  String? imageUrl;

  FirebaseService()
      : _auth = FirebaseAuth.instance,
        googleSignIn = GoogleSignIn();

  Future<User?> getCurrentUser() async {
    User? currentUser; // Defaulting to null is implicit for nullable types
    // _auth.currentUser() from older firebase_auth returns FirebaseUser, not User.
    // And it might be null.
    final FirebaseUser? firebaseUser = await _auth.currentUser();
    if (firebaseUser != null) {
      // Assuming User model constructor can handle String? for name, email, profilePic
      currentUser = User(
          uid: firebaseUser.uid, // uid is typically non-null
          name: firebaseUser.displayName,
          email: firebaseUser.email,
          profilePic: firebaseUser.photoUrl);
    }
    return currentUser;
  }

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount == null) {
      // User cancelled sign-in
      return null;
    }
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    // Assuming GoogleAuthProvider.getCredential is from an older library version
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    // authResult.user is FirebaseUser in older versions
    final FirebaseUser? user = authResult.user;

    if (user == null) {
      return null;
    }

    // Assertions remain, but now 'user' is checked for nullness above.
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    // _auth.currentUser() returns FirebaseUser in older versions
    final FirebaseUser? currentFbUser = await _auth.currentUser();
    // It's possible currentFbUser is null briefly if events haven't propagated,
    // though ideally it should be the same as 'user'.
    // For robustness, check currentFbUser as well if strict assertion is needed.
    assert(user.uid == currentFbUser?.uid);

    // user.email, user.displayName, user.photoUrl can be null
    // Assigning them to nullable class members
    name = user.displayName;
    email = user.email;
    imageUrl = user.photoUrl;

    // Assuming User model constructor can handle String? for name, email, profilePic
    return User(
        uid: user.uid, // uid is typically non-null
        name: name,
        email: email,
        profilePic: imageUrl);
  }

  Future<void> signOutGoogle() async {
    await _auth.signOut();
    await googleSignIn.signOut();
    // Consider clearing local user data/state if needed
    name = null;
    email = null;
    imageUrl = null;
  }
}