class User {
  final int? id;
  final String username;
  final String email;
  final String? password;
  final String? profileImage;
  final String? bio;
  final String? displayName;
  final String? phone;
  final int followersCount;
  final int followingCount;
  final int points;
  final String level;
  final String? createdAt;

  User({
    this.id,
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
  });

  // Convert User to Map for database
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

  // Create User from Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
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

  // Copy with method for updates
  User copyWith({
    int? id,
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
  }) {
    return User(
      id: id ?? this.id,
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
    );
  }

  @override
  String toString() {
    return 'User(id: $id, username: $username, email: $email, displayName: $displayName, followers: $followersCount, following: $followingCount)';
  }
}