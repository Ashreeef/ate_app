class FakeUserData {
  // User identity
  static const String username = 'Flen';
  static const String displayName = 'Flen Fleni';
  static const String email = 'flen.fleni@gmail.com';
  static const String phone = '+213 700 123 456';
  static const String bio =
      'Food enthusiast sharing my culinary adventures 🍽️';

  // Profile stats
  static const String avatarUrl =
      'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800&auto=format&fit=crop&q=80';
  static const int postsCount = 3;
  static const int followersCount = 5;
  static const int followingCount = 19;
  static const String rank = 'Or'; // Gold rank
  static const int points = 232;

  // Fake posts data
  static final List<Map<String, dynamic>> userPosts = [
    {
      'id': '1',
      'imageUrl':
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800&auto=format&fit=crop&q=80',
      'likes': 45,
      'caption': 'Delicious food!',
    },
    {
      'id': '2',
      'imageUrl':
          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&auto=format&fit=crop&q=80',
      'likes': 32,
      'caption': 'Amazing taste!',
    },
    {
      'id': '3',
      'imageUrl':
          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&auto=format&fit=crop&q=80',
      'likes': 27,
      'caption': 'Yummy!',
    },
  ];
}
