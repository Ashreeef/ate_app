class User {
  final String? id; // Firebase User ID or legacy ID
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
  final List<String> searchKeywords; // For prefix-based search
  final String? createdAt;
  final String? updatedAt;

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
    List<String>? searchKeywords,
    this.createdAt,
    this.updatedAt,
  }) : searchKeywords = searchKeywords ?? _generateSearchKeywords(username, displayName);

  /// Generate search keywords for prefix-based search
  static List<String> _generateSearchKeywords(String username, String? displayName) {
    final keywords = <String>{};
    final usernameLower = username.toLowerCase();
    for (int i = 1; i <= usernameLower.length; i++) {
      keywords.add(usernameLower.substring(0, i));
    }
    if (displayName != null) {
      final displayLower = displayName.toLowerCase();
      for (int i = 1; i <= displayLower.length; i++) {
        keywords.add(displayLower.substring(0, i));
      }
    }
    return keywords.toList();
  }

  // Convert User to Map for database (local SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'profile_image': profileImage,
      'bio': bio,
      'display_name': displayName,
      'phone': phone,
      'followers_count': followersCount,
      'following_count': followingCount,
      'points': points,
      'level': level,
      'created_at': createdAt,
    };
  }

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
      'searchKeywords': searchKeywords,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Create User from Map (local SQLite)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id']?.toString(), // Ensure id is String
      username: map['username'] as String? ?? '',
      email: map['email'] as String? ?? '',
      password: map['password'] as String?,
      profileImage: map['profile_image'] as String?,
      bio: map['bio'] as String?,
      displayName: map['display_name'] as String?,
      phone: map['phone'] as String?,
      followersCount: map['followers_count'] as int? ?? 0,
      followingCount: map['following_count'] as int? ?? 0,
      points: map['points'] as int? ?? 0,
      level: map['level'] as String? ?? 'Bronze',
      createdAt: map['created_at'] as String?,
    );
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
      searchKeywords: (data['searchKeywords'] as List<dynamic>?)?.map((e) => e as String).toList(),
      createdAt: data['createdAt'] as String?,
      updatedAt: data['updatedAt'] as String?,
    );
  }

  // Copy with method for updates
  User copyWith({
    String? id,
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
    List<String>? searchKeywords,
    String? createdAt,
    String? updatedAt,
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
      searchKeywords: searchKeywords ?? this.searchKeywords,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, uid: $uid, username: $username, email: $email, displayName: $displayName, followers: $followersCount, following: $followingCount)';
  }
}
