import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

/// Repository for Like data operations using Firestore
/// Likes are stored as subcollections under posts/{postId}/likes
/// AND as array in post document for quick access
class LikeRepository {
  final FirestoreService _firestoreService = FirestoreService();

  // ==================== CREATE ====================

  /// Like a post
  Future<void> likePost(String postId, String userUid) async {
    try {
      final batch = _firestoreService.batch();

      // Add like document to subcollection
      final likeRef = _firestoreService.posts
          .doc(postId)
          .collection('likes')
          .doc(userUid);

      batch.set(likeRef, {
        'userId': userUid,
        'createdAt': DateTime.now().toIso8601String(),
      });

      // Update post document (increment count + add to array)
      final postRef = _firestoreService.posts.doc(postId);
      batch.update(postRef, {
        'likesCount': FieldValue.increment(1),
        'likedBy': FieldValue.arrayUnion([userUid]),
        'updatedAt': DateTime.now().toIso8601String(),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to like post: $e');
    }
  }

  // ==================== DELETE ====================

  /// Unlike a post
  Future<void> unlikePost(String postId, String userUid) async {
    try {
      final batch = _firestoreService.batch();

      // Remove like document from subcollection
      final likeRef = _firestoreService.posts
          .doc(postId)
          .collection('likes')
          .doc(userUid);

      batch.delete(likeRef);

      // Update post document (decrement count + remove from array)
      final postRef = _firestoreService.posts.doc(postId);
      batch.update(postRef, {
        'likesCount': FieldValue.increment(-1),
        'likedBy': FieldValue.arrayRemove([userUid]),
        'updatedAt': DateTime.now().toIso8601String(),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to unlike post: $e');
    }
  }

  // ==================== READ ====================

  /// Check if user liked a post
  Future<bool> isPostLiked(String postId, String userUid) async {
    try {
      final doc = await _firestoreService.posts
          .doc(postId)
          .collection('likes')
          .doc(userUid)
          .get();

      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  /// Get all user UIDs who liked a post
  Future<List<String>> getPostLikes(String postId) async {
    try {
      final querySnapshot = await _firestoreService.posts
          .doc(postId)
          .collection('likes')
          .get();

      return querySnapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      return [];
    }
  }

  /// Get likes count for a post
  Future<int> getLikesCount(String postId) async {
    try {
      final querySnapshot = await _firestoreService.posts
          .doc(postId)
          .collection('likes')
          .count()
          .get();

      return querySnapshot.count ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Get all posts liked by a user
  Future<List<String>> getUserLikedPosts(String userUid) async {
    try {
      // Query posts where likedBy array contains userUid
      final querySnapshot = await _firestoreService.posts
          .where('likedBy', arrayContains: userUid)
          .get();

      return querySnapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      return [];
    }
  }

  // ==================== UTILITY ====================

  /// Delete all likes for a post (used when deleting post)
  Future<void> deleteAllPostLikes(String postId) async {
    try {
      final querySnapshot = await _firestoreService.posts
          .doc(postId)
          .collection('likes')
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete all likes: $e');
    }
  }
}
