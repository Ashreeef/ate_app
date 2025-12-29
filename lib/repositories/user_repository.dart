import '../models/user.dart';
import '../services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Repository for user data operations using Firestore
class UserRepository {
  final FirestoreService _firestoreService = FirestoreService();

  // ============= FIRESTORE OPERATIONS (CURRENT) =============

  /// Get user by UID (Firebase)
  Future<User?> getUserByUid(String uid) async {
    try {
      final doc = await _firestoreService.users.doc(uid).get();
      if (!doc.exists) return null;
      return User.fromFirestore(doc.data() as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  /// Get user by email (Firestore)
  Future<User?> getUserByEmailFirestore(String email) async {
    try {
      final querySnapshot = await _firestoreService.users
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return null;

      return User.fromFirestore(
        querySnapshot.docs.first.data() as Map<String, dynamic>,
      );
    } catch (e) {
      return null;
    }
  }

  /// Update user in Firestore
  Future<void> updateUserFirestore(User user) async {
    try {
      if (user.uid == null) {
        throw Exception('User UID is required for Firestore update');
      }

      final updatedUser = user.copyWith(
        updatedAt: DateTime.now().toIso8601String(),
      );

      await _firestoreService.users
          .doc(user.uid)
          .update(updatedUser.toFirestore());
    } catch (e) {
      rethrow;
    }
  }

  /// Create or update user in Firestore
  Future<void> setUserFirestore(User user) async {
    try {
      if (user.uid == null) {
        throw Exception('User UID is required for Firestore operation');
      }

      final now = DateTime.now().toIso8601String();
      final userData = user.copyWith(
        createdAt: user.createdAt ?? now,
        updatedAt: now,
      );

      await _firestoreService.users
          .doc(user.uid)
          .set(userData.toFirestore(), SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  /// Delete user from Firestore
  Future<void> deleteUserFirestore(String uid) async {
    try {
      await _firestoreService.users.doc(uid).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Get all users from Firestore
  Future<List<User>> getAllUsersFirestore() async {
    try {
      final querySnapshot = await _firestoreService.users
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => User.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Search users by username (Firestore)
  Future<List<User>> searchUsersFirestore(String query) async {
    try {
      // Firestore doesn't support case-insensitive LIKE queries
      // We'll fetch all users and filter client-side (consider using Algolia for production)
      final querySnapshot = await _firestoreService.users.get();

      final users = querySnapshot.docs
          .map((doc) => User.fromFirestore(doc.data() as Map<String, dynamic>))
          .where(
            (user) => user.username.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();

      return users;
    } catch (e) {
      return [];
    }
  }

  /// Stream user data from Firestore
  Stream<User?> getUserStreamFirestore(String uid) {
    return _firestoreService.users.doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      return User.fromFirestore(snapshot.data() as Map<String, dynamic>);
    });
  }
}
