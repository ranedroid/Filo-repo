import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Service responsible for managing Firebase Authentication,
/// specifically Google Sign-In and session lifecycle.
///
/// Features lazy initialization so widget tests and offline runs
/// do not crash if Firebase hasn't been initialized yet.
class AuthService {
  FirebaseAuth? auth;
  final GoogleSignIn _googleSignIn;

  AuthService({
    this.auth,
    GoogleSignIn? googleSignIn,
  }) : _googleSignIn = googleSignIn ??
            GoogleSignIn(
              // Required for web: your OAuth 2.0 Web Client ID from
              // Firebase Console -> Authentication -> Sign-in method -> Google
              // -> Web SDK configuration -> Web client ID
              clientId: kIsWeb
                  ? '310049809996-YOUR_WEB_CLIENT_ID.apps.googleusercontent.com'
                  : null,
              scopes: ['email', 'profile'],
            );

  FirebaseAuth? get _safeAuth {
    if (auth != null) return auth;
    try {
      return auth = FirebaseAuth.instance;
    } catch (e) {
      debugPrint('AuthService notice: Firebase not initialized ($e)');
      return null;
    }
  }

  /// Stream of user authentication state changes.
  Stream<User?> get authStateChanges =>
      _safeAuth?.authStateChanges() ?? const Stream.empty();

  /// Currently logged in Firebase user, if any.
  User? get currentUser => _safeAuth?.currentUser;

  /// Whether a Firebase app is initialized and ready.
  bool get isAvailable => _safeAuth != null;

  /// Trigger Google Sign-In and authenticate with Firebase.
  /// Returns the authenticated [UserCredential], or null if the user canceled.
  /// Throws [AuthException] on sign-in failure.
  Future<UserCredential?> signInWithGoogle() async {
    final auth = _safeAuth;
    if (auth == null) {
      throw AuthException(
        'Firebase is not initialized. Please connect to your Firebase project first.',
      );
    }

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User dismissed the Google account picker
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await auth.signInWithCredential(credential);
    } on AuthException {
      rethrow;
    } catch (e) {
      debugPrint('AuthService.signInWithGoogle error: $e');
      throw AuthException(_friendlyMessage(e));
    }
  }

  /// Sign out the current user from both Firebase and Google.
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      debugPrint('GoogleSignIn.signOut notice: $e');
    }
    try {
      await _safeAuth?.signOut();
    } catch (e) {
      debugPrint('FirebaseAuth.signOut notice: $e');
    }
  }

  String _friendlyMessage(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('network')) {
      return 'No internet connection. Please check your network and try again.';
    }
    if (msg.contains('popup') || msg.contains('cancelled')) {
      return 'Sign-in was cancelled. Please try again.';
    }
    if (msg.contains('account-exists')) {
      return 'An account already exists with that email using a different sign-in method.';
    }
    return 'Sign-in failed. Please try again.';
  }
}

/// Typed exception for auth-related errors with user-readable messages.
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}
