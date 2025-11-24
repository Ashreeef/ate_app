class Post {
  final int? id;
  final int userId;
  final String? caption;
  final int? restaurantId;
  final String? dishName;
  final double? rating;
  final String? images; // JSON string of image paths
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

  List<String> getImageList() {
    if (images == null || images!.isEmpty) return [];
    // Parse JSON list
    try {
      return images!.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    } catch (_) {
      return [];
    }
  }
}
