class Like {
  final int? id;
  final int userId;
  final int postId;
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
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      postId: map['post_id'] as int,
      createdAt: map['created_at'] as String?,
    );
  }

  @override
  String toString() {
    return 'Like(id: $id, userId: $userId, postId: $postId)';
  }
}
