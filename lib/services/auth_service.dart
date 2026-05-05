import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Web client ID for Google Sign-In
  static const webClientId =
      '117362213204-9uqsi5i9dj8h4a14tdkcoiq0bruhegq0.apps.googleusercontent.com';

  // Track whether GoogleSignIn has been initialized
  static bool _googleSignInInitialized = false;

  // Initialize GoogleSignIn — call once at app startup
  static Future<void> initGoogleSignIn() async {
    if (_googleSignInInitialized) return;
    if (kIsWeb) {
      await GoogleSignIn.instance.initialize(
        clientId: webClientId,
      );
    } else {
      await GoogleSignIn.instance.initialize(
        serverClientId: webClientId,
      );
    }
    _googleSignInInitialized = true;
  }

  // Current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email & password
  Future<UserCredential> signInWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  // Sign up with email & password
  Future<UserCredential> signUpWithEmail(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  // Sign in with Google — for mobile (Android/iOS) only
  // On Web, use GoogleSignInButton widget instead
  Future<UserCredential> signInWithGoogle() async {
    try {
      await initGoogleSignIn();

      final GoogleSignInAccount googleUser =
          await GoogleSignIn.instance.authenticate();

      final String? idToken = googleUser.authentication.idToken;

      if (idToken == null) {
        throw AuthException(
          code: 'missing-id-token',
          msg: 'ไม่สามารถรับ Token จาก Google ได้',
        );
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        code: e.code,
        msg: 'Firebase Auth error: ${e.message}',
      );
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(
        code: 'google-sign-in-failed',
        msg: 'Google Sign-In ล้มเหลว: $e',
      );
    }
  }

  // Sign in with Google credential (used by web renderButton callback)
  Future<UserCredential> signInWithGoogleCredential(String idToken) async {
    final credential = GoogleAuthProvider.credential(idToken: idToken);
    return await _auth.signInWithCredential(credential);
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

/// Custom exception to avoid name clash with FirebaseAuthException
class AuthException implements Exception {
  final String code;
  final String msg;

  AuthException({required this.code, required this.msg});

  @override
  String toString() => msg;
}
