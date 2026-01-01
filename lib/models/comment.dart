class Comment {
  final int? id; // Deprecated - SQLite only
  final String? commentId; // Firestore document ID
  final int? postId; // Deprecated - SQLite only
  final String? postUid; // Firestore post ID
  final int? userId; // Deprecated - SQLite only
  final String? userUid; // Firebase User UID
  final String? username; // Denormalized for display
  final String? userAvatarUrl; // Cloudinary URL for display
  final String content;
  final String? createdAt;

  Comment({
    this.id,
    this.commentId,
    this.postId,
    this.postUid,
    this.userId,
    this.userUid,
    this.username,
    this.userAvatarUrl,
    required this.content,
    this.createdAt,
  });

  /// Convert Comment to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'commentId': commentId,
      'postId': postUid,
      'userId': userUid,
      'username': username,
      'userAvatarUrl': userAvatarUrl,
      'content': content,
      'createdAt': createdAt,
    };
  }

  /// Create Comment from Firestore document
  factory Comment.fromFirestore(Map<String, dynamic> data) {
    return Comment(
      commentId: data['commentId'] as String?,
      postUid: data['postId'] as String?,
      userUid: data['userId'] as String?,
      username: data['username'] as String?,
      userAvatarUrl: data['userAvatarUrl'] as String?,
      content: data['content'] as String? ?? '',
      createdAt: data['createdAt'] as String?,
    );
  }

  /// Create a copy with updated fields
  Comment copyWith({
    int? id,
    String? commentId,
    int? postId,
    String? postUid,
    int? userId,
    String? userUid,
    String? username,
    String? userAvatarUrl,
    String? content,
    String? createdAt,
  }) {
    return Comment(
      id: id ?? this.id,
      commentId: commentId ?? this.commentId,
      postId: postId ?? this.postId,
      postUid: postUid ?? this.postUid,
      userId: userId ?? this.userId,
      userUid: userUid ?? this.userUid,
      username: username ?? this.username,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Comment(id: $id, postId: $postId, userId: $userId, content: $content)';
  }
}
