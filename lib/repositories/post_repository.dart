import '../database/database_helper.dart';
import '../models/post.dart';

class PostRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Get all posts by a specific user
  Future<List<Post>> getPostsByUserId(int userId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'posts',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => Post.fromMap(map)).toList();
  }

  /// Get a single post by ID
  Future<Post?> getPostById(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'posts',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return Post.fromMap(maps.first);
  }

  /// Create a new post
  Future<int> createPost(Post post) async {
    final db = await _dbHelper.database;
    return await db.insert('posts', post.toMap());
  }

  /// Update an existing post
  Future<int> updatePost(Post post) async {
    final db = await _dbHelper.database;
    if (post.id == null) {
      return await createPost(post);
    }
    return await db.update(
      'posts',
      post.toMap(),
      where: 'id = ?',
      whereArgs: [post.id],
    );
  }

  /// Delete a post
  Future<void> deletePost(int id) async {
    final db = await _dbHelper.database;
    await db.delete('posts', where: 'id = ?', whereArgs: [id]);
  }

  /// Get all posts 
  Future<List<Post>> getAllPosts({int? limit, int? offset}) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'posts',
      orderBy: 'created_at DESC',
      limit: limit,
      offset: offset,
    );
    return maps.map((map) => Post.fromMap(map)).toList();
  }

  /// Get posts count for a user
  Future<int> getPostsCountByUserId(int userId) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM posts WHERE user_id = ?',
      [userId],
    );
    return result.first['count'] as int? ?? 0;
  }
}
