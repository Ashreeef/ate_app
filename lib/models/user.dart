class User {
  final int?
  id; // Deprecated - kept for backward compatibility during migration
  final String? uid; // Firebase User ID (primary identifier)
  final String username;
  final String email;
  final String? password; // Deprecated - Firebase Auth handles passwords
  final String? profileImage;
  final String? bio;
  final String? displayName;
  final String? phone;
  final int followersCount;
  final int followingCount;
  final int points;
  final String level;
  final String? createdAt;
  final String? updatedAt;
  
  // Restaurant conversion fields
  final bool isRestaurant;
  final String? restaurantId;

  User({
    this.id,
    this.uid,
    required this.username,
    required this.email,
    this.password,
    this.profileImage,
    this.bio,
    this.displayName,
    this.phone,
    this.followersCount = 0,
    this.followingCount = 0,
    this.points = 0,
    this.level = 'Bronze',
    this.createdAt,
    this.updatedAt,
    this.isRestaurant = false,
    this.restaurantId,
  });

  // Convert User to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'profileImage': profileImage,
      'bio': bio,
      'displayName': displayName,
      'phone': phone,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'points': points,
      'level': level,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isRestaurant': isRestaurant,
      'restaurantId': restaurantId,
    };
  }

  // Create User from Firestore document
  factory User.fromFirestore(Map<String, dynamic> data) {
    return User(
      uid: data['uid'] as String?,
      username: data['username'] as String? ?? '',
      email: data['email'] as String? ?? '',
      profileImage: data['profileImage'] as String?,
      bio: data['bio'] as String?,
      displayName: data['displayName'] as String?,
      phone: data['phone'] as String?,
      followersCount: data['followersCount'] as int? ?? 0,
      followingCount: data['followingCount'] as int? ?? 0,
      points: data['points'] as int? ?? 0,
      level: data['level'] as String? ?? 'Bronze',
      createdAt: data['createdAt'] as String?,
      updatedAt: data['updatedAt'] as String?,
      isRestaurant: data['isRestaurant'] as bool? ?? false,
      restaurantId: data['restaurantId'] as String?,
    );
  }

  // Copy with method for updates
  User copyWith({
    int? id,
    String? uid,
    String? username,
    String? email,
    String? password,
    String? profileImage,
    String? bio,
    String? displayName,
    String? phone,
    int? followersCount,
    int? followingCount,
    int? points,
    String? level,
    String? createdAt,
    String? updatedAt,
    bool? isRestaurant,
    String? restaurantId,
  }) {
    return User(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      profileImage: profileImage ?? this.profileImage,
      bio: bio ?? this.bio,
      displayName: displayName ?? this.displayName,
      phone: phone ?? this.phone,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      points: points ?? this.points,
      level: level ?? this.level,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isRestaurant: isRestaurant ?? this.isRestaurant,
      restaurantId: restaurantId ?? this.restaurantId,
    );
  }

  // Alias for profileImage to match Post model naming convention
  String? get userAvatarUrl => profileImage;

  /// Validate if user can convert to restaurant
  /// Returns true if user is not already a restaurant
  bool canConvertToRestaurant() {
    return !isRestaurant;
  }

  @override
  String toString() {
    return 'User(id: $id, uid: $uid, username: $username, email: $email, displayName: $displayName, followers: $followersCount, following: $followingCount, isRestaurant: $isRestaurant)';
  }
}
