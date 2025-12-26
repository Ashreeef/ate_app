import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post.dart';
import '../services/firestore_service.dart';
import '../services/cloudinary_storage_service.dart';

/// Repository for Post data operations using Firestore
class PostRepository {
  final FirestoreService _firestoreService = FirestoreService();
  final CloudinaryStorageService _cloudinaryService = CloudinaryStorageService();

  // ==================== CREATE ====================

  /// Create a new post with Cloudinary image upload
  Future<String> createPost({
    required String userUid,
    required String username,
    required String? userAvatarUrl,
    required String caption,
    required List<File> imageFiles,
    String? restaurantUid,
    String? restaurantName,
    String? dishName,
    double? rating,
  }) async {
    try {
      // Upload images to Cloudinary
      final imageUrls = await _cloudinaryService.uploadPostImages(
        imageFiles,
        userUid,
      );

      // Create post document
      final postRef = _firestoreService.posts.doc();
      final now = DateTime.now().toIso8601String();

      final post = Post(
        postId: postRef.id,
        userUid: userUid,
        username: username,
        userAvatarUrl: userAvatarUrl,
        caption: caption,
        images: imageUrls,
        restaurantUid: restaurantUid,
        restaurantName: restaurantName,
        dishName: dishName,
        rating: rating,
        likesCount: 0,
        commentsCount: 0,
        likedByUids: [],
        savedByUids: [],
        createdAt: DateTime.parse(now),
        updatedAt: DateTime.parse(now),
      );

      await postRef.set(post.toFirestore());

      return postRef.id;
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  // ==================== READ ====================

  /// Get a post by ID
  Future<Post?> getPostById(String postId) async {
    try {
      final doc = await _firestoreService.posts.doc(postId).get();
      if (!doc.exists) return null;
      return Post.fromFirestore(doc.data() as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  /// Get posts by user UID
  Future<List<Post>> getUserPosts(String userUid, {int limit = 20}) async {
    try {
      // Note: We're not using orderBy here to avoid needing a composite index
      // (userId + createdAt) which requires manual console setup.
      // For a profile view, sorting client-side is acceptable.
      final querySnapshot = await _firestoreService.posts
          .where('userId', isEqualTo: userUid)
          .limit(limit)
          .get();

      final posts = querySnapshot.docs
          .map((doc) => Post.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
      
      // Sort client-side
      posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return posts;
    } catch (e) {
      print('Error getting user posts: $e');
      return [];
    }
  }

  /// Get posts by restaurant UID
  Future<List<Post>> getRestaurantPosts(String restaurantUid, {int limit = 20}) async {
    try {
      final querySnapshot = await _firestoreService.posts
          .where('restaurantId', isEqualTo: restaurantUid)
          .limit(limit)
          .get();

      final posts = querySnapshot.docs
          .map((doc) => Post.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();

      // Sort client-side to avoid needing a composite index
      posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return posts;
    } catch (e) {
      print('Error getting restaurant posts: $e');
      return [];
    }
  }

  /// Get recent posts (feed) with pagination
  Future<List<Post>> getFeedPosts({
    int limit = 20,
    DocumentSnapshot? lastDocument,
    List<String>? userIds,
  }) async {
    try {
      Query query = _firestoreService.posts
          .orderBy('createdAt', descending: true);

      if (userIds != null && userIds.isNotEmpty) {
        // Firestore whereIn supports up to 30 elements
        // For larger follow lists, we'd need a different architectural approach
        // or multiple queries, but for this app 30 is a reasonable limit for now.
        final limitedUserIds = userIds.take(30).toList();
        query = query.where('userId', whereIn: limitedUserIds);
      }

      query = query.limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final querySnapshot = await query.get();

      return querySnapshot.docs
          .map((doc) => Post.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching feed posts: $e');
      return [];
    }
  }

  /// Search posts by caption or dish name
  /// Note: Firestore doesn't support full-text search
  /// This is a client-side filter - consider using Algolia for production
  Future<List<Post>> searchPosts(String query) async {
    try {
      final querySnapshot = await _firestoreService.posts
          .orderBy('createdAt', descending: true)
          .limit(100)
          .get();

      final posts = querySnapshot.docs
          .map((doc) => Post.fromFirestore(doc.data() as Map<String, dynamic>))
          .where((post) =>
              post.caption.toLowerCase().contains(query.toLowerCase()) ||
              (post.dishName?.toLowerCase().contains(query.toLowerCase()) ?? false))
          .toList();

      return posts;
    } catch (e) {
      return [];
    }
  }

  /// Get posts count for a user
  Future<int> getUserPostsCount(String userUid) async {
    try {
      final querySnapshot = await _firestoreService.posts
          .where('userId', isEqualTo: userUid)
          .count()
          .get();

      return querySnapshot.count ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Get posts count for a restaurant
  Future<int> getRestaurantPostsCount(String restaurantUid) async {
    try {
      final querySnapshot = await _firestoreService.posts
          .where('restaurantId', isEqualTo: restaurantUid)
          .count()
          .get();

      return querySnapshot.count ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Stream posts in real-time (for feed)
  Stream<List<Post>> getPostsStream({int limit = 20}) {
    return _firestoreService.posts
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Post.fromFirestore(doc.data() as Map<String, dynamic>))
            .toList());
  }

  /// Stream user posts in real-time
  Stream<List<Post>> getUserPostsStream(String userUid, {int limit = 20}) {
    return _firestoreService.posts
        .where('userId', isEqualTo: userUid)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Post.fromFirestore(doc.data() as Map<String, dynamic>))
            .toList());
  }

  // ==================== UPDATE ====================

  /// Update a post
  Future<void> updatePost(Post post) async {
    try {
      if (post.postId == null) {
        throw Exception('Post ID is required for update');
      }

      final updatedPost = post.copyWith(
        updatedAt: DateTime.now(),
      );

      await _firestoreService.posts
          .doc(post.postId)
          .update(updatedPost.toFirestore());
    } catch (e) {
      throw Exception('Failed to update post: $e');
    }
  }

  /// Update user details on all their posts (batch update)
  /// Call this when user updates profile (avatar/username)
  Future<void> updatePostUserByUid({
    required String userUid,
    required String username,
    required String? userAvatarUrl,
  }) async {
    try {
      // 1. Get all posts by this user
      final snapshot = await _firestoreService.posts
          .where('userId', isEqualTo: userUid)
          .get();

      if (snapshot.docs.isEmpty) return;

      final batch = _firestoreService.batch();
      
      // 2. Queue updates for each post
      for (var doc in snapshot.docs) {
        batch.update(doc.reference, {
          'username': username,
          'userAvatarUrl': userAvatarUrl,
          // Update legacy fields too just in case
          'userName': username,
          'userAvatar': userAvatarUrl,
        });
      }

      // 3. Commit ALL updates atomically
      await batch.commit();
    } catch (e) {
      print('Failed to batch update user posts: $e');
      throw Exception('Failed to update posts with new user data');
    }
  }

  /// Increment likes count and add user to likedBy array
  Future<void> incrementLikesCount(String postId, String userUid) async {
    try {
      await _firestoreService.posts.doc(postId).update({
        'likesCount': FieldValue.increment(1),
        'likedBy': FieldValue.arrayUnion([userUid]),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to increment likes: $e');
    }
  }

  /// Decrement likes count and remove user from likedBy array
  Future<void> decrementLikesCount(String postId, String userUid) async {
    try {
      await _firestoreService.posts.doc(postId).update({
        'likesCount': FieldValue.increment(-1),
        'likedBy': FieldValue.arrayRemove([userUid]),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to decrement likes: $e');
    }
  }

  /// Increment comments count
  Future<void> incrementCommentsCount(String postId) async {
    try {
      await _firestoreService.posts.doc(postId).update({
        'commentsCount': FieldValue.increment(1),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to increment comments: $e');
    }
  }

  /// Decrement comments count
  Future<void> decrementCommentsCount(String postId) async {
    try {
      await _firestoreService.posts.doc(postId).update({
        'commentsCount': FieldValue.increment(-1),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to decrement comments: $e');
    }
  }

  /// Add user to savedBy array
  Future<void> addToSavedBy(String postId, String userUid) async {
    try {
      await _firestoreService.posts.doc(postId).update({
        'savedBy': FieldValue.arrayUnion([userUid]),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to add to savedBy: $e');
    }
  }

  /// Remove user from savedBy array
  Future<void> removeFromSavedBy(String postId, String userUid) async {
    try {
      await _firestoreService.posts.doc(postId).update({
        'savedBy': FieldValue.arrayRemove([userUid]),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to remove from savedBy: $e');
    }
  }

  // ==================== DELETE ====================

  /// Delete a post by ID
  /// Note: Images remain in Cloudinary (set auto-cleanup in Cloudinary dashboard)
  Future<void> deletePost(String postId) async {
    try {
      // Delete all comments subcollection
      final commentsSnapshot = await _firestoreService.posts
          .doc(postId)
          .collection('comments')
          .get();

      for (var doc in commentsSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete all likes subcollection
      final likesSnapshot = await _firestoreService.posts
          .doc(postId)
          .collection('likes')
          .get();

      for (var doc in likesSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete the post document
      await _firestoreService.posts.doc(postId).delete();
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }

  /// Delete all posts by a user
  Future<void> deleteUserPosts(String userUid) async {
    try {
      final querySnapshot = await _firestoreService.posts
          .where('userId', isEqualTo: userUid)
          .get();

      for (var doc in querySnapshot.docs) {
        await deletePost(doc.id);
      }
    } catch (e) {
      throw Exception('Failed to delete user posts: $e');
    }
  }

  // ==================== UTILITY ====================

  /// Check if a post exists
  Future<bool> postExists(String postId) async {
    try {
      final doc = await _firestoreService.posts.doc(postId).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  /// Get total posts count
  Future<int> getTotalPostsCount() async {
    try {
      final querySnapshot = await _firestoreService.posts.count().get();
      return querySnapshot.count ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Check if user liked a post
  Future<bool> isPostLikedByUser(String postId, String userUid) async {
    try {
      final doc = await _firestoreService.posts.doc(postId).get();
      if (!doc.exists) return false;

      final post = Post.fromFirestore(doc.data() as Map<String, dynamic>);
      return post.likedByUids.contains(userUid);
    } catch (e) {
      return false;
    }
  }

  /// Check if user saved a post
  Future<bool> isPostSavedByUser(String postId, String userUid) async {
    try {
      final doc = await _firestoreService.posts.doc(postId).get();
      if (!doc.exists) return false;

      final post = Post.fromFirestore(doc.data() as Map<String, dynamic>);
      return post.savedByUids.contains(userUid);
    } catch (e) {
      return false;
    }
  }

  // ==================== BACKWARD COMPATIBILITY ====================

  /// Backward-compatible alias for getUserPosts
  @Deprecated('Use getUserPosts instead')
  Future<List<Post>> getPostsByUserId(int userId) async {
    // This is a compatibility shim - in real usage, pass the Firebase UID
    // For now, return empty list since we can't convert int ID to UID
    return [];
  }

  /// Backward-compatible alias - returns empty since Firestore uses pagination
  @Deprecated('Use getFeedPosts with pagination instead')
  Future<List<Post>> getAllPosts() async {
    // Firestore doesn't support getting ALL posts without pagination
    // Return empty list - screens using this need to be updated
    return [];
  }
}