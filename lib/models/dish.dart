import 'package:equatable/equatable.dart';

class Dish extends Equatable {
  final String? id;
  final String name;
  final String? description;
  final double? price;
  final String? imageUrl;
  final double rating;
  final String? category;
  final String restaurantId;
  final String? createdAt;

  const Dish({
    this.id,
    required this.name,
    this.description,
    this.price,
    this.imageUrl,
    this.rating = 0.0,
    this.category,
    required this.restaurantId,
    this.createdAt,
  });

  /// Convert to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'rating': rating,
      'category': category,
      'restaurantId': restaurantId,
      'createdAt': createdAt ?? DateTime.now().toIso8601String(),
    };
  }

  /// Create from Firestore Map
  factory Dish.fromFirestore(Map<String, dynamic> data) {
    return Dish(
      id: data['id'] as String?,
      name: data['name'] as String? ?? '',
      description: data['description'] as String?,
      price: (data['price'] as num?)?.toDouble(),
      imageUrl: data['imageUrl'] as String?,
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      category: data['category'] as String?,
      restaurantId: data['restaurantId'] as String? ?? '',
      createdAt: data['createdAt'] as String?,
    );
  }

  Dish copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    double? rating,
    String? category,
    String? restaurantId,
    String? createdAt,
  }) {
    return Dish(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      category: category ?? this.category,
      restaurantId: restaurantId ?? this.restaurantId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        imageUrl,
        rating,
        category,
        restaurantId,
        createdAt,
      ];
}
