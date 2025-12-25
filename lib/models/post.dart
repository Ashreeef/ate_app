import 'dart:convert';

class Post {
  final int? id;
  final int userId;
  final String username;
  final String? userAvatarPath;
  final String caption;
  final String? restaurantId;
  final String? restaurantName;
  final String? dishName;
  final double? rating;
  final List<String> images;
  final int likesCount;
  final int commentsCount;
  final List<int> likedBy;
  final List<int> savedBy;
  final DateTime createdAt;

  Post({
    this.id,
    required this.userId,
    required this.username,
    this.userAvatarPath,
    required this.caption,
    this.restaurantId,
    this.restaurantName,
    this.dishName,
    this.rating,
    required this.images,
    this.likesCount = 0,
    this.commentsCount = 0,
    List<int>? likedBy,
    List<int>? savedBy,
    DateTime? createdAt,
  })  : likedBy = likedBy ?? [],
        savedBy = savedBy ?? [],
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'username': username,
      'user_avatar_path': userAvatarPath,
      'caption': caption,
      'restaurant_id': restaurantId,
      'restaurant_name': restaurantName,
      'dish_name': dishName,
      'rating': rating,
      'images': jsonEncode(images),
      'likes_count': likesCount,
      'comments_count': commentsCount,
      'liked_by': jsonEncode(likedBy),
      'saved_by': jsonEncode(savedBy),
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      username: map['username'] as String? ?? '',
      userAvatarPath: map['user_avatar_path'] as String?,
      caption: map['caption'] as String? ?? '',
      restaurantId: map['restaurant_id']?.toString(), // Convert int from SQLite to String
      restaurantName: map['restaurant_name'] as String?,
      restaurantName: map['restaurant_name'] as String?,
      dishName: map['dish_name'] as String?,
      rating: map['rating'] != null ? (map['rating'] as num).toDouble() : null,
      images: map['images'] != null
          ? List<String>.from(jsonDecode(map['images']))
          : [],
      likesCount: map['likes_count'] ?? 0,
      commentsCount: map['comments_count'] ?? 0,
      likedBy: map['liked_by'] != null
          ? List<int>.from(jsonDecode(map['liked_by']))
          : [],
      savedBy: map['saved_by'] != null
          ? List<int>.from(jsonDecode(map['saved_by']))
          : [],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
    );
  }

  Post copyWith({
    int? id,
    int? userId,
    String? username,
    String? userAvatarPath,
    String? caption,
    String? restaurantId,
    String? restaurantName,
    String? dishName,
    double? rating,
    List<String>? images,
    int? likesCount,
    int? commentsCount,
    List<int>? likedBy,
    List<int>? savedBy,
    DateTime? createdAt,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userAvatarPath: userAvatarPath ?? this.userAvatarPath,
      caption: caption ?? this.caption,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      dishName: dishName ?? this.dishName,
      rating: rating ?? this.rating,
      images: images ?? this.images,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      likedBy: likedBy ?? this.likedBy,
      savedBy: savedBy ?? this.savedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Post(id: $id, userId: $userId, username: $username, caption: $caption, dishName: $dishName, rating: $rating)';
  }
}