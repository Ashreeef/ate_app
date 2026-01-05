import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification.dart';
import '../services/firestore_service.dart';

/// Repository for notification data operations using Firestore
class NotificationRepository {
  final FirestoreService _firestoreService = FirestoreService();

  /// Get real-time notifications stream for a user
  Stream<List<DocumentSnapshot>> getNotificationsStream(String userUid) {
    return _firestoreService.users
        .doc(userUid)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  /// Create a notification (used when triggering follow, like, comment actions)
  Future<void> createNotification({
    required String recipientUid,
    required NotificationType type,
    required String actorUid,
    required String actorUsername,
    String? actorProfileImage,
    String? postId,
  }) async {
    try {
      // Don't create notification if user is notifying themselves
      if (recipientUid == actorUid) return;

      // Store type-based keys - UI will display localized versions
      // based on the notification.type enum
      String title = type.name;
      String body = actorUsername;

      final notification = AppNotification(
        userUid: recipientUid,
        type: type,
        title: title,
        body: body,
        actorUid: actorUid,
        actorUsername: actorUsername,
        actorProfileImage: actorProfileImage,
        postId: postId,
        createdAt: DateTime.now(),
        isRead: false,
      );

      await saveNotification(notification);
    } catch (e) {
      throw Exception('Failed to create notification: $e');
    }
  }

  /// Save a notification to Firestore
  Future<void> saveNotification(AppNotification notification) async {
    try {
      final docRef = _firestoreService.users
          .doc(notification.userUid)
          .collection('notifications')
          .doc();

      await docRef.set(notification.toFirestore());
    } catch (e) {
      throw Exception('Failed to save notification: $e');
    }
  }

  /// Get notifications for a user
  Future<List<AppNotification>> getNotifications(
    String userUid, {
    int limit = 50,
  }) async {
    try {
      final querySnapshot = await _firestoreService.users
          .doc(userUid)
          .collection('notifications')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => AppNotification.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get notifications: $e');
    }
  }

  /// Get unread notification count for a user
  Future<int> getUnreadCount(String userUid) async {
    try {
      final querySnapshot = await _firestoreService.users
          .doc(userUid)
          .collection('notifications')
          .where('isRead', isEqualTo: false)
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      throw Exception('Failed to get unread count: $e');
    }
  }

  /// Mark a notification as read
  Future<void> markAsRead(String userUid, String notificationId) async {
    try {
      await _firestoreService.users
          .doc(userUid)
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  /// Mark all notifications as read for a user
  Future<void> markAllAsRead(String userUid) async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      final querySnapshot = await _firestoreService.users
          .doc(userUid)
          .collection('notifications')
          .where('isRead', isEqualTo: false)
          .get();

      for (final doc in querySnapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to mark all notifications as read: $e');
    }
  }

  /// Delete a notification
  Future<void> deleteNotification(String userUid, String notificationId) async {
    try {
      await _firestoreService.users
          .doc(userUid)
          .collection('notifications')
          .doc(notificationId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete notification: $e');
    }
  }

  /// Delete all notifications for a user
  Future<void> deleteAllNotifications(String userUid) async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      final querySnapshot = await _firestoreService.users
          .doc(userUid)
          .collection('notifications')
          .get();

      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete all notifications: $e');
    }
  }
}
