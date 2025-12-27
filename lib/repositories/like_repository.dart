import '../database/database_helper.dart';
import '../models/like.dart';

/// Repository for Like data operations
class LikeRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  // ==================== CREATE ====================

  /// Add a like to a post
  Future<void> likePost(String userId, String postId) async {
    try {
      await _db.insert('likes', {'user_id': userId, 'post_id': postId});
    } catch (e) {
      // Like already exists or error
    }
  }

  // ==================== READ ====================

  /// Check if user has liked a post
  Future<bool> hasUserLikedPost(String userId, String postId) async {
    return await _db.exists(
      'likes',
      where: 'user_id = ? AND post_id = ?',
      whereArgs: [userId, postId],
    );
  }

  /// Get all likes for a post
  Future<List<Like>> getLikesByPostId(String postId) async {
    final maps = await _db.query(
      'likes',
      where: 'post_id = ?',
      whereArgs: [postId],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => Like.fromMap(map)).toList();
  }

  /// Get all posts liked by a user
  Future<List<String>> getPostsLikedByUser(String userId) async {
    final maps = await _db.query(
      'likes',
      columns: ['post_id'],
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => map['post_id'].toString()).toList();
  }

  /// Get likes count for a post
  Future<int> getLikesCountByPostId(String postId) async {
    return await _db.getCount(
      'likes',
      where: 'post_id = ?',
      whereArgs: [postId],
    );
  }

  /// Get total number of likes by a user
  Future<int> getLikesCountByUserId(String userId) async {
    return await _db.getCount(
      'likes',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  /// Get users who liked a post
  Future<List<String>> getUsersWhoLikedPost(String postId) async {
    final maps = await _db.query(
      'likes',
      columns: ['user_id'],
      where: 'post_id = ?',
      whereArgs: [postId],
    );
    return maps.map((map) => map['user_id'].toString()).toList();
  }

  // ==================== DELETE ====================

  /// Remove a like from a post (unlike)
  Future<void> unlikePost(String userId, String postId) async {
    await _db.delete(
      'likes',
      where: 'user_id = ? AND post_id = ?',
      whereArgs: [userId, postId],
    );
  }

  /// Delete all likes for a post
  Future<int> deleteLikesByPostId(String postId) async {
    return await _db.delete('likes', where: 'post_id = ?', whereArgs: [postId]);
  }

  /// Delete all likes by a user
  Future<int> deleteLikesByUserId(String userId) async {
    return await _db.delete('likes', where: 'user_id = ?', whereArgs: [userId]);
  }

  // ==================== UTILITY ====================

  /// Toggle like (add if not exists, remove if exists)
  Future<bool> toggleLike(String userId, String postId) async {
    final exists = await hasUserLikedPost(userId, postId);
    if (exists) {
      await unlikePost(userId, postId);
      return false; // unliked
    } else {
      await likePost(userId, postId);
      return true; // liked
    }
  }

  /// Get total likes count
  Future<int> getTotalLikesCount() async {
    return await _db.getCount('likes');
  }
}
