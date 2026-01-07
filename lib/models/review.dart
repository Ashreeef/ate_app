import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final String? id;
  final String authorId;
  final String authorName;
  final String? authorAvatarUrl;
  final String restaurantId;
  final String? dishId; // Optional, if reviewing a specific dish
  final double rating;
  final String comment;
  final String createdAt;

  const Review({
    this.id,
    required this.authorId,
    required this.authorName,
    this.authorAvatarUrl,
    required this.restaurantId,
    this.dishId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'authorAvatarUrl': authorAvatarUrl,
      'restaurantId': restaurantId,
      'dishId': dishId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt,
    };
  }

  factory Review.fromFirestore(Map<String, dynamic> data) {
    return Review(
      id: data['id'] as String?,
      authorId: data['authorId'] as String? ?? '',
      authorName: data['authorName'] as String? ?? 'Anonymous',
      authorAvatarUrl: data['authorAvatarUrl'] as String?,
      restaurantId: data['restaurantId'] as String? ?? '',
      dishId: data['dishId'] as String?,
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      comment: data['comment'] as String? ?? '',
      createdAt: data['createdAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        authorId,
        authorName,
        authorAvatarUrl,
        restaurantId,
        dishId,
        rating,
        comment,
        createdAt,
      ];
}
