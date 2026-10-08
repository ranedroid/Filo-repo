import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../onboarding/models.dart';

/// Repository responsible for reading and persisting lightweight
/// user account documents from Cloud Firestore at `users/{uid}`.
///
/// Features lazy initialization so widget tests and offline runs
/// do not crash if Firebase hasn't been initialized yet.
class UserRepository {
  FirebaseFirestore? firestore;

  UserRepository({this.firestore});

  FirebaseFirestore? get _safeFirestore {
    if (firestore != null) return firestore;
    try {
      return firestore = FirebaseFirestore.instance;
    } catch (e) {
      debugPrint('UserRepository notice: Firebase not initialized ($e)');
      return null;
    }
  }

  CollectionReference<Map<String, dynamic>>? get _usersCollection =>
      _safeFirestore?.collection('users');

  /// Fetch a user's profile document by their Firebase UID.
  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final collection = _usersCollection;
      if (collection == null) return null;
      final doc = await collection.doc(uid).get();
      if (!doc.exists || doc.data() == null) {
        return null;
      }
      return UserProfile.fromMap(doc.data()!, documentId: doc.id);
    } catch (e) {
      debugPrint('UserRepository.getUserProfile notice: $e');
      return null;
    }
  }

  /// Create or update the user's profile document in Firestore.
  Future<void> saveUserProfile(UserProfile profile) async {
    try {
      final collection = _usersCollection;
      if (collection == null) return;
      await collection.doc(profile.id).set(
            profile.toMap(),
            SetOptions(merge: true),
          );
    } catch (e) {
      debugPrint('UserRepository.saveUserProfile notice: $e');
      rethrow;
    }
  }

  /// Listen to real-time changes to a user's profile.
  Stream<UserProfile?> watchUserProfile(String uid) {
    final collection = _usersCollection;
    if (collection == null) return const Stream.empty();
    return collection.doc(uid).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) {
        return null;
      }
      return UserProfile.fromMap(doc.data()!, documentId: doc.id);
    });
  }
}
