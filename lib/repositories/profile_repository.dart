import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../services/firestore_service.dart';
import '../models/user.dart';

/// Repository for user profile database operations using Firestore
class ProfileRepository {
  final FirestoreService _firestoreService = FirestoreService();
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  /// Get the current logged-in user from Firestore
  Future<User?> getCurrentUser() async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) return null;

      final doc = await _firestoreService.users.doc(currentUser.uid).get();
      if (!doc.exists) return null;

      return User.fromFirestore(doc.data() as Map<String, dynamic>);
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  /// Fetch user by UID from Firestore (for viewing other profiles)
  Future<User?> getUserByUid(String uid) async {
    try {
      final doc = await _firestoreService.users.doc(uid).get();
      if (!doc.exists) return null;

      return User.fromFirestore(doc.data() as Map<String, dynamic>);
    } catch (e) {
      print('Error getting user by uid: $e');
      return null;
    }
  }

  /// Fetch multiple users by their UIDs
  Future<List<User>> getUsersByUids(List<String> uids) async {
    if (uids.isEmpty) return [];
    try {
      // Split into chunks of 10 because whereIn has a limit of 10/30 depending on version
      // In web/older versions it's 10, in newer cloud_firestore it's 30. Using 10 to be safe.
      final List<User> allUsers = [];
      for (var i = 0; i < uids.length; i += 10) {
        final chunk = uids.sublist(
          i,
          i + 10 > uids.length ? uids.length : i + 10,
        );
        final querySnapshot = await _firestoreService.users
            .where('uid', whereIn: chunk)
            .get();

        final users = querySnapshot.docs
            .map((doc) => User.fromFirestore(doc.data() as Map<String, dynamic>))
            .toList();
        allUsers.addAll(users);
      }
      return allUsers;
    } catch (e) {
      print('Error getting users by uids: $e');
      return [];
    }
  }

  /// Update existing user profile
  Future<void> updateUser(User user) async {
    try {
      if (user.uid == null) {
        throw Exception('User UID is required for update');
      }

      await _firestoreService.users.doc(user.uid).update(user.toFirestore());
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  /// Delete user from Firestore
  Future<void> deleteUser(String uid) async {
    try {
      await _firestoreService.users.doc(uid).delete();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  // ==================== BACKWARD COMPATIBILITY ====================
  // Keeping method signature for integer ID but warning about usage

  /// Get user by ID (Legacy int ID) - Deprecated
  @Deprecated('Use getUserByUid with String UID instead')
  Future<User?> getUserById(int id) async {
    // This is a compatibility shim. Integer IDs map to nothing in Firestore.
    // If you need to find a user by their legacy "id" field (if migrated),
    // you would need a query.
    return null;
  }
}
