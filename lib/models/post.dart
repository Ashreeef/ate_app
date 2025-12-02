import 'dart:convert';

class Post {
  int? id;
  String userId;
  String username;
  String? userAvatarPath;
  String caption;
  int? restaurantId;
  String? restaurantName;
  String? dishName;
  double? rating;
  List<String> images; // local file paths
  int likesCount;
  int commentsCount;
  List<String> likedBy; // userIds
  List<String> savedBy; // userIds
  DateTime createdAt;

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
    List<String>? likedBy,
    List<String>? savedBy,
    DateTime? createdAt,
  })  : likedBy = likedBy ?? [],
        savedBy = savedBy ?? [],
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'userAvatarPath': userAvatarPath,
      'caption': caption,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'dishName': dishName,
      'rating': rating,
      'images': jsonEncode(images),
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'likedBy': jsonEncode(likedBy),
      'savedBy': jsonEncode(savedBy),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as int?,
      userId: map['userId'] as String,
      username: map['username'] as String,
      userAvatarPath: map['userAvatarPath'] as String?,
      caption: map['caption'] as String? ?? '',
      restaurantId: map['restaurantId'] as int?,
      restaurantName: map['restaurantName'] as String?,
      dishName: map['dishName'] as String?,
      rating: map['rating'] != null ? (map['rating'] as num).toDouble() : null,
      images: map['images'] != null ? List<String>.from(jsonDecode(map['images'])) : [],
      likesCount: map['likesCount'] ?? 0,
      commentsCount: map['commentsCount'] ?? 0,
      likedBy: map['likedBy'] != null ? List<String>.from(jsonDecode(map['likedBy'])) : [],
      savedBy: map['savedBy'] != null ? List<String>.from(jsonDecode(map['savedBy'])) : [],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
    );
  }
}
