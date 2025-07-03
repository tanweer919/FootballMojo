import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import '../models/User.dart' as app_models;
import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseService {
  final firebase_auth.FirebaseAuth _auth;
  final GoogleSignIn googleSignIn;
  final SharedPreferences _prefs;
  String? name;
  String? email;
  String? imageUrl;
  bool _isInitialized = false;

  FirebaseService({required SharedPreferences prefs})
      : _auth = firebase_auth.FirebaseAuth.instance,
        googleSignIn = GoogleSignIn(),
        _prefs = prefs {
    _initialize();
  }

  Future<void> _initialize() async {
    if (_isInitialized) {
      developer.log('FirebaseService already initialized');
      return;
    }

    try {
      developer.log('Initializing FirebaseService');
      await _loadUserState();
      _isInitialized = true;
      developer.log('FirebaseService initialized successfully');
    } catch (e, stackTrace) {
      developer.log(
        'Error initializing FirebaseService',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _loadUserState() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        name = currentUser.displayName;
        email = currentUser.email;
        imageUrl = currentUser.photoURL;
        await _saveUserState();
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error loading user state',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _saveUserState() async {
    try {
      await _prefs.setString('user_name', name ?? '');
      await _prefs.setString('user_email', email ?? '');
      await _prefs.setString('user_image', imageUrl ?? '');
    } catch (e, stackTrace) {
      developer.log(
        'Error saving user state',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<app_models.User?> getCurrentUser() async {
    if (!_isInitialized) {
      developer
          .log('FirebaseService not initialized when getting current user');
      return null;
    }

    try {
      final firebase_auth.User? firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        developer.log('Current user found: ${firebaseUser.uid}');
        return app_models.User(
          uid: firebaseUser.uid,
          name: firebaseUser.displayName,
          email: firebaseUser.email,
          profilePic: firebaseUser.photoURL,
        );
      }
      developer.log('No current user found');
      return null;
    } catch (e, stackTrace) {
      developer.log(
        'Error getting current user',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<app_models.User?> signInWithGoogle() async {
    if (!_isInitialized) {
      developer
          .log('FirebaseService not initialized when signing in with Google');
      return null;
    }

    try {
      developer.log('Starting Google sign in');
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        developer.log('Google sign in cancelled by user');
        return null;
      }

      developer.log('Getting Google authentication');
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final firebase_auth.AuthCredential credential =
          firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      developer.log('Signing in with Firebase');
      final firebase_auth.UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final firebase_auth.User? user = authResult.user;

      if (user == null) {
        developer.log('No user returned from Firebase sign in');
        return null;
      }

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final firebase_auth.User? currentUser = _auth.currentUser;
      assert(user.uid == currentUser?.uid);

      name = user.displayName;
      email = user.email;
      imageUrl = user.photoURL;

      await _saveUserState();
      developer.log('User signed in successfully: ${user.uid}');

      return app_models.User(
        uid: user.uid,
        name: name,
        email: email,
        profilePic: imageUrl,
      );
    } catch (e, stackTrace) {
      developer.log(
        'Error signing in with Google',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<void> signOutGoogle() async {
    if (!_isInitialized) {
      developer.log('FirebaseService not initialized when signing out');
      return;
    }

    try {
      developer.log('Starting sign out process');
      await _auth.signOut();
      await googleSignIn.signOut();
      name = null;
      email = null;
      imageUrl = null;
      await _saveUserState();
      developer.log('User signed out successfully');
    } catch (e, stackTrace) {
      developer.log(
        'Error signing out',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  void dispose() {
    _isInitialized = false;
    name = null;
    email = null;
    imageUrl = null;
  }
}
