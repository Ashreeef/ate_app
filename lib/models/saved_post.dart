class SavedPost {
  final String? id;
  final String userId;
  final String postId;
  final String? createdAt;

  SavedPost({
    this.id,
    required this.userId,
    required this.postId,
    this.createdAt,
  });

  /// Convert SavedPost to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'post_id': postId,
      'created_at': createdAt,
    };
  }

  /// Create SavedPost from database Map
  factory SavedPost.fromMap(Map<String, dynamic> map) {
    return SavedPost(
      id: map['id']?.toString(),
      userId: map['user_id']?.toString() ?? '',
      postId: map['post_id']?.toString() ?? '',
      createdAt: map['created_at'] as String?,
    );
  }

  @override
  String toString() {
    return 'SavedPost(id: $id, userId: $userId, postId: $postId)';
  }
}
