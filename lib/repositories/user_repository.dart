import '../models/user.dart';
import '../database/database_helper.dart';
import '../utils/password_helper.dart';
import '../services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Repository for user data operations
/// Supports both local SQLite (legacy) and Firestore (current)
class UserRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
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

  /// Search users by username or display name (Firestore)
  Future<List<User>> searchUsersFirestore(String query) async {
    try {
      if (query.trim().isEmpty) {
        return getAllUsersFirestore();
      }

      final searchTerm = query.toLowerCase().trim();

      // Efficient prefix-based search using searchKeywords array
      final querySnapshot = await _firestoreService.users
          .where('searchKeywords', arrayContains: searchTerm)
          .limit(20)
          .get();

      return querySnapshot.docs
          .map((doc) => User.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
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

  // ============= LOCAL DATABASE OPERATIONS (LEGACY) =============
  // Keep these for backward compatibility during migration

  /// Get user by ID (Local SQLite - Deprecated)
  /// Get user by ID (Local SQLite - Deprecated)
  @Deprecated('Use getUserByUid for Firebase')
  Future<User?> getUserById(String id) async {
    final db = await _databaseHelper.database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);

    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  /// Get user by email (Local SQLite - Deprecated)
  @Deprecated('Use getUserByEmailFirestore for Firebase')
  Future<User?> getUserByEmail(String email) async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  /// Create new user (Local SQLite - Deprecated)
  @Deprecated('Use setUserFirestore for Firebase')
  Future<void> createUser(User user) async {
    final db = await _databaseHelper.database;
    await db.insert('users', user.toMap());
  }

  /// Update user (Local SQLite - Deprecated)
  @Deprecated('Use updateUserFirestore for Firebase')
  Future<void> updateUser(User user) async {
    final db = await _databaseHelper.database;
    await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  /// Delete user (Local SQLite - Deprecated)
  @Deprecated('Use deleteUserFirestore for Firebase')
  Future<void> deleteUser(String id) async {
    final db = await _databaseHelper.database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  /// Check if email exists (Local SQLite - Deprecated)
  @Deprecated('Use getUserByEmailFirestore for Firebase')
  Future<bool> emailExists(String email) async {
    final user = await getUserByEmail(email);
    return user != null;
  }

  /// Authenticate user (Local SQLite - Deprecated)
  @Deprecated('Use AuthRepository.signIn for Firebase')
  Future<User?> authenticate(String email, String password) async {
    final db = await _databaseHelper.database;

    // Get user by email first
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isEmpty) return null;

    final user = User.fromMap(maps.first);

    // Verify password using secure comparison
    if (user.password != null &&
        PasswordHelper.verifyPassword(password, user.password!)) {
      return user;
    }

    return null;
  }

  /// Get all users (Local SQLite - Deprecated)
  @Deprecated('Use getAllUsersFirestore for Firebase')
  Future<List<User>> getAllUsers() async {
    final db = await _databaseHelper.database;
    final maps = await db.query('users', orderBy: 'created_at DESC');
    return maps.map((map) => User.fromMap(map)).toList();
  }

  /// Search users by username (Local SQLite - Deprecated)
  @Deprecated('Use searchUsersFirestore for Firebase')
  Future<List<User>> searchUsers(String query) async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      'users',
      where: 'username LIKE ?',
      whereArgs: ['%$query%'],
    );
    return maps.map((map) => User.fromMap(map)).toList();
  }
}
