import '../database/database_helper.dart';
import '../models/saved_post.dart';

/// Repository for Saved Post data operations
class SavedPostRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  // ==================== CREATE ====================

  /// Save a post
  Future<void> savePost(String userId, String postId) async {
    try {
      await _db.insert('saved_posts', {
        'user_id': userId,
        'post_id': postId,
      });
    } catch (e) {
      // Post already saved or error
    }
  }

  // ==================== READ ====================

  /// Check if user has saved a post
  Future<bool> hasUserSavedPost(String userId, String postId) async {
    return await _db.exists(
      'saved_posts',
      where: 'user_id = ? AND post_id = ?',
      whereArgs: [userId, postId],
    );
  }

  /// Get all saved posts by a user
  Future<List<SavedPost>> getSavedPostsByUserId(String userId) async {
    final maps = await _db.query(
      'saved_posts',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => SavedPost.fromMap(map)).toList();
  }

  /// Get saved post IDs by a user
  Future<List<String>> getSavedPostIdsByUserId(String userId) async {
    final maps = await _db.query(
      'saved_posts',
      columns: ['post_id'],
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => map['post_id'].toString()).toList();
  }

  /// Get saved posts count for a user
  Future<int> getSavedPostsCountByUserId(String userId) async {
    return await _db.getCount(
      'saved_posts',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  /// Get users who saved a specific post
  Future<List<String>> getUsersWhoSavedPost(String postId) async {
    final maps = await _db.query(
      'saved_posts',
      columns: ['user_id'],
      where: 'post_id = ?',
      whereArgs: [postId],
    );
    return maps.map((map) => map['user_id'].toString()).toList();
  }

  /// Get count of how many users saved a post
  Future<int> getSavesCountByPostId(String postId) async {
    return await _db.getCount(
      'saved_posts',
      where: 'post_id = ?',
      whereArgs: [postId],
    );
  }

  // ==================== DELETE ====================

  /// Unsave a post
  Future<void> unsavePost(String userId, String postId) async {
    await _db.delete(
      'saved_posts',
      where: 'user_id = ? AND post_id = ?',
      whereArgs: [userId, postId],
    );
  }

  /// Delete all saved posts by a user
  Future<int> deleteSavedPostsByUserId(String userId) async {
    return await _db.delete(
      'saved_posts',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  /// Delete all saves for a specific post
  Future<int> deleteSavesByPostId(String postId) async {
    return await _db.delete(
      'saved_posts',
      where: 'post_id = ?',
      whereArgs: [postId],
    );
  }

  // ==================== UTILITY ====================

  /// Toggle saved post (save if not exists, unsave if exists)
  Future<bool> toggleSavePost(String userId, String postId) async {
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
