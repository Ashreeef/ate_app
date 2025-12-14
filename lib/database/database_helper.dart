import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  // Singleton instance getter
  static DatabaseHelper get instance => _instance;

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('ate_app.db');
    return _db!;
  }

  /// Initialize database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 4, // Incremented for notifications table
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: (db) async {
        // Keep foreign key constraints
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  /// Handle database upgrades/migrations
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add columns that may be missing in older DB versions
      try {
        await db.execute('ALTER TABLE users ADD COLUMN display_name TEXT');
      } catch (_) {}
      try {
        await db.execute('ALTER TABLE users ADD COLUMN phone TEXT');
      } catch (_) {}
    }
    if (oldVersion < 3) {
      // Add followers and following counts
      try {
        await db.execute(
          'ALTER TABLE users ADD COLUMN followers_count INTEGER DEFAULT 0',
        );
      } catch (_) {}
      try {
        await db.execute(
          'ALTER TABLE users ADD COLUMN following_count INTEGER DEFAULT 0',
        );
      } catch (_) {}
    }
  }

  Future _onCreate(Database db, int version) async {
    // Create users table with ALL fields from both branches
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        email TEXT NOT NULL UNIQUE,
        password TEXT,
        profile_image TEXT,
        bio TEXT,
        display_name TEXT,
        phone TEXT,
        followers_count INTEGER DEFAULT 0,
        following_count INTEGER DEFAULT 0,
        points INTEGER DEFAULT 0,
        level TEXT DEFAULT 'Bronze',
        created_at TEXT
      )
    ''');

    // Create restaurants table
    await db.execute('''
      CREATE TABLE restaurants (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        location TEXT,
        cuisine_type TEXT,
        rating REAL DEFAULT 0.0,
        image_url TEXT,
        posts_count INTEGER DEFAULT 0,
        created_at TEXT
      )
    ''');

    // Create posts table
    await db.execute('''
      CREATE TABLE posts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        username TEXT NOT NULL,
        user_avatar_path TEXT,
        caption TEXT NOT NULL,
        restaurant_id INTEGER,
        restaurant_name TEXT,
        dish_name TEXT,
        rating REAL,
        images TEXT,
        likes_count INTEGER DEFAULT 0,
        comments_count INTEGER DEFAULT 0,
        liked_by TEXT,
        saved_by TEXT,
        created_at TEXT,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE SET NULL
      )
    ''');

    // Create comments table
    await db.execute('''
      CREATE TABLE comments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        post_id INTEGER NOT NULL,
        user_id INTEGER NOT NULL,
        content TEXT NOT NULL,
        created_at TEXT,
        FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    // Create likes table
    await db.execute('''
      CREATE TABLE likes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        post_id INTEGER NOT NULL,
        created_at TEXT,
        UNIQUE(user_id, post_id),
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE
      )
    ''');

    // Create saved_posts table
    await db.execute('''
      CREATE TABLE saved_posts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        post_id INTEGER NOT NULL,
        created_at TEXT,
        UNIQUE(user_id, post_id),
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE
      )
    ''');

    // Create search_history table
    await db.execute('''
      CREATE TABLE search_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        query TEXT NOT NULL,
        created_at TEXT,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    // Create notifications table
    await db.execute('''
      CREATE TABLE notifications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        image_url TEXT,
        data TEXT,
        created_at TEXT,
        is_read INTEGER DEFAULT 0,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');
  }

  /// Close database connection
  Future<void> close() async {
    final db = await database;
    await db.close();
    _db = null;
  }

  /// Delete database (for testing/reset)
  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'ate_app.db');
    await databaseFactory.deleteDatabase(path);
    _db = null;
  }

  /// Clear all data (for testing)
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('notifications');
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
    return _db!.batch();
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
