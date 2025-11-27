class User {
  final int? id;
  final String? displayName;
  final String username;
  final String email;
  final String? phone;
  final String? profileImage;
  final String? bio;
  final int followersCount;
  final int followingCount;
  final int points;
  final String level; // rank (Bronze, Silver, Gold, etc.)

  User({
    this.id,
    this.displayName,
    required this.username,
    required this.email,
    this.phone,
    this.profileImage,
    this.bio,
    this.followersCount = 0,
    this.followingCount = 0,
    this.points = 0,
    this.level = 'Bronze',
  });

  factory User.fromMap(Map<String, dynamic> m) {
    return User(
      id: m['id'] as int?,
      username: m['username'] as String? ?? '',
      email: m['email'] as String? ?? '',
      profileImage: m['profile_image'] as String?,
      bio: m['bio'] as String?,
      displayName: m['display_name'] as String?,
      phone: m['phone'] as String?,
      followersCount: m['followers_count'] as int? ?? 0,
      followingCount: m['following_count'] as int? ?? 0,
      points: m['points'] as int? ?? 0,
      level: m['level'] as String? ?? 'Bronze',
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'username': username,
      'email': email,
      'profile_image': profileImage,
      'bio': bio,
      'display_name': displayName,
      'phone': phone,
      'followers_count': followersCount,
      'following_count': followingCount,
      'points': points,
      'level': level,
    };
    if (id != null) map['id'] = id;
    return map;
  }
}
