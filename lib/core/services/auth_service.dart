import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  bool get isAuthenticated => _auth.currentUser != null;

  /// Ensures an anonymous user session is established without prompting the user.
  /// If a session already exists, it is safely reused.
  Future<User?> ensureAuthenticated() async {
    try {
      final existingUser = _auth.currentUser;
      if (existingUser != null) {
        debugPrint('AuthService: Reusing existing anonymous session (UID: ${existingUser.uid}).');
        return existingUser;
      }

      debugPrint('AuthService: Establishing new guest session via signInAnonymously()...');
      final userCredential = await _auth.signInAnonymously();
      debugPrint('AuthService: Anonymous sign-in established (UID: ${userCredential.user?.uid}).');
      return userCredential.user;
    } catch (e) {
      debugPrint('AuthService: Anonymous authentication error: $e');
      return null;
    }
  }
}

