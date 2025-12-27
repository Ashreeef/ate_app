class AppNotification {
  final String? id;
  final String userId;
  final String title;
  final String body;
  final String? imageUrl;
  final Map<String, dynamic> data; // Payload data (e.g., postId, type)
  final DateTime createdAt;
  final bool isRead;

  AppNotification({
    this.id,
    required this.userId,
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
      'user_id': userId,
      'title': title,
      'body': body,
      'image_url': imageUrl,
      'data': data, // Will be stored as JSON string
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead ? 1 : 0,
    };
  }

  // Create from Map from database
  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      id: map['id']?.toString(),
      userId: map['user_id']?.toString() ?? '',
      title: map['title'] as String,
      body: map['body'] as String,
      imageUrl: map['image_url'] as String?,
      data: map['data'] as Map<String, dynamic>? ?? {},
      createdAt: DateTime.parse(map['created_at'] as String),
      isRead: (map['is_read'] as int?) == 1,
    );
  }

  // Copy with method
  AppNotification copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    String? imageUrl,
    Map<String, dynamic>? data,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return AppNotification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
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
      'AppNotification(id: $id, userId: $userId, title: $title, body: $body, isRead: $isRead)';
}
