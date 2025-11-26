class Post {
  final int? id;
  final int userId;
  final String? caption;
  final int? restaurantId;
  final String? dishName;
  final double? rating;
  final String? images; // JSON string of image URLs
  final int likesCount;
  final int commentsCount;
  final String? createdAt;

  Post({
    this.id,
    required this.userId,
    this.caption,
    this.restaurantId,
    this.dishName,
    this.rating,
    this.images,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.createdAt,
  });

  /// Convert Post to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'caption': caption,
      'restaurant_id': restaurantId,
      'dish_name': dishName,
      'rating': rating,
      'images': images,
      'likes_count': likesCount,
      'comments_count': commentsCount,
      'created_at': createdAt,
    };
  }

  /// Create Post from database Map
  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      caption: map['caption'] as String?,
      restaurantId: map['restaurant_id'] as int?,
      dishName: map['dish_name'] as String?,
      rating: map['rating'] as double?,
      images: map['images'] as String?,
      likesCount: map['likes_count'] as int? ?? 0,
      commentsCount: map['comments_count'] as int? ?? 0,
      createdAt: map['created_at'] as String?,
    );
  }

  /// Create a copy with updated fields
  Post copyWith({
    int? id,
    int? userId,
    String? caption,
    int? restaurantId,
    String? dishName,
    double? rating,
    String? images,
    int? likesCount,
    int? commentsCount,
    String? createdAt,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      caption: caption ?? this.caption,
      restaurantId: restaurantId ?? this.restaurantId,
      dishName: dishName ?? this.dishName,
      rating: rating ?? this.rating,
      images: images ?? this.images,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Post(id: $id, userId: $userId, caption: $caption, dishName: $dishName, rating: $rating)';
  }
}
