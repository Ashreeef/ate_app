import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../services/firebase_auth_service.dart';
import '../services/firestore_service.dart';

/// Repository for authentication operations
/// Handles Firebase Auth and Firestore user data synchronization
class AuthRepository {
  final FirebaseAuthService _firebaseAuthService;
  final FirestoreService _firestoreService;

  AuthRepository({
    FirebaseAuthService? firebaseAuthService,
    FirestoreService? firestoreService,
  }) : _firebaseAuthService = firebaseAuthService ?? FirebaseAuthService(),
       _firestoreService = firestoreService ?? FirestoreService();

  /// Get current Firebase user
  firebase_auth.User? get currentFirebaseUser =>
      _firebaseAuthService.currentUser;

  /// Get current user ID
  String? get currentUserId => _firebaseAuthService.currentUserId;

  /// Check if user is authenticated
  bool get isAuthenticated => currentFirebaseUser != null;

  /// Auth state stream
  Stream<firebase_auth.User?> get authStateChanges =>
      _firebaseAuthService.authStateChanges;

  /// Sign up with email and password
  /// Creates Firebase Auth account and Firestore user document
  Future<User> signUp({
    required String username,
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      // Create Firebase Auth account
      final userCredential = await _firebaseAuthService.signUp(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw Exception('Failed to create user account');
      }

      // Create user data for Firestore
      final now = DateTime.now().toIso8601String();
      final user = User(
        uid: firebaseUser.uid,
        username: username,
        email: email,
        displayName: displayName ?? username,
        createdAt: now,
        updatedAt: now,
      );

      // Save user data to Firestore
      await _firestoreService.users
          .doc(firebaseUser.uid)
          .set(user.toFirestore(), SetOptions(merge: true));

      return user;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign in with email and password
  Future<User> signIn({required String email, required String password}) async {
    try {
      // Sign in with Firebase Auth
      final userCredential = await _firebaseAuthService.signIn(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw Exception('Failed to sign in');
      }

      // Fetch user data from Firestore
      final userDoc = await _firestoreService.users.doc(firebaseUser.uid).get();

      if (!userDoc.exists) {
        throw Exception('User data not found');
      }

      return User.fromFirestore(userDoc.data() as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _firebaseAuthService.signOut();
    } catch (e) {
      rethrow;
    }
  }

  /// Get current user data from Firestore
  Future<User?> getCurrentUser() async {
    try {
      final uid = currentUserId;
      if (uid == null) return null;

      final userDoc = await _firestoreService.users.doc(uid).get();

      if (!userDoc.exists) return null;

      return User.fromFirestore(userDoc.data() as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  /// Get user by UID
  Future<User?> getUserByUid(String uid) async {
    try {
      final userDoc = await _firestoreService.users.doc(uid).get();

      if (!userDoc.exists) return null;

      return User.fromFirestore(userDoc.data() as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  /// Get user by email
  Future<User?> getUserByEmail(String email) async {
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

  /// Check if username exists
  Future<bool> usernameExists(String username) async {
    try {
      final querySnapshot = await _firestoreService.users
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Update user profile
  Future<void> updateUserProfile(User user) async {
    try {
      final uid = user.uid ?? currentUserId;
      if (uid == null) {
        throw Exception('User not authenticated');
      }

      final updatedUser = user.copyWith(
        updatedAt: DateTime.now().toIso8601String(),
      );

      await _firestoreService.users.doc(uid).update(updatedUser.toFirestore());
    } catch (e) {
      rethrow;
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuthService.resetPassword(email);
    } catch (e) {
      rethrow;
    }
  }

  /// Update email
  Future<void> updateEmail(String newEmail) async {
    try {
      await _firebaseAuthService.updateEmail(newEmail);

      // Update email in Firestore
      final uid = currentUserId;
      if (uid != null) {
        await _firestoreService.users.doc(uid).update({
          'email': newEmail,
          'updatedAt': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Update password
  Future<void> updatePassword(String newPassword) async {
    try {
      await _firebaseAuthService.updatePassword(newPassword);
    } catch (e) {
      rethrow;
    }
  }

  /// Re-authenticate user (needed before sensitive operations)
  Future<void> reauthenticate(String email, String password) async {
    try {
      await _firebaseAuthService.reauthenticate(email, password);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete user account
  Future<void> deleteAccount() async {
    try {
      final uid = currentUserId;
      if (uid == null) {
        throw Exception('User not authenticated');
      }

      // Delete user data from Firestore
      await _firestoreService.users.doc(uid).delete();

      // Delete Firebase Auth account
      await _firebaseAuthService.deleteAccount();
    } catch (e) {
      rethrow;
    }
  }

  /// Stream user data from Firestore
  Stream<User?> getUserStream(String uid) {
    return _firestoreService.users.doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      return User.fromFirestore(snapshot.data() as Map<String, dynamic>);
    });
  }

  /// Get current user data stream
  Stream<User?> get currentUserStream {
    return authStateChanges.asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      return await getUserByUid(firebaseUser.uid);
    });
  }
}
