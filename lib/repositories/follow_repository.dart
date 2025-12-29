import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

/// Repository for managing social graph (follows)
class FollowRepository {
  final FirestoreService _firestoreService = FirestoreService();

  /// Follow a user
  /// Creates a follow document and updates both users' counts atomically
  Future<void> followUser({
    required String currentUserId,
    required String targetUserId,
  }) async {
    if (currentUserId == targetUserId) {
      throw Exception('Users cannot follow themselves');
    }

    final followDocId = '${currentUserId}_$targetUserId';
    final followRef = _firestoreService.instance.collection('follows').doc(followDocId);

    // Check if already following to avoid double counting
    final docSnapshot = await followRef.get();
    if (docSnapshot.exists) {
      return; // Already following
    }

    final batch = _firestoreService.batch();

    // 1. Create follow relationship document
    batch.set(followRef, {
      'followerId': currentUserId,
      'followingId': targetUserId,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // 2. Increment "following" count for current user
    final currentUserRef = _firestoreService.users.doc(currentUserId);
    batch.update(currentUserRef, {
      'followingCount': FieldValue.increment(1),
    });

    // 3. Increment "followers" count for target user
    final targetUserRef = _firestoreService.users.doc(targetUserId);
    batch.update(targetUserRef, {
      'followersCount': FieldValue.increment(1),
    });

    await batch.commit();
  }

  /// Unfollow a user
  /// Deletes the follow document and updates both users' counts atomically
  Future<void> unfollowUser({
    required String currentUserId,
    required String targetUserId,
  }) async {
    final followDocId = '${currentUserId}_$targetUserId';
    final followRef = _firestoreService.instance.collection('follows').doc(followDocId);

    // Check if following exists
    final docSnapshot = await followRef.get();
    if (!docSnapshot.exists) {
      return; // Not following
    }

    final batch = _firestoreService.batch();

    // 1. Delete follow relationship document
    batch.delete(followRef);

    // 2. Decrement "following" count for current user
    final currentUserRef = _firestoreService.users.doc(currentUserId);
    batch.update(currentUserRef, {
      'followingCount': FieldValue.increment(-1),
    });

    // 3. Decrement "followers" count for target user
    final targetUserRef = _firestoreService.users.doc(targetUserId);
    batch.update(targetUserRef, {
      'followersCount': FieldValue.increment(-1),
    });

    await batch.commit();
  }

  /// Check if current user is following target user
  Future<bool> isFollowing(String currentUserId, String targetUserId) async {
    final followDocId = '${currentUserId}_$targetUserId';
    final doc = await _firestoreService.instance
        .collection('follows')
        .doc(followDocId)
        .get();
    return doc.exists;
  }

  /// Get list of users that the target user is following
  Future<List<String>> getFollowingIds(String userId) async {
    final snapshot = await _firestoreService.instance
        .collection('follows')
        .where('followerId', isEqualTo: userId)
        .get();
    
    return snapshot.docs.map((doc) => doc['followingId'] as String).toList();
  }

  /// Get list of users who follow the target user
  Future<List<String>> getFollowerIds(String userId) async {
    final snapshot = await _firestoreService.instance
        .collection('follows')
        .where('followingId', isEqualTo: userId)
        .get();
    
    return snapshot.docs.map((doc) => doc['followerId'] as String).toList();
  }
}
