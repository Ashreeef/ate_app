import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import '../models/post.dart';

/// Repository for Saved Post data operations using Firestore
/// Saved posts are stored in a top-level collection 'savedPosts'
class SavedPostRepository {
  final FirestoreService _firestoreService = FirestoreService();

  // ==================== CREATE ====================

  /// Save a post for a user
  Future<void> savePost(String postId, String userUid) async {
    try {
      // Create saved post document
      final batch = _firestoreService.batch();

      // Create saved post document
      final saveId = '${userUid}_$postId';
      final saveRef = _firestoreService.savedPosts.doc(saveId);

      batch.set(saveRef, {
        'userId': userUid,
        'postId': postId,
        'createdAt': DateTime.now().toIso8601String(),
      });

      // Update post document (add to savedBy array)
      final postRef = _firestoreService.posts.doc(postId);
      batch.update(postRef, {
        'savedBy': FieldValue.arrayUnion([userUid]),
        'updatedAt': DateTime.now().toIso8601String(),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to save post: $e');
    }
  }

  // ==================== DELETE ====================

  /// Unsave a post for a user
  Future<void> unsavePost(String postId, String userUid) async {
    try {
      // Delete saved post document
      final batch = _firestoreService.batch();

      // Delete saved post document
      final saveId = '${userUid}_$postId';
      final saveRef = _firestoreService.savedPosts.doc(saveId);

      batch.delete(saveRef);

      // Update post document (remove from savedBy array)
      final postRef = _firestoreService.posts.doc(postId);
      batch.update(postRef, {
        'savedBy': FieldValue.arrayRemove([userUid]),
        'updatedAt': DateTime.now().toIso8601String(),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to unsave post: $e');
    }
  }

  // ==================== READ ====================

  /// Check if user saved a post
  Future<bool> isPostSaved(String postId, String userUid) async {
    try {
      final saveId = '${userUid}_$postId';
      final doc = await _firestoreService.savedPosts.doc(saveId).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  /// Get all saved posts for a user
  Future<List<Post>> getUserSavedPosts(String userUid, {int limit = 50}) async {
    try {
      // Get saved post documents
      final savedSnapshot = await _firestoreService.savedPosts
          .where('userId', isEqualTo: userUid)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      // Get post IDs
      final postIds = savedSnapshot.docs
          .map((doc) => (doc.data() as Map<String, dynamic>)['postId'] as String)
          .toList();

      if (postIds.isEmpty) return [];

      // Fetch actual posts
      final posts = <Post>[];
      for (var postId in postIds) {
        final postDoc = await _firestoreService.posts.doc(postId).get();
        if (postDoc.exists) {
          posts.add(Post.fromFirestore(postDoc.data() as Map<String, dynamic>));
        }
      }

      return posts;
    } catch (e) {
      return [];
    }
  }

  /// Get saved posts count for a user
  Future<int> getUserSavedPostsCount(String userUid) async {
    try {
      final querySnapshot = await _firestoreService.savedPosts
          .where('userId', isEqualTo: userUid)
          .count()
          .get();

      return querySnapshot.count ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Stream saved posts in real-time
  Stream<List<String>> getSavedPostsStream(String userUid) {
    return _firestoreService.savedPosts
        .where('userId', isEqualTo: userUid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => (doc.data() as Map<String, dynamic>)['postId'] as String)
            .toList());
  }

  // ==================== UTILITY ====================

  /// Delete all saved posts for a user
  Future<void> deleteUserSavedPosts(String userUid) async {
    try {
      final querySnapshot = await _firestoreService.savedPosts
          .where('userId', isEqualTo: userUid)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete user saved posts: $e');
    }
  }

  /// Delete all saves for a specific post (used when deleting post)
  Future<void> deletePostSaves(String postId) async {
    try {
      final querySnapshot = await _firestoreService.savedPosts
          .where('postId', isEqualTo: postId)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete post saves: $e');
    }
  }
}
