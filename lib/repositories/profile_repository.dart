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

    final currentId = prefs.getInt(_kCurrentUserIdKey);
    print(' Current user ID from prefs: $currentId');

    if (currentId != null) {
      final maps = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [currentId],
        limit: 1,
      );
      print(' Query result for ID $currentId: ${maps.length} rows');
      if (maps.isNotEmpty) {
        print('Found user data: ${maps.first}');
        return User.fromMap(maps.first);
      }
      // fallthrough to first user if stored id missing
    }

    final maps = await db.query('users', limit: 1);
    print(' Query all users: ${maps.length} rows');
    if (maps.isNotEmpty) {
      print(' First user data: ${maps.first}');
    }
    if (maps.isEmpty) return null;
    final user = User.fromMap(maps.first);
    // save id for future
    await setCurrentUserId(user.id);
    return user;
  }

  /// Fetch user by ID from database (for viewing other profiles)
  Future<User?> getUserById(int id) async {
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

    // If ID 2 is not found, get the second user from the database
    if (id == 2) {
      print(' User ID 2 not found, fetching second user...');
      final allUsers = await db.query('users', orderBy: 'id');
      if (allUsers.length > 1) {
        return User.fromMap(allUsers[1]);
      }
    }

    return null;
  }

  Future<int> createUser(User user) async {
    final db = await _dbHelper.database;
    final id = await db.insert('users', user.toMap());
    await setCurrentUserId(id);
    return id;
  }

  /// Update existing user or create if doesn't exist
  Future<int> updateUser(User user) async {
    final db = await _dbHelper.database;
    if (user.id == null) {
      return await createUser(user);
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
    final currentId = prefs.getInt(_kCurrentUserIdKey);
    if (currentId == user.id) {
      await setCurrentUserId(user.id);
    }

    return count;
  }

  Future<void> deleteUser(int id) async {
    final db = await _dbHelper.database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
    final prefs = await SharedPreferences.getInstance();
    final currentId = prefs.getInt(_kCurrentUserIdKey);
    if (currentId == id) {
      await prefs.remove(_kCurrentUserIdKey);
    }
  }

  Future<void> setCurrentUserId(int? id) async {
    final prefs = await SharedPreferences.getInstance();
    if (id == null) {
      await prefs.remove(_kCurrentUserIdKey);
    } else {
      await prefs.setInt(_kCurrentUserIdKey, id);
    }
  }
}
