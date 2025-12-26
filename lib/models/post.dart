import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final int? id; // Deprecated - SQLite only
  final String? postId; // Firestore document ID
  final int? userId; // Deprecated - SQLite only
  final String? userUid; // Firebase User UID
  final String username;
  final String? userAvatarPath; // Deprecated - SQLite only
  final String? userAvatarUrl; // Cloudinary URL
  final String caption;
  final int? restaurantId; // Deprecated - SQLite only
  final String? restaurantUid; // Firestore restaurant ID
  final String? restaurantName;
  final String? dishName;
  final double? rating;
  final List<String> images; // Cloudinary URLs
  final int likesCount;
  final int commentsCount;
  final List<int> likedBy; // Deprecated - SQLite only
  final List<String> likedByUids; // Firebase UIDs
  final List<int> savedBy; // Deprecated - SQLite only
  final List<String> savedByUids; // Firebase UIDs
  final DateTime createdAt;
  final DateTime? updatedAt;


  Post({
    this.id,
    this.postId,
    this.userId,
    this.userUid,
    required this.username,
    this.userAvatarPath,
    this.userAvatarUrl,
    required this.caption,
    this.restaurantId,
    this.restaurantUid,
    this.restaurantName,
    this.dishName,
    this.rating,
    required this.images,
    this.likesCount = 0,
    this.commentsCount = 0,
    List<int>? likedBy,
    List<String>? likedByUids,
    List<int>? savedBy,
    List<String>? savedByUids,
    DateTime? createdAt,
    this.updatedAt,
  })  : likedBy = likedBy ?? [],
        likedByUids = likedByUids ?? [],
        savedBy = savedBy ?? [],
        savedByUids = savedByUids ?? [],
        createdAt = createdAt ?? DateTime.now();


  /// Convert Post to Map for Firestore
  Map<String, dynamic> toMapForFirestore() {
    return {
      'postId': postId,
      'userId': userUid,
      'username': username,
      'userAvatarUrl': userAvatarUrl,
      'caption': caption,
      'restaurantId': restaurantUid, // Firestore uses 'restaurantId' key for the UID string
      'restaurantName': restaurantName,
      'dishName': dishName,
      'rating': rating,
      'images': images,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'likedBy': likedByUids,
      'savedBy': savedByUids,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Convert Post to Map for Firestore (legacy name)
  Map<String, dynamic> toFirestore() => toMapForFirestore();

  /// Create Post from Firestore document
  factory Post.fromFirestore(Map<String, dynamic> data) {
    return Post(
      postId: data['postId'] as String?,
      userUid: data['userId'] as String?,
      username: data['username'] as String? ?? '',
      userAvatarUrl: data['userAvatarUrl'] as String?,
      caption: data['caption'] as String? ?? '',
      restaurantUid: data['restaurantId'] as String?,
      restaurantName: data['restaurantName'] as String?,
      dishName: data['dishName'] as String?,
      rating: data['rating'] != null ? (data['rating'] as num).toDouble() : null,
      images: data['images'] != null
          ? List<String>.from(data['images'])
          : [],
      likesCount: data['likesCount'] ?? 0,
      commentsCount: data['commentsCount'] ?? 0,
      likedByUids: data['likedBy'] != null
          ? List<String>.from(data['likedBy'])
          : [],
      savedByUids: data['savedBy'] != null
          ? List<String>.from(data['savedBy'])
          : [],
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'])
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? DateTime.parse(data['updatedAt'])
          : null,
    );
  }


  Post copyWith({
    int? id,
    String? postId,
    int? userId,
    String? userUid,
    String? username,
    String? userAvatarPath,
    String? userAvatarUrl,
    String? caption,
    int? restaurantId,
    String? restaurantUid,
    String? restaurantName,
    String? dishName,
    double? rating,
    List<String>? images,
    int? likesCount,
    int? commentsCount,
    List<int>? likedBy,
    List<String>? likedByUids,
    List<int>? savedBy,
    List<String>? savedByUids,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Post(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      userUid: userUid ?? this.userUid,
      username: username ?? this.username,
      userAvatarPath: userAvatarPath ?? this.userAvatarPath,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      caption: caption ?? this.caption,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantUid: restaurantUid ?? this.restaurantUid,
      restaurantName: restaurantName ?? this.restaurantName,
      dishName: dishName ?? this.dishName,
      rating: rating ?? this.rating,
      images: images ?? this.images,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      likedBy: likedBy ?? this.likedBy,
      likedByUids: likedByUids ?? this.likedByUids,
      savedBy: savedBy ?? this.savedBy,
      savedByUids: savedByUids ?? this.savedByUids,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Post(id: $id, userId: $userId, username: $username, caption: $caption, dishName: $dishName, rating: $rating)';
  }
}