import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

/// Streams the current user - null when signed out. The UI watches
/// this to decide whether to show the login screen or the app itself.
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges().map((user) {
    debugPrint(
        '[AUTH] authStateChanges emitted: ${user?.email ?? "null (signed out)"}');
    return user;
  });
});

class AuthService {
  AuthService(this._auth);
  final FirebaseAuth _auth;

  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return null; // null means success
    } on FirebaseAuthException catch (e) {
      return _friendlyMessage(e);
    }
  }

  Future<String?> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return _friendlyMessage(e);
    }
  }

  Future<void> signOut() => _auth.signOut();

  String _friendlyMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with that email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account already exists with that email.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      case 'invalid-email':
        return 'That email address looks invalid.';
      default:
        return e.message ?? 'Something went wrong. Please try again.';
    }
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.watch(firebaseAuthProvider));
});
