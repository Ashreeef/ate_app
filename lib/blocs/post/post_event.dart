import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

/// Event to create a new post with Cloudinary image upload
class CreatePostEvent extends PostEvent {
  final String userUid;
  final String username;
  final String? userAvatarUrl;
  final String caption;
  final List<File> imageFiles; // Local files to upload
  final String? restaurantUid;
  final String? restaurantName;
  final String? dishName;
  final double? rating;

  const CreatePostEvent({
    required this.userUid,
    required this.username,
    required this.userAvatarUrl,
    required this.caption,
    required this.imageFiles,
    this.restaurantUid,
    this.restaurantName,
    this.dishName,
    this.rating,
  });

  @override
  List<Object?> get props => [
        userUid,
        username,
        userAvatarUrl,
        caption,
        imageFiles,
        restaurantUid,
        restaurantName,
        dishName,
        rating,
      ];
}

/// Event to toggle like on a post
class ToggleLikeEvent extends PostEvent {
  final String postId; // Firestore post ID
  final String userUid; // Firebase user UID
  final bool isLiked; // Current like status

  const ToggleLikeEvent({
    required this.postId,
    required this.userUid,
    required this.isLiked,
  });

  @override
  List<Object?> get props => [postId, userUid, isLiked];
}

/// Event to toggle save on a post
class ToggleSaveEvent extends PostEvent {
  final String postId; // Firestore post ID
  final String userUid; // Firebase user UID
  final bool isSaved; // Current save status

  const ToggleSaveEvent({
    required this.postId,
    required this.userUid,
    required this.isSaved,
  });

  @override
  List<Object?> get props => [postId, userUid, isSaved];
}

/// Event to delete a post
class DeletePostEvent extends PostEvent {
  final String postId;

  const DeletePostEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}
