import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Database helper class for managing SQLite database operations
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  /// Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('ate_app.db');
    return _database!;
  }

  /// Initialize database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Initialize the database factory
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: (db) async {
        // Enable foreign key constraints
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  /// Create database tables
  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const realType = 'REAL';

    // Users table
    await db.execute('''
      CREATE TABLE users (
        id $idType,
        username $textType,
        email $textType UNIQUE,
        password $textType,
        profile_image TEXT,
        bio TEXT,
        points INTEGER DEFAULT 0,
        level TEXT DEFAULT 'Bronze',
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Posts table
    await db.execute('''
      CREATE TABLE posts (
        id $idType,
        user_id $integerType,
        caption TEXT,
        restaurant_id INTEGER,
        dish_name TEXT,
        rating $realType,
        images TEXT,
        likes_count INTEGER DEFAULT 0,
        comments_count INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (restaurant_id) REFERENCES restaurants (id) ON DELETE SET NULL
      )
    ''');

    // Restaurants table
    await db.execute('''
      CREATE TABLE restaurants (
        id $idType,
        name $textType,
        location TEXT,
        cuisine_type TEXT,
        rating $realType DEFAULT 0.0,
        image_url TEXT,
        posts_count INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Likes table
    await db.execute('''
      CREATE TABLE likes (
        id $idType,
        user_id $integerType,
        post_id $integerType,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE CASCADE,
        UNIQUE(user_id, post_id)
      )
    ''');

    // Comments table
    await db.execute('''
      CREATE TABLE comments (
        id $idType,
        post_id $integerType,
        user_id $integerType,
        content $textType,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE CASCADE,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Saved posts table
    await db.execute('''
      CREATE TABLE saved_posts (
        id $idType,
        user_id $integerType,
        post_id $integerType,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE CASCADE,
        UNIQUE(user_id, post_id)
      )
    ''');

    // Search history table
    await db.execute('''
      CREATE TABLE search_history (
        id $idType,
        user_id $integerType,
        query $textType,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
  }

  /// Close database connection
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  /// Delete database (for testing/reset)
  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'ate_app.db');
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }

  /// Clear all data (for testing)
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('saved_posts');
    await db.delete('comments');
    await db.delete('likes');
    await db.delete('posts');
    await db.delete('restaurants');
    await db.delete('search_history');
    await db.delete('users');
  }

  // ==================== GENERIC CRUD OPERATIONS ====================

  /// Insert a record into a table
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Insert multiple records into a table
  Future<void> insertBatch(
    String table,
    List<Map<String, dynamic>> dataList,
  ) async {
    final db = await database;
    final batch = db.batch();
    for (var data in dataList) {
      batch.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  /// Query records from a table
  Future<List<Map<String, dynamic>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<dynamic>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    return await db.query(
      table,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  /// Query a single record from a table
  Future<Map<String, dynamic>?> queryOne(
    String table, {
    List<String>? columns,
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final results = await query(
      table,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// Update records in a table
  Future<int> update(
    String table,
    Map<String, dynamic> data, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    return await db.update(table, data, where: where, whereArgs: whereArgs);
  }

  /// Delete records from a table
  Future<int> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  /// Execute raw SQL query
  Future<List<Map<String, dynamic>>> rawQuery(
    String sql, [
    List<dynamic>? arguments,
  ]) async {
    final db = await database;
    return await db.rawQuery(sql, arguments);
  }

  /// Execute raw SQL statement
  Future<int> rawInsert(String sql, [List<dynamic>? arguments]) async {
    final db = await database;
    return await db.rawInsert(sql, arguments);
  }

  /// Execute raw SQL update
  Future<int> rawUpdate(String sql, [List<dynamic>? arguments]) async {
    final db = await database;
    return await db.rawUpdate(sql, arguments);
  }

  /// Execute raw SQL delete
  Future<int> rawDelete(String sql, [List<dynamic>? arguments]) async {
    final db = await database;
    return await db.rawDelete(sql, arguments);
  }

  // ==================== BATCH OPERATIONS ====================

  /// Execute multiple operations in a transaction
  Future<void> transaction(
    Future<void> Function(Transaction txn) action,
  ) async {
    final db = await database;
    await db.transaction(action);
  }

  /// Create a batch for multiple operations
  Batch batch() {
    return _database!.batch();
  }

  /// Commit a batch operation
  Future<List<Object?>> commitBatch(Batch batch) async {
    return await batch.commit();
  }

  // ==================== TABLE-SPECIFIC OPERATIONS ====================

  /// Get record count from a table
  Future<int> getCount(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $table${where != null ? ' WHERE $where' : ''}',
      whereArgs,
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Check if a record exists
  Future<bool> exists(
    String table, {
    required String where,
    required List<dynamic> whereArgs,
  }) async {
    final count = await getCount(table, where: where, whereArgs: whereArgs);
    return count > 0;
  }

  /// Get the last inserted row ID
  Future<int?> getLastInsertedId(String table) async {
    final db = await database;
    final result = await db.rawQuery('SELECT last_insert_rowid() as id');
    return Sqflite.firstIntValue(result);
  }

  // ==================== DATABASE INFO ====================

  /// Get database path
  Future<String> getDatabasePath() async {
    final dbPath = await getDatabasesPath();
    return join(dbPath, 'ate_app.db');
  }

  /// Get database version
  Future<int> getDatabaseVersion() async {
    final db = await database;
    return await db.getVersion();
  }

  /// Get all table names
  Future<List<String>> getTableNames() async {
    final db = await database;
    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'",
    );
    return result.map((row) => row['name'] as String).toList();
  }

  /// Get table info (columns, types, etc.)
  Future<List<Map<String, dynamic>>> getTableInfo(String tableName) async {
    final db = await database;
    return await db.rawQuery('PRAGMA table_info($tableName)');
  }

  // ==================== DEBUGGING ====================

  /// Print all records from a table (for debugging)
  Future<void> printTable(String table) async {
    final records = await query(table);
    print('========== $table (${records.length} records) ==========');
    for (var record in records) {
      print(record);
    }
    print('=' * 50);
  }

  /// Print database statistics
  Future<void> printDatabaseStats() async {
    print('========== DATABASE STATISTICS ==========');
    print('Database path: ${await getDatabasePath()}');
    print('Database version: ${await getDatabaseVersion()}');
    print('Users: ${await getCount('users')}');
    print('Posts: ${await getCount('posts')}');
    print('Restaurants: ${await getCount('restaurants')}');
    print('Likes: ${await getCount('likes')}');
    print('Comments: ${await getCount('comments')}');
    print('Saved Posts: ${await getCount('saved_posts')}');
    print('Search History: ${await getCount('search_history')}');
    print('=' * 40);
  }
}
