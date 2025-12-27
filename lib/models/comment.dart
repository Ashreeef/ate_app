class Comment {
  final String? id;
  final String postId;
  final String userId;
  final String content;
  final String? createdAt;

  Comment({
    this.id,
    required this.postId,
    required this.userId,
    required this.content,
    this.createdAt,
  });

  /// Convert Comment to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'post_id': postId,
      'user_id': userId,
      'content': content,
      'created_at': createdAt,
    };
  }

  /// Create Comment from database Map
  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id']?.toString(),
      postId: map['post_id']?.toString() ?? '',
      userId: map['user_id']?.toString() ?? '',
      content: map['content'] as String,
      createdAt: map['created_at'] as String?,
    );
  }

  /// Create a copy with updated fields
  Comment copyWith({
    String? id,
    String? postId,
    String? userId,
    String? content,
    String? createdAt,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Comment(id: $id, postId: $postId, userId: $userId, content: $content)';
  }
}
