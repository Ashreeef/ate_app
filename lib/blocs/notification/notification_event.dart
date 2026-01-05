import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

/// Load notifications for the current user
class LoadNotifications extends NotificationEvent {
  const LoadNotifications();
}

/// Listen to real-time notification updates
class SubscribeToNotifications extends NotificationEvent {
  const SubscribeToNotifications();
}

/// Mark a single notification as read
class MarkNotificationAsRead extends NotificationEvent {
  final String notificationId;

  const MarkNotificationAsRead(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

/// Mark all notifications as read
class MarkAllNotificationsAsRead extends NotificationEvent {
  const MarkAllNotificationsAsRead();
}

/// Delete a single notification
class DeleteNotification extends NotificationEvent {
  final String notificationId;

  const DeleteNotification(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

/// Real-time notification received (from stream)
class NotificationReceived extends NotificationEvent {
  final List<dynamic> notifications;

  const NotificationReceived(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

/// Refresh unread count
class RefreshUnreadCount extends NotificationEvent {
  const RefreshUnreadCount();
}
