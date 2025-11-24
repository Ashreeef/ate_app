class User {
  final int? id;
  final String? displayName;
  final String username;
  final String email;
  final String? phone;
  final String? profileImage;
  final String? bio;

  User({
    this.id,
    this.displayName,
    required this.username,
    required this.email,
    this.phone,
    this.profileImage,
    this.bio,
  });

  factory User.fromMap(Map<String, dynamic> m) {
    return User(
      id: m['id'] as int?,
      username: m['username'] as String? ?? '',
      email: m['email'] as String? ?? '',
      profileImage: m['profile_image'] as String?,
      bio: m['bio'] as String?,
      // displayName and phone may not be present in DB
      displayName: m['display_name'] as String?,
      phone: m['phone'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'username': username,
      'email': email,
      'profile_image': profileImage,
      'bio': bio,
    };
    if (id != null) map['id'] = id;
    if (displayName != null) map['display_name'] = displayName;
    if (phone != null) map['phone'] = phone;
    return map;
  }
}
