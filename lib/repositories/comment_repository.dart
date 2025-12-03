import '../database/database_helper.dart';
import '../models/comment.dart';

/// Repository for Comment data operations
class CommentRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  // ==================== CREATE ====================

  /// Create a new comment
  Future<int> createComment(Comment comment) async {
    return await _db.insert('comments', comment.toMap());
  }

  /// Create multiple comments in batch
  Future<void> createComments(List<Comment> comments) async {
    final maps = comments.map((c) => c.toMap()).toList();
    await _db.insertBatch('comments', maps);
  }

  // ==================== READ ====================

  /// Get a comment by ID
  Future<Comment?> getCommentById(int id) async {
    final map = await _db.queryOne(
      'comments',
      where: 'id = ?',
      whereArgs: [id],
    );
    return map != null ? Comment.fromMap(map) : null;
  }

  /// Get all comments for a post
  Future<List<Comment>> getCommentsByPostId(
    int postId, {
    String? orderBy = 'created_at ASC',
  }) async {
    final maps = await _db.query(
      'comments',
      where: 'post_id = ?',
      whereArgs: [postId],
      orderBy: orderBy,
    );
    return maps.map((map) => Comment.fromMap(map)).toList();
  }

  /// Get all comments by a user
  Future<List<Comment>> getCommentsByUserId(int userId) async {
    final maps = await _db.query(
      'comments',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => Comment.fromMap(map)).toList();
  }

  /// Get recent comments (across all posts)
  Future<List<Comment>> getRecentComments({int limit = 50}) async {
    final maps = await _db.query(
      'comments',
      orderBy: 'created_at DESC',
      limit: limit,
    );
    return maps.map((map) => Comment.fromMap(map)).toList();
  }

  /// Get comments count for a post
  Future<int> getCommentsCountByPostId(int postId) async {
    return await _db.getCount(
      'comments',
      where: 'post_id = ?',
      whereArgs: [postId],
    );
  }

  /// Get comments count by a user
  Future<int> getCommentsCountByUserId(int userId) async {
    return await _db.getCount(
      'comments',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  // ==================== UPDATE ====================

  /// Update a comment
  Future<int> updateComment(Comment comment) async {
    return await _db.update(
      'comments',
      comment.toMap(),
      where: 'id = ?',
      whereArgs: [comment.id],
    );
  }

  /// Update comment content
  Future<int> updateCommentContent(int commentId, String newContent) async {
    return await _db.update(
      'comments',
      {'content': newContent},
      where: 'id = ?',
      whereArgs: [commentId],
    );
  }

  // ==================== DELETE ====================

  /// Delete a comment by ID
  Future<int> deleteComment(int id) async {
    return await _db.delete('comments', where: 'id = ?', whereArgs: [id]);
  }

  /// Delete all comments for a post
  Future<int> deleteCommentsByPostId(int postId) async {
    return await _db.delete(
      'comments',
      where: 'post_id = ?',
      whereArgs: [postId],
    );
  }

  /// Delete all comments by a user
  Future<int> deleteCommentsByUserId(int userId) async {
    return await _db.delete(
      'comments',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  // ==================== UTILITY ====================

  /// Check if a comment exists
  Future<bool> commentExists(int id) async {
    return await _db.exists('comments', where: 'id = ?', whereArgs: [id]);
  }

  /// Get total comments count
  Future<int> getTotalCommentsCount() async {
    return await _db.getCount('comments');
  }
}
