import 'package:flutter/material.dart';
import '../models/notification.dart';

/// Helper class for handling notification navigation
class NotificationNavigationHelper {
  /// Handle notification tap and navigate to appropriate screen
  static void handleNotificationTap(
    BuildContext context,
    Map<String, dynamic> data,
  ) {
    final typeString = data['type'] as String?;
    if (typeString == null) return;

    final type = NotificationTypeExtension.fromString(typeString);
    final actorUid = data['actorUid'] as String?;
    final postId = data['postId'] as String?;

    switch (type) {
      case NotificationType.follow:
        // Navigate to user profile
        if (actorUid != null) {
          Navigator.of(context).pushNamed('/profile', arguments: actorUid);
        }
        break;

      case NotificationType.like:
      case NotificationType.comment:
        // Navigate to post detail
        if (postId != null) {
          Navigator.of(context).pushNamed('/post-detail', arguments: postId);
        }
        break;
    }
  }

  /// Handle notification tap from AppNotification object
  static void handleNotificationTapFromObject(
    BuildContext context,
    AppNotification notification,
  ) {
    switch (notification.type) {
      case NotificationType.follow:
        // Navigate to user profile
        Navigator.of(
          context,
        ).pushNamed('/profile', arguments: notification.actorUid);
        break;

      case NotificationType.like:
      case NotificationType.comment:
        // Navigate to post detail
        if (notification.postId != null) {
          Navigator.of(
            context,
          ).pushNamed('/post-detail', arguments: notification.postId);
        }
        break;
    }
  }
}
