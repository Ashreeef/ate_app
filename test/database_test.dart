import 'package:ate_app/database/database_helper.dart';

/// Test all database operations
class DatabaseTest {
  static final DatabaseHelper _db = DatabaseHelper.instance;

  /// Run all database tests
  static Future<void> runAllTests() async {
    print('\n🧪 Starting Database Tests...\n');

    try {
      await testDatabaseInfo();
      await testGenericOperations();
      await testTableSpecificOperations();
      await testBatchOperations();
      await testTransactions();

      print('\n✅ All Database Tests Passed!\n');
    } catch (e) {
      print('\n❌ Database Test Failed: $e\n');
      rethrow;
    }
  }

  /// Test database info methods
  static Future<void> testDatabaseInfo() async {
    print('📊 Testing Database Info Methods...');

    // Get database path
    final path = await _db.getDatabasePath();
    print('✓ Database path: $path');

    // Get database version
    final version = await _db.getDatabaseVersion();
    print('✓ Database version: $version');
    assert(version == 1, 'Database version should be 1');

    // Get all table names
    final tables = await _db.getTableNames();
    print('✓ Tables: ${tables.join(", ")}');
    assert(tables.contains('users'), 'Should have users table');
    assert(tables.contains('posts'), 'Should have posts table');
    assert(tables.contains('restaurants'), 'Should have restaurants table');

    // Get table info
    final userTableInfo = await _db.getTableInfo('users');
    print('✓ User table has ${userTableInfo.length} columns');

    print('✅ Database Info Tests Passed\n');
  }

  /// Test generic CRUD operations
  static Future<void> testGenericOperations() async {
    print('🔧 Testing Generic CRUD Operations...');

    // INSERT
    final userId = await _db.insert('users', {
      'username': 'testuser',
      'email': 'test@example.com',
      'password': 'password123',
      'bio': 'Test user bio',
      'points': 50,
      'level': 'Bronze',
    });
    print('✓ Inserted user with ID: $userId');
    assert(userId > 0, 'Insert should return a valid ID');

    // QUERY
    final users = await _db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
    print('✓ Queried user: ${users.first['username']}');
    assert(users.isNotEmpty, 'Query should return results');
    assert(users.first['username'] == 'testuser', 'Username should match');

    // QUERY ONE
    final user = await _db.queryOne(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
    print('✓ Queried one user: ${user!['email']}');
    assert(user['email'] == 'test@example.com', 'Email should match');

    // UPDATE
    final updatedRows = await _db.update(
      'users',
      {'points': 100, 'level': 'Silver'},
      where: 'id = ?',
      whereArgs: [userId],
    );
    print('✓ Updated $updatedRows row(s)');
    assert(updatedRows == 1, 'Should update 1 row');

    // Verify update
    final updatedUser = await _db.queryOne(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
    assert(updatedUser != null, 'User should exist after update');
    assert(updatedUser!['points'] == 100, 'Points should be updated');
    assert(updatedUser!['level'] == 'Silver', 'Level should be updated');

    // DELETE
    final deletedRows = await _db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
    print('✓ Deleted $deletedRows row(s)');
    assert(deletedRows == 1, 'Should delete 1 row');

    print('✅ Generic CRUD Tests Passed\n');
  }

  /// Test table-specific operations
  static Future<void> testTableSpecificOperations() async {
    print('📋 Testing Table-Specific Operations...');

    // Insert test data
    await _db.insert('users', {
      'username': 'user1',
      'email': 'user1@example.com',
      'password': 'pass1',
    });

    await _db.insert('users', {
      'username': 'user2',
      'email': 'user2@example.com',
      'password': 'pass2',
    });

    // GET COUNT
    final userCount = await _db.getCount('users');
    print('✓ User count: $userCount');
    assert(userCount >= 2, 'Should have at least 2 users');

    // EXISTS
    final exists = await _db.exists(
      'users',
      where: 'email = ?',
      whereArgs: ['user1@example.com'],
    );
    print('✓ User exists check: $exists');
    assert(exists == true, 'User should exist');

    final notExists = await _db.exists(
      'users',
      where: 'email = ?',
      whereArgs: ['nonexistent@example.com'],
    );
    print('✓ Non-existent user check: $notExists');
    assert(notExists == false, 'User should not exist');

    // GET LAST INSERTED ID
    final lastId = await _db.getLastInsertedId('users');
    print('✓ Last inserted ID: $lastId');

    print('✅ Table-Specific Tests Passed\n');
  }

  /// Test batch operations
  static Future<void> testBatchOperations() async {
    print('📦 Testing Batch Operations...');

    // INSERT BATCH
    final restaurants = [
      {
        'name': 'Restaurant A',
        'location': 'Location A',
        'cuisine_type': 'Italian',
        'rating': 4.5,
      },
      {
        'name': 'Restaurant B',
        'location': 'Location B',
        'cuisine_type': 'Japanese',
        'rating': 4.8,
      },
      {
        'name': 'Restaurant C',
        'location': 'Location C',
        'cuisine_type': 'French',
        'rating': 4.3,
      },
    ];

    await _db.insertBatch('restaurants', restaurants);
    print('✓ Inserted ${restaurants.length} restaurants in batch');

    final restaurantCount = await _db.getCount('restaurants');
    assert(restaurantCount >= 3, 'Should have at least 3 restaurants');

    print('✅ Batch Operation Tests Passed\n');
  }

  /// Test transaction operations
  static Future<void> testTransactions() async {
    print('🔄 Testing Transaction Operations...');

    // Create a transaction that creates a user and a post
    await _db.transaction((txn) async {
      final userId = await txn.insert('users', {
        'username': 'transactionUser',
        'email': 'transaction@example.com',
        'password': 'password',
      });

      await txn.insert('posts', {
        'user_id': userId,
        'caption': 'Test post from transaction',
        'dish_name': 'Test Dish',
        'rating': 4.5,
      });
    });

    print('✓ Transaction completed successfully');

    // Verify both records exist
    final transUser = await _db.queryOne(
      'users',
      where: 'email = ?',
      whereArgs: ['transaction@example.com'],
    );
    assert(transUser != null, 'Transaction user should exist');

    final posts = await _db.query(
      'posts',
      where: 'user_id = ?',
      whereArgs: [transUser!['id']],
    );
    assert(posts.isNotEmpty, 'Transaction post should exist');

    print('✅ Transaction Tests Passed\n');
  }

  /// Test raw SQL operations
  static Future<void> testRawSQL() async {
    print('🔍 Testing Raw SQL Operations...');

    // Raw query
    final result = await _db.rawQuery(
      'SELECT COUNT(*) as count FROM users WHERE points > ?',
      [0],
    );
    print('✓ Raw query result: ${result.first['count']}');

    // Raw insert
    final rawId = await _db.rawInsert(
      'INSERT INTO users (username, email, password) VALUES (?, ?, ?)',
      ['rawUser', 'raw@example.com', 'rawpass'],
    );
    print('✓ Raw insert ID: $rawId');
    assert(rawId > 0, 'Raw insert should return valid ID');

    // Raw update
    final rawUpdated = await _db.rawUpdate(
      'UPDATE users SET points = ? WHERE id = ?',
      [200, rawId],
    );
    print('✓ Raw update affected $rawUpdated row(s)');
    assert(rawUpdated == 1, 'Raw update should affect 1 row');

    // Raw delete
    final rawDeleted = await _db.rawDelete('DELETE FROM users WHERE id = ?', [
      rawId,
    ]);
    print('✓ Raw delete affected $rawDeleted row(s)');
    assert(rawDeleted == 1, 'Raw delete should affect 1 row');

    print('✅ Raw SQL Tests Passed\n');
  }

  /// Clean up test data
  static Future<void> cleanup() async {
    print('🧹 Cleaning up test data...');
    await _db.clearAllData();
    print('✓ All test data cleared\n');
  }

  /// Print database statistics
  static Future<void> printStats() async {
    await _db.printDatabaseStats();
  }
}
