import '../database/database_helper.dart';
import '../models/post.dart';

/// Repository for Post data operations
class PostRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  // ==================== CREATE ====================

  /// Create a new post
  Future<int> createPost(Post post) async {
    return await _db.insert('posts', post.toMap());
  }

  /// Create multiple posts in batch
  Future<void> createPosts(List<Post> posts) async {
    final maps = posts.map((post) => post.toMap()).toList();
    await _db.insertBatch('posts', maps);
  }

  // ==================== READ ====================

  /// Get a post by ID
  Future<Post?> getPostById(int id) async {
    final map = await _db.queryOne('posts', where: 'id = ?', whereArgs: [id]);
    return map != null ? Post.fromMap(map) : null;
  }

  /// Get all posts
  Future<List<Post>> getAllPosts({
    String? orderBy = 'created_at DESC',
    int? limit,
  }) async {
    final maps = await _db.query('posts', orderBy: orderBy, limit: limit);
    return maps.map((map) => Post.fromMap(map)).toList();
  }

  /// Get posts by user ID
  Future<List<Post>> getPostsByUserId(int userId, {int? limit}) async {
    final maps = await _db.query(
      'posts',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
      limit: limit,
    );
    return maps.map((map) => Post.fromMap(map)).toList();
  }

  /// Get posts by restaurant ID
  Future<List<Post>> getPostsByRestaurantId(int restaurantId) async {
    final maps = await _db.query(
      'posts',
      where: 'restaurant_id = ?',
      whereArgs: [restaurantId],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => Post.fromMap(map)).toList();
  }

  /// Get recent posts (feed)
  Future<List<Post>> getRecentPosts({int limit = 20, int offset = 0}) async {
    final maps = await _db.query(
      'posts',
      orderBy: 'created_at DESC',
      limit: limit,
      offset: offset,
    );
    return maps.map((map) => Post.fromMap(map)).toList();
  }

  /// Search posts by caption or dish name
  Future<List<Post>> searchPosts(String query) async {
    final maps = await _db.rawQuery(
      '''
      SELECT * FROM posts 
      WHERE caption LIKE ? OR dish_name LIKE ?
      ORDER BY created_at DESC
    ''',
      ['%$query%', '%$query%'],
    );
    return maps.map((map) => Post.fromMap(map)).toList();
  }

  /// Get posts count for a user
  Future<int> getPostsCountByUserId(int userId) async {
    return await _db.getCount(
      'posts',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  /// Get posts count for a restaurant
  Future<int> getPostsCountByRestaurantId(int restaurantId) async {
    return await _db.getCount(
      'posts',
      where: 'restaurant_id = ?',
      whereArgs: [restaurantId],
    );
  }

  // ==================== UPDATE ====================

  /// Update a post
  Future<int> updatePost(Post post) async {
    return await _db.update(
      'posts',
      post.toMap(),
      where: 'id = ?',
      whereArgs: [post.id],
    );
  }

  /// Increment likes count
  Future<void> incrementLikesCount(int postId) async {
    await _db.rawUpdate(
      'UPDATE posts SET likes_count = likes_count + 1 WHERE id = ?',
      [postId],
    );
  }

  /// Decrement likes count
  Future<void> decrementLikesCount(int postId) async {
    await _db.rawUpdate(
      'UPDATE posts SET likes_count = likes_count - 1 WHERE id = ? AND likes_count > 0',
      [postId],
    );
  }

  /// Increment comments count
  Future<void> incrementCommentsCount(int postId) async {
    await _db.rawUpdate(
      'UPDATE posts SET comments_count = comments_count + 1 WHERE id = ?',
      [postId],
    );
  }

  /// Decrement comments count
  Future<void> decrementCommentsCount(int postId) async {
    await _db.rawUpdate(
      'UPDATE posts SET comments_count = comments_count - 1 WHERE id = ? AND comments_count > 0',
      [postId],
    );
  }

  // ==================== DELETE ====================

  /// Delete a post by ID
  Future<int> deletePost(int id) async {
    return await _db.delete('posts', where: 'id = ?', whereArgs: [id]);
  }

  /// Delete all posts by a user
  Future<int> deletePostsByUserId(int userId) async {
    return await _db.delete('posts', where: 'user_id = ?', whereArgs: [userId]);
  }

  /// Delete all posts for a restaurant
  Future<int> deletePostsByRestaurantId(int restaurantId) async {
    return await _db.delete(
      'posts',
      where: 'restaurant_id = ?',
      whereArgs: [restaurantId],
    );
  }

  // ==================== UTILITY ====================

  /// Check if a post exists
  Future<bool> postExists(int id) async {
    return await _db.exists('posts', where: 'id = ?', whereArgs: [id]);
  }

  /// Get total posts count
  Future<int> getTotalPostsCount() async {
    return await _db.getCount('posts');
  }
}
