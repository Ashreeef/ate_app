import 'package:shared_preferences/shared_preferences.dart';

import '../database/database_helper.dart';
import '../models/user.dart';

class ProfileRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  static const _kCurrentUserIdKey = 'current_user_id';

  /// Get the current user (by stored id) or the first one if no id is stored.
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final db = await _dbHelper.database;

    final currentId = prefs.getInt(_kCurrentUserIdKey);
    if (currentId != null) {
      final maps = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [currentId],
        limit: 1,
      );
      if (maps.isNotEmpty) return User.fromMap(maps.first);
      // fallthrough to first user if stored id missing
    }

    final maps = await db.query('users', limit: 1);
    if (maps.isEmpty) return null;
    final user = User.fromMap(maps.first);
    // save id for future
    await setCurrentUserId(user.id);
    return user;
  }

  Future<User?> getUserById(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  Future<int> createUser(User user) async {
    final db = await _dbHelper.database;
    final id = await db.insert('users', user.toMap());
    await setCurrentUserId(id);
    return id;
  }

  Future<int> updateUser(User user) async {
    final db = await _dbHelper.database;
    if (user.id == null) {
      return await createUser(user);
    }
    final count = await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
    await setCurrentUserId(user.id);
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
