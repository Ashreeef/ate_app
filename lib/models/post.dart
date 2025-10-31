class Post {
  final String id;
  final String userId;
  final String restaurantId;
  final String? dishId;
  final List<String> imageUrls;
  final String caption;
  final DateTime createdAt;
  final double? rating;
  final int likeCount;
  final int commentCount;

  Post({
    required this.id,
    required this.userId,
    required this.restaurantId,
    this.dishId,
    required this.imageUrls,
    required this.caption,
    required this.createdAt,
    this.rating,
    this.likeCount = 0,
    this.commentCount = 0,
  });

  String? get firstImageUrl => imageUrls.isNotEmpty ? imageUrls.first : null;

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      userId: json['userId'] as String,
      restaurantId: json['restaurantId'] as String,
      dishId: json['dishId'] as String?,
      imageUrls: List<String>.from(json['imageUrls'] as List),
      caption: json['caption'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : null,
      likeCount: json['likeCount'] as int? ?? 0,
      commentCount: json['commentCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'restaurantId': restaurantId,
      'dishId': dishId,
      'imageUrls': imageUrls,
      'caption': caption,
      'createdAt': createdAt.toIso8601String(),
      'rating': rating,
      'likeCount': likeCount,
      'commentCount': commentCount,
    };
  }
}
