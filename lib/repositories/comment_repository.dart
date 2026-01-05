import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/comment.dart';
import '../models/notification.dart';
import '../services/firestore_service.dart';
import 'notification_repository.dart';
import 'post_repository.dart';

/// Repository for Comment data operations using Firestore
/// Comments are stored as subcollections under posts/{postId}/comments
class CommentRepository {
  final FirestoreService _firestoreService = FirestoreService();
  final NotificationRepository _notificationRepository =
      NotificationRepository();
  final PostRepository _postRepository = PostRepository();

  // ==================== CREATE ====================

  /// Add a comment to a post
  Future<String> addComment({
    required String postId,
    required String userUid,
    required String username,
    required String? userAvatarUrl,
    required String content,
  }) async {
    try {
      // Create comment document in subcollection
      final commentRef = _firestoreService.posts
          .doc(postId)
          .collection('comments')
          .doc();

      final now = DateTime.now().toIso8601String();

      final comment = Comment(
        commentId: commentRef.id,
        postUid: postId,
        userUid: userUid,
        username: username,
        userAvatarUrl: userAvatarUrl,
        content: content,
        createdAt: now,
      );

      final batch = _firestoreService.batch();

      batch.set(commentRef, comment.toFirestore());

      // Increment comments count on post
      final postRef = _firestoreService.posts.doc(postId);
      batch.update(postRef, {
        'commentsCount': FieldValue.increment(1),
        'updatedAt': DateTime.now().toIso8601String(),
      });

      await batch.commit();

      // Create notification for post author
      try {
        final post = await _postRepository.getPostById(postId);
        if (post != null && post.userUid != null && post.userUid != userUid) {
          await _notificationRepository.createNotification(
            recipientUid: post.userUid!,
            type: NotificationType.comment,
            actorUid: userUid,
            actorUsername: username,
            actorProfileImage: userAvatarUrl,
            postId: postId,
          );
        }
      } catch (e) {
        print('Failed to create comment notification: $e');
        // Don't fail the comment operation if notification fails
      }

      return commentRef.id;
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  // ==================== READ ====================

  /// Get all comments for a post
  Future<List<Comment>> getPostComments(String postId, {int limit = 50}) async {
    try {
      final querySnapshot = await _firestoreService.posts
          .doc(postId)
          .collection('comments')
          .orderBy('createdAt', descending: false)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => Comment.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Get a single comment by ID
  Future<Comment?> getCommentById(String postId, String commentId) async {
    try {
      final doc = await _firestoreService.posts
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .get();

      if (!doc.exists) return null;
      return Comment.fromFirestore(doc.data()!);
    } catch (e) {
      return null;
    }
  }

  /// Get comments count for a post
  Future<int> getCommentsCount(String postId) async {
    try {
      final querySnapshot = await _firestoreService.posts
          .doc(postId)
          .collection('comments')
          .count()
          .get();

      return querySnapshot.count ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Stream comments in real-time
  Stream<List<Comment>> getCommentsStream(String postId, {int limit = 50}) {
    return _firestoreService.posts
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: false)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Comment.fromFirestore(doc.data()))
              .toList(),
        );
  }

  // ==================== UPDATE ====================

  /// Update a comment
  Future<void> updateComment({
    required String postId,
    required String commentId,
    required String content,
  }) async {
    try {
      await _firestoreService.posts
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .update({
            'content': content,
            'updatedAt': DateTime.now().toIso8601String(),
          });
    } catch (e) {
      throw Exception('Failed to update comment: $e');
    }
  }

  // ==================== DELETE ====================

  /// Delete a comment
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await _firestoreService.posts
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .delete();

      // Decrement comments count on post
      await _firestoreService.posts.doc(postId).update({
        'commentsCount': FieldValue.increment(-1),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to delete comment: $e');
    }
  }

  /// Delete all comments for a post (used when deleting post)
  Future<void> deleteAllPostComments(String postId) async {
    try {
      final querySnapshot = await _firestoreService.posts
          .doc(postId)
          .collection('comments')
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete all comments: $e');
    }
  }

  // ==================== UTILITY ====================

  /// Check if a comment exists
  Future<bool> commentExists(String postId, String commentId) async {
    try {
      final doc = await _firestoreService.posts
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .get();

      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  // ==================== BACKWARD COMPATIBILITY ====================

  /// Backward-compatible alias for addComment
  @Deprecated('Use addComment instead')
  Future<int> createComment(dynamic comment) async {
    // This is a compatibility shim - return 0 as placeholder
    return 0;
  }

  /// Backward-compatible alias for getPostComments
  @Deprecated('Use getPostComments instead')
  Future<List<Comment>> getCommentsByPostId(int postId) async {
    // This is a compatibility shim - return empty list
    return [];
  }

  /// Backward-compatible alias - returns empty
  @Deprecated('Use getPostComments instead')
  Future<List<Comment>> getRecentComments({int limit = 50}) async {
    // This method doesn't make sense in Firestore (comments are per-post)
    return [];
  }
}
