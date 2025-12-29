import 'package:cloud_firestore/cloud_firestore.dart';

class Like {
  final int? id; // Deprecated - SQLite only
  final int? userId; // Deprecated - SQLite only
  final int? postId; // Deprecated - SQLite only
  final String? userUid; // Firebase User UID
  final String? postUid; // Firestore post ID
  final String? createdAt;

  Like({
    this.id,
    this.userId,
    this.postId,
    this.userUid,
    this.postUid,
    this.createdAt,
  });

  /// Convert Like to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userUid,
      'createdAt': createdAt ?? DateTime.now().toIso8601String(),
    };
  }

  /// Create Like from Firestore document
  factory Like.fromFirestore(Map<String, dynamic> data) {
    return Like(
      userUid: data['userId'] as String?,
      createdAt: data['createdAt'] as String?,
    );
  }

  @override
  String toString() {
    return 'Like(userUid: $userUid, postUid: $postUid, createdAt: $createdAt)';
  }
}
