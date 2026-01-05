import 'package:cloud_firestore/cloud_firestore.dart';

/// Notification types supported in the app
enum NotificationType {
  follow, // User follows another user
  like, // User likes a post
  comment, // User comments on a post
}

/// Extension for NotificationType serialization
extension NotificationTypeExtension on NotificationType {
  String get value {
    switch (this) {
      case NotificationType.follow:
        return 'follow';
      case NotificationType.like:
        return 'like';
      case NotificationType.comment:
        return 'comment';
    }
  }

  static NotificationType fromString(String value) {
    switch (value) {
      case 'follow':
        return NotificationType.follow;
      case 'like':
        return NotificationType.like;
      case 'comment':
        return NotificationType.comment;
      default:
        return NotificationType.follow;
    }
  }
}

class AppNotification {
  final String? id;
  final String userUid; // Recipient user ID
  final NotificationType type; // Type of notification
  final String title;
  final String body;
  final String? imageUrl;

  // Actor information (who triggered the notification)
  final String actorUid;
  final String actorUsername;
  final String? actorProfileImage;

  // Related data
  final String? postId; // For like and comment notifications
  final String? targetUserId; // For follow notifications

  final DateTime createdAt;
  final bool isRead;

  AppNotification({
    this.id,
    required this.userUid,
    required this.type,
    required this.title,
    required this.body,
    this.imageUrl,
    required this.actorUid,
    required this.actorUsername,
    this.actorProfileImage,
    this.postId,
    this.targetUserId,
    required this.createdAt,
    this.isRead = false,
  });

  /// Legacy data field for backward compatibility
  Map<String, dynamic> get data => {
    'type': type.value,
    'actorUid': actorUid,
    'actorUsername': actorUsername,
    'actorProfileImage': actorProfileImage,
    'postId': postId,
    'targetUserId': targetUserId,
  };

  // Firestore serialization
  Map<String, dynamic> toFirestore() {
    return {
      'userUid': userUid,
      'type': type.value,
      'title': title,
      'body': body,
      'imageUrl': imageUrl,
      'actorUid': actorUid,
      'actorUsername': actorUsername,
      'actorProfileImage': actorProfileImage,
      'postId': postId,
      'targetUserId': targetUserId,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
    };
  }

  factory AppNotification.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppNotification(
      id: doc.id,
      userUid: data['userUid'] ?? '',
      type: NotificationTypeExtension.fromString(data['type'] ?? 'follow'),
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      imageUrl: data['imageUrl'],
      actorUid: data['actorUid'] ?? '',
      actorUsername: data['actorUsername'] ?? '',
      actorProfileImage: data['actorProfileImage'],
      postId: data['postId'],
      targetUserId: data['targetUserId'],
      createdAt: DateTime.parse(
        data['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      isRead: data['isRead'] ?? false,
    );
  }

  // Copy with method
  AppNotification copyWith({
    String? id,
    String? userUid,
    NotificationType? type,
    String? title,
    String? body,
    String? imageUrl,
    String? actorUid,
    String? actorUsername,
    String? actorProfileImage,
    String? postId,
    String? targetUserId,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return AppNotification(
      id: id ?? this.id,
      userUid: userUid ?? this.userUid,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      imageUrl: imageUrl ?? this.imageUrl,
      actorUid: actorUid ?? this.actorUid,
      actorUsername: actorUsername ?? this.actorUsername,
      actorProfileImage: actorProfileImage ?? this.actorProfileImage,
      postId: postId ?? this.postId,
      targetUserId: targetUserId ?? this.targetUserId,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  String toString() =>
      'AppNotification(id: $id, type: ${type.value}, userUid: $userUid, title: $title, body: $body, isRead: $isRead)';
}
