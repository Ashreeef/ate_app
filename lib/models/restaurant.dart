class Restaurant {
  final int? id;
  final String name;
  final String? location;
  final String? cuisineType;
  final double rating;
  final String? imageUrl;
  final int postsCount;
  final String? createdAt;

  Restaurant({
    this.id,
    required this.name,
    this.location,
    this.cuisineType,
    this.rating = 0.0,
    this.imageUrl,
    this.postsCount = 0,
    this.createdAt,
  });

  /// Convert Restaurant to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'cuisine_type': cuisineType,
      'rating': rating,
      'image_url': imageUrl,
      'posts_count': postsCount,
      'created_at': createdAt,
    };
  }

  /// Create Restaurant from database Map
  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      id: map['id'] as int?,
      name: map['name'] as String,
      location: map['location'] as String?,
      cuisineType: map['cuisine_type'] as String?,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      imageUrl: map['image_url'] as String?,
      postsCount: map['posts_count'] as int? ?? 0,
      createdAt: map['created_at'] as String?,
    );
  }

  /// Create a copy with updated fields
  Restaurant copyWith({
    int? id,
    String? name,
    String? location,
    String? cuisineType,
    double? rating,
    String? imageUrl,
    int? postsCount,
    String? createdAt,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      cuisineType: cuisineType ?? this.cuisineType,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
      postsCount: postsCount ?? this.postsCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Restaurant(id: $id, name: $name, location: $location, rating: $rating)';
  }
}
