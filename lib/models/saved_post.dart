class SavedPost {
  final int? id;
  final int userId;
  final int postId;
  final String? createdAt;

  SavedPost({
    this.id,
    required this.userId,
    required this.postId,
    this.createdAt,
  });

  @override
  String toString() {
    return 'SavedPost(id: $id, userId: $userId, postId: $postId)';
  }
}
