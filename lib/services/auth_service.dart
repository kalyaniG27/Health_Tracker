import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:health_tracker_app/models/user_profile.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Stream to listen to authentication state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // Handle errors like user-not-found, wrong-password, etc.
      debugPrint(e.message);
      return null;
    }
  }

  // Sign up with email and password
  Future<UserCredential?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // After creating the user, create a new document for them in Firestore
      await _createUserDocument(userCredential.user);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Handle errors like email-already-in-use, weak-password, etc.
      debugPrint(e.message);
      return null;
    }
  }

  // Create a user document in Firestore
  Future<void> _createUserDocument(User? user) async {
    if (user == null) return;

    final userProfile = UserProfile.createNew(
        name: 'New User', weight: 70, height: 170, age: 25, gender: 'other');

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set(userProfile.toJson());
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
