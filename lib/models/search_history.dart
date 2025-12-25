class SearchHistory {
  final int? id;
  final String userId;
  final String query;
  final String? createdAt;

  SearchHistory({
    this.id,
    required this.userId,
    required this.query,
    this.createdAt,
  });

  /// Convert SearchHistory to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'query': query,
      'created_at': createdAt,
    };
  }

  /// Create SearchHistory from database Map
  factory SearchHistory.fromMap(Map<String, dynamic> map) {
    return SearchHistory(
      id: map['id'] as int?,
      userId: map['user_id']?.toString() ?? '',
      query: map['query'] as String,
      createdAt: map['created_at'] as String?,
    );
  }

  @override
  String toString() {
    return 'SearchHistory(id: $id, userId: $userId, query: $query)';
  }
}
