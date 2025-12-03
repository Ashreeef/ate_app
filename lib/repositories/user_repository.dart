import '../models/user.dart';
import '../database/database_helper.dart';

/// Repository for user data operations
class UserRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  /// Get user by ID
  Future<User?> getUserById(int id) async {
    final db = await _databaseHelper.database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);

    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  /// Get user by email
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

  /// Create new user
  Future<int> createUser(User user) async {
    final db = await _databaseHelper.database;
    return await db.insert('users', user.toMap());
  }

  /// Update user
  Future<int> updateUser(User user) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  /// Delete user
  Future<int> deleteUser(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  /// Check if email exists
  Future<bool> emailExists(String email) async {
    final user = await getUserByEmail(email);
    return user != null;
  }

  /// Authenticate user (login)
  Future<User?> authenticate(String email, String password) async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  /// Get all users
  Future<List<User>> getAllUsers() async {
    final db = await _databaseHelper.database;
    final maps = await db.query('users', orderBy: 'created_at DESC');
    return maps.map((map) => User.fromMap(map)).toList();
  }

  /// Search users by username
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
