import 'package:cloud_firestore/cloud_firestore.dart';

/// Restaurant Model
/// Represents a restaurant with Firestore integration
class Restaurant {
  final String? restaurantId; // Firebase document ID
  final String name;
  final String description;
  final String cuisine;
  final GeoPoint location; // Latitude/Longitude for geospatial queries
  final String address;
  final String? phone;
  final double rating;
  final String priceRange; // $ - $$$$
  final List<String> images;
  final Map<String, dynamic> openingHours;
  final int postsCount;
  final List<String> searchKeywords; // For prefix-based search
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Restaurant({
    this.restaurantId,
    required this.name,
    this.description = '',
    required this.cuisine,
    required this.location,
    required this.address,
    this.phone,
    this.rating = 0.0,
    this.priceRange = '\$\$',
    this.images = const [],
    this.openingHours = const {},
    this.postsCount = 0,
    List<String>? searchKeywords,
    this.createdAt,
    this.updatedAt,
  }) : searchKeywords = searchKeywords ?? _generateSearchKeywords(name, cuisine);

  /// Generate search keywords for prefix-based search
  /// Creates lowercase prefixes for name and cuisine
  static List<String> _generateSearchKeywords(String name, String cuisine) {
    final keywords = <String>{};
    
    // Add name prefixes (lowercase)
    final nameLower = name.toLowerCase();
    for (int i = 1; i <= nameLower.length; i++) {
      keywords.add(nameLower.substring(0, i));
    }
    
    // Add cuisine prefixes (lowercase)
    final cuisineLower = cuisine.toLowerCase();
    for (int i = 1; i <= cuisineLower.length; i++) {
      keywords.add(cuisineLower.substring(0, i));
    }
    
    // Add full words
    keywords.add(nameLower);
    keywords.add(cuisineLower);
    
    return keywords.toList();
  }

  /// Convert Restaurant to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'restaurantId': restaurantId,
      'name': name,
      'description': description,
      'cuisine': cuisine,
      'location': location,
      'address': address,
      'phone': phone,
      'rating': rating,
      'priceRange': priceRange,
      'images': images,
      'openingHours': openingHours,
      'postsCount': postsCount,
      'searchKeywords': searchKeywords,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Create Restaurant from Firestore document
  factory Restaurant.fromFirestore(Map<String, dynamic> data) {
    return Restaurant(
      restaurantId: data['restaurantId'] as String?,
      name: data['name'] as String? ?? '',
      description: data['description'] as String? ?? '',
      cuisine: data['cuisine'] as String? ?? '',
      location: data['location'] as GeoPoint? ?? const GeoPoint(0, 0),
      address: data['address'] as String? ?? '',
      phone: data['phone'] as String?,
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      priceRange: data['priceRange'] as String? ?? '\$\$',
      images: (data['images'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      openingHours: data['openingHours'] as Map<String, dynamic>? ?? {},
      postsCount: data['postsCount'] as int? ?? 0,
      searchKeywords: (data['searchKeywords'] as List<dynamic>?)?.map((e) => e as String).toList(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Create a copy with updated fields
  Restaurant copyWith({
    String? restaurantId,
    String? name,
    String? description,
    String? cuisine,
    GeoPoint? location,
    String? address,
    String? phone,
    double? rating,
    String? priceRange,
    List<String>? images,
    Map<String, dynamic>? openingHours,
    int? postsCount,
    List<String>? searchKeywords,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Restaurant(
      restaurantId: restaurantId ?? this.restaurantId,
      name: name ?? this.name,
      description: description ?? this.description,
      cuisine: cuisine ?? this.cuisine,
      location: location ?? this.location,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      rating: rating ?? this.rating,
      priceRange: priceRange ?? this.priceRange,
      images: images ?? this.images,
      openingHours: openingHours ?? this.openingHours,
      postsCount: postsCount ?? this.postsCount,
      searchKeywords: searchKeywords ?? this.searchKeywords,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Compatibility getters for legacy code
  /// `imageUrl` returns the first image when available
  String? get imageUrl => images.isNotEmpty ? images.first : null;

  /// Legacy alias for `cuisine`
  String? get cuisineType => cuisine;

  /// Human-friendly location string for UI (legacy `location` usage)
  String get locationName => address;

  @override
  String toString() {
    return 'Restaurant(id: $restaurantId, name: $name, cuisine: $cuisine, address: $address, rating: $rating)';
  }

  /// Legacy SQLite-compatible map representation used by some tests
  Map<String, dynamic> toMap() {
    return {
      'restaurant_id': restaurantId,
      'name': name,
      'location': address,
      'cuisine_type': cuisine,
      'rating': rating,
      'image_url': imageUrl,
      'posts_count': postsCount,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Restaurant && other.restaurantId == restaurantId;
  }

  @override
  int get hashCode => restaurantId.hashCode;
}
