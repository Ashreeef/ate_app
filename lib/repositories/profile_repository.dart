import 'package:shared_preferences/shared_preferences.dart';

import '../database/database_helper.dart';
import '../models/user.dart';

/// Repository for user profile database operations
class ProfileRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  static const _kCurrentUserIdKey = 'current_user_id';

  /// Get the current logged-in user from stored preferences or first user
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final db = await _dbHelper.database;

    final currentId = prefs.getString(_kCurrentUserIdKey);

    if (currentId != null) {
      final maps = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [currentId],
        limit: 1,
      );
      if (maps.isNotEmpty) {
        return User.fromMap(maps.first);
      }
      // fallthrough to first user if stored id missing
    }

    final maps = await db.query('users', limit: 1);
    if (maps.isEmpty) return null;
    final user = User.fromMap(maps.first);
    // save id for future
    await setCurrentUserId(user.id);
    return user;
  }

  /// Fetch user by ID from database (for viewing other profiles)
  Future<User?> getUserById(String id) async {
    final db = await _dbHelper.database;

    // First try to get the user by exact ID
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }

    // Fallback logic could be added here if needed, but "id 2" logic is int-specific and likely obsolete
    return null;
  }

  /// Alias for getUserById to support callers using "uid" terminology
  Future<User?> getUserByUid(String uid) => getUserById(uid);

  Future<String> createUser(User user) async {
    final db = await _dbHelper.database;
    await db.insert('users', user.toMap());
    // In legacy SQLite flow, ID might be generated, but for compatibility we expect ID to be present or handled by DB
    // Since we are moving to String IDs (UUID/Auth ID), user.id should be set.
    // If user.id is null, we can't easily return a generated String ID from SQLite unless we query it back.
    // For now, assume user.id is set.
    final id = user.id ?? user.uid ?? ''; 
    await setCurrentUserId(id);
    return id;
  }

  /// Update existing user or create if doesn't exist
  Future<int> updateUser(User user) async {
    final db = await _dbHelper.database;
    if (user.id == null) {
       await createUser(user);
       return 1;
    }

    print('Updating user: ID ${user.id}, username: ${user.username}');
    print('   Display name: ${user.displayName}');
    print('   Bio: ${user.bio}');
    print('   Phone: ${user.phone}');
    print('   Map being saved: ${user.toMap()}');

    final count = await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );

    print(' Updated $count rows');

    // Verify the update by reading back
    final updated = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [user.id],
      limit: 1,
    );
    if (updated.isNotEmpty) {
      print('✓ Verification - User in DB: ${updated.first}');
    }

    // Don't change current_user_id when updating other users
    // Only update if this is the current user
    final prefs = await SharedPreferences.getInstance();
    final currentId = prefs.getString(_kCurrentUserIdKey);
    if (currentId == user.id) {
      await setCurrentUserId(user.id);
    }

    return count;
  }

  Future<void> deleteUser(String id) async {
    final db = await _dbHelper.database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
    final prefs = await SharedPreferences.getInstance();
    final currentId = prefs.getString(_kCurrentUserIdKey);
    if (currentId == id) {
      await prefs.remove(_kCurrentUserIdKey);
    }
  }

  Future<void> setCurrentUserId(String? id) async {
    final prefs = await SharedPreferences.getInstance();
    if (id == null) {
      await prefs.remove(_kCurrentUserIdKey);
    } else {
      await prefs.setString(_kCurrentUserIdKey, id);
    }
  }
}
