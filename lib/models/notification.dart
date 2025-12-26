import 'package:cloud_firestore/cloud_firestore.dart';

class AppNotification {
  final String? id;
  final String userUid;
  final String title;
  final String body;
  final String? imageUrl;
  final Map<String, dynamic> data; // Payload data (e.g., postId, type)
  final DateTime createdAt;
  final bool isRead;

  AppNotification({
    this.id,
    required this.userUid,
    required this.title,
    required this.body,
    this.imageUrl,
    required this.data,
    required this.createdAt,
    this.isRead = false,
  });

  // Convert to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_uid': userUid,
      'title': title,
      'body': body,
      'image_url': imageUrl,
      'data': data, // Will be stored as JSON string
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead ? 1 : 0,
    };
  }

  // Firestore serialization
  Map<String, dynamic> toFirestore() {
    return {
      'userUid': userUid,
      'title': title,
      'body': body,
      'imageUrl': imageUrl,
      'data': data,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
    };
  }

  factory AppNotification.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppNotification(
      id: doc.id,
      userUid: data['userUid'] ?? '',
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      imageUrl: data['imageUrl'],
      data: data['data'] ?? {},
      createdAt: DateTime.parse(data['createdAt'] ?? DateTime.now().toIso8601String()),
      isRead: data['isRead'] ?? false,
    );
  }

  // Copy with method
  AppNotification copyWith({
    String? id,
    String? userUid,
    String? title,
    String? body,
    String? imageUrl,
    Map<String, dynamic>? data,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return AppNotification(
      id: id ?? this.id,
      userUid: userUid ?? this.userUid,
      title: title ?? this.title,
      body: body ?? this.body,
      imageUrl: imageUrl ?? this.imageUrl,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  String toString() =>
      'AppNotification(id: $id, userUid: $userUid, title: $title, body: $body, isRead: $isRead)';
}
