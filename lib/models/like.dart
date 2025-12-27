class Like {
  final String? id;
  final String userId;
  final String postId;
  final String? createdAt;

  Like({this.id, required this.userId, required this.postId, this.createdAt});

  /// Convert Like to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'post_id': postId,
      'created_at': createdAt,
    };
  }

  /// Create Like from database Map
  factory Like.fromMap(Map<String, dynamic> map) {
    return Like(
      id: map['id']?.toString(),
      userId: map['user_id']?.toString() ?? '',
      postId: map['post_id']?.toString() ?? '',
      createdAt: map['created_at'] as String?,
    );
  }

  @override
  String toString() {
    return 'Like(id: $id, userId: $userId, postId: $postId)';
  }
}
