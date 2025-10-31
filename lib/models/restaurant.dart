class Restaurant {
  final String id;
  final String name;
  final String description;
  final String location;
  final String? address;
  final double rating;
  final int reviewCount;
  final String? imageUrl;
  final String? logoUrl;
  final List<String>? images;
  final String? phoneNumber;
  final String? website;
  final List<String>? tags;
  final double? latitude;
  final double? longitude;
  final bool isTrending;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    this.address,
    required this.rating,
    required this.reviewCount,
    this.imageUrl,
    this.logoUrl,
    this.images,
    this.phoneNumber,
    this.website,
    this.tags,
    this.latitude,
    this.longitude,
    this.isTrending = false,
  });

  // Factory constructor for creating from JSON
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      address: json['address'] as String?,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      imageUrl: json['imageUrl'] as String?,
      logoUrl: json['logoUrl'] as String?,
      images: json['images'] != null
          ? List<String>.from(json['images'] as List)
          : null,
      phoneNumber: json['phoneNumber'] as String?,
      website: json['website'] as String?,
      tags: json['tags'] != null
          ? List<String>.from(json['tags'] as List)
          : null,
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      isTrending: json['isTrending'] as bool? ?? false,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location': location,
      'address': address,
      'rating': rating,
      'reviewCount': reviewCount,
      'imageUrl': imageUrl,
      'logoUrl': logoUrl,
      'images': images,
      'phoneNumber': phoneNumber,
      'website': website,
      'tags': tags,
      'latitude': latitude,
      'longitude': longitude,
      'isTrending': isTrending,
    };
  }
}
