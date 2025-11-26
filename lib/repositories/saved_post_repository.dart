import '../database/database_helper.dart';
import '../models/saved_post.dart';

/// Repository for Saved Post data operations
class SavedPostRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  // ==================== CREATE ====================

  /// Save a post
  Future<int> savePost(int userId, int postId) async {
    try {
      return await _db.insert('saved_posts', {
        'user_id': userId,
        'post_id': postId,
      });
    } catch (e) {
      // Post already saved (UNIQUE constraint violation)
      return 0;
    }
  }

  // ==================== READ ====================

  /// Check if user has saved a post
  Future<bool> hasUserSavedPost(int userId, int postId) async {
    return await _db.exists(
      'saved_posts',
      where: 'user_id = ? AND post_id = ?',
      whereArgs: [userId, postId],
    );
  }

  /// Get all saved posts by a user
  Future<List<SavedPost>> getSavedPostsByUserId(int userId) async {
    final maps = await _db.query(
      'saved_posts',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => SavedPost.fromMap(map)).toList();
  }

  /// Get saved post IDs by a user
  Future<List<int>> getSavedPostIdsByUserId(int userId) async {
    final maps = await _db.query(
      'saved_posts',
      columns: ['post_id'],
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => map['post_id'] as int).toList();
  }

  /// Get saved posts count for a user
  Future<int> getSavedPostsCountByUserId(int userId) async {
    return await _db.getCount(
      'saved_posts',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  /// Get users who saved a specific post
  Future<List<int>> getUsersWhoSavedPost(int postId) async {
    final maps = await _db.query(
      'saved_posts',
      columns: ['user_id'],
      where: 'post_id = ?',
      whereArgs: [postId],
    );
    return maps.map((map) => map['user_id'] as int).toList();
  }

  /// Get count of how many users saved a post
  Future<int> getSavesCountByPostId(int postId) async {
    return await _db.getCount(
      'saved_posts',
      where: 'post_id = ?',
      whereArgs: [postId],
    );
  }

  // ==================== DELETE ====================

  /// Unsave a post
  Future<int> unsavePost(int userId, int postId) async {
    return await _db.delete(
      'saved_posts',
      where: 'user_id = ? AND post_id = ?',
      whereArgs: [userId, postId],
    );
  }

  /// Delete all saved posts by a user
  Future<int> deleteSavedPostsByUserId(int userId) async {
    return await _db.delete(
      'saved_posts',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  /// Delete all saves for a specific post
  Future<int> deleteSavesByPostId(int postId) async {
    return await _db.delete(
      'saved_posts',
      where: 'post_id = ?',
      whereArgs: [postId],
    );
  }

  // ==================== UTILITY ====================

  /// Toggle saved post (save if not exists, unsave if exists)
  Future<bool> toggleSavePost(int userId, int postId) async {
    final exists = await hasUserSavedPost(userId, postId);
    if (exists) {
      await unsavePost(userId, postId);
      return false; // unsaved
    } else {
      await savePost(userId, postId);
      return true; // saved
    }
  }

  /// Get total saved posts count
  Future<int> getTotalSavedPostsCount() async {
    return await _db.getCount('saved_posts');
  }
}
