import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  final String? id; // UID in Firestore
  final int? legacyId; // Keep for backward compatibility if needed
  final String name;
  final String? searchName; // Lowercase name for case-insensitive search
  final String? location;
  final String? cuisineType;
  final double rating;
  final String? imageUrl;
  final int postsCount;
  final String? createdAt;
  final String? updatedAt;
  final bool isClaimed;
  final String? ownerId;
  final String? hours;
  final String? description;
  final double? latitude;
  final double? longitude;

  Restaurant({
    this.id,
    this.legacyId,
    required this.name,
    this.searchName,
    this.location,
    this.cuisineType,
    this.rating = 0.0,
    this.imageUrl,
    this.postsCount = 0,
    this.createdAt,
    this.updatedAt,
    this.isClaimed = false,
    this.ownerId,
    this.hours,
    this.description,
    this.latitude,
    this.longitude,
  });

  /// Convert Restaurant to Map for SQLite database
  Map<String, dynamic> toMap() {
    return {
      'id': legacyId,
      'name': name,
      'location': location,
      'cuisine_type': cuisineType,
      'rating': rating,
      'image_url': imageUrl,
      'posts_count': postsCount,
      'created_at': createdAt,
    };
  }

  /// Convert Restaurant to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'searchName': searchName ?? name.toLowerCase(),
      'location': location,
      'cuisineType': cuisineType,
      'rating': rating,
      'imageUrl': imageUrl,
      'postsCount': postsCount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isClaimed': isClaimed,
      'ownerId': ownerId,
      'hours': hours,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  /// Create Restaurant from Firestore Map
  factory Restaurant.fromFirestore(String id, Map<String, dynamic> data) {
    // Handle location which might be a String or GeoPoint
    String? locationString;
    final locationData = data['location'];
    if (locationData is String) {
      locationString = locationData;
    } else if (locationData is GeoPoint) {
      // Convert GeoPoint to readable string format
      locationString = '${locationData.latitude}, ${locationData.longitude}';
    }

    // Helper to convert Timestamp or String to String
    String? toStringValue(dynamic value) {
      if (value == null) return null;
      if (value is String) return value;
      if (value is Timestamp) return value.toDate().toIso8601String();
      return null;
    }

    return Restaurant(
      id: id,
      name: data['name'] as String? ?? '',
      searchName: data['searchName'] as String?,
      location: locationString,
      cuisineType: data['cuisineType'] as String?,
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      imageUrl: data['imageUrl'] as String?,
      postsCount: data['postsCount'] as int? ?? 0,
      createdAt: toStringValue(data['createdAt']),
      updatedAt: toStringValue(data['updatedAt']),
      isClaimed: data['isClaimed'] as bool? ?? false,
      ownerId: data['ownerId'] as String?,
      hours: data['hours'] as String?,
      description: data['description'] as String?,
      latitude: (data['latitude'] as num?)?.toDouble(),
      longitude: (data['longitude'] as num?)?.toDouble(),
    );
  }

  /// Create a copy with updated fields
  Restaurant copyWith({
    String? id,
    int? legacyId,
    String? name,
    String? searchName,
    String? location,
    String? cuisineType,
    double? rating,
    String? imageUrl,
    int? postsCount,
    String? createdAt,
    String? updatedAt,
    bool? isClaimed,
    String? ownerId,
    String? hours,
    String? description,
  }) {
    return Restaurant(
      id: id ?? this.id,
      legacyId: legacyId ?? this.legacyId,
      name: name ?? this.name,
      searchName: searchName ?? this.searchName,
      location: location ?? this.location,
      cuisineType: cuisineType ?? this.cuisineType,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
      postsCount: postsCount ?? this.postsCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isClaimed: isClaimed ?? this.isClaimed,
      ownerId: ownerId ?? this.ownerId,
      hours: hours ?? this.hours,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  String toString() {
    return 'Restaurant(id: $id, name: $name, location: $location, rating: $rating, isClaimed: $isClaimed)';
  }
}
