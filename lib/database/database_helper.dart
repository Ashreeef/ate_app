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

    return await openDatabase(path, version: 1, onCreate: _createDB);
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
}
