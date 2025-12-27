import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../models/restaurant.dart';
import '../models/post.dart';
import '../models/comment.dart';
import '../repositories/user_repository.dart';
import '../repositories/restaurant_repository.dart';
import '../repositories/post_repository.dart';
import '../repositories/comment_repository.dart';
import '../repositories/like_repository.dart';
import '../repositories/saved_post_repository.dart';
import '../repositories/search_history_repository.dart';
import '../utils/password_helper.dart';

/// Seeds the database with comprehensive test data for development
class SeedData {
  static Future<void> seedDatabase(
    UserRepository userRepository,
    RestaurantRepository restaurantRepository,
    PostRepository postRepository,
    CommentRepository commentRepository,
    LikeRepository likeRepository,
    SavedPostRepository savedPostRepository,
    SearchHistoryRepository searchHistoryRepository,
  ) async {
    try {
      print('🌱 Starting database seeding...');

      // Clear existing data (optional - for fresh start)
      // await _clearDatabase();

      // Seed users
      final users = await _seedUsers(userRepository);
      print('✅ Seeded ${users.length} users');

      // Seed restaurants
      final restaurants = await _seedRestaurants(restaurantRepository);
      print('✅ Seeded ${restaurants.length} restaurants');

      // Seed posts
      final posts = await _seedPosts(postRepository, users, restaurants);
      print('✅ Seeded ${posts.length} posts');

      // Seed comments
      final comments = await _seedComments(commentRepository, users, posts);
      print('✅ Seeded ${comments.length} comments');

      // Seed likes
      final likes = await _seedLikes(likeRepository, users, posts);
      print('✅ Seeded ${likes.length} likes');

      // Seed saved posts
      final savedPosts = await _seedSavedPosts(
        savedPostRepository,
        users,
        posts,
      );
      print('✅ Seeded ${savedPosts.length} saved posts');

      // Seed search history
      final searchHistory = await _seedSearchHistory(
        searchHistoryRepository,
        users,
      );
      print('✅ Seeded ${searchHistory.length} search history entries');

      print('🎉 Database seeding completed successfully!');
    } catch (e) {
      print('❌ Error seeding database: $e');
      rethrow;
    }
  }

  /// Seed users (10-15 test users)
  static Future<List<User>> _seedUsers(UserRepository userRepository) async {
    final List<User> users = [];

    final testUsers = [
      User(
        username: 'testuser',
        email: 'test@ate.com',
        password: PasswordHelper.hashPassword('password123'),
        bio: 'Test user for development',
        points: 100,
        level: 'Bronze',
      ),
      User(
        username: 'Flen',
        email: 'flen@ate.com',
        password: PasswordHelper.hashPassword('flen123'),
        bio: 'Food enthusiast sharing my culinary adventures 🍽️',
        points: 232,
        level: 'Gold',
        profileImage:
            'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800',
      ),
      User(
        username: 'Sarah_Foodie',
        email: 'sarah@ate.com',
        password: PasswordHelper.hashPassword('sarah123'),
        bio: 'Exploring the best food spots in Tunisia 🇹🇳',
        points: 450,
        level: 'Platinum',
        profileImage:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=800',
      ),
      User(
        username: 'Mohamed_Eats',
        email: 'mohamed@ate.com',
        password: PasswordHelper.hashPassword('mohamed123'),
        bio: 'Traditional Tunisian cuisine lover',
        points: 180,
        level: 'Silver',
        profileImage:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800',
      ),
      User(
        username: 'Amira_Chef',
        email: 'amira@ate.com',
        password: PasswordHelper.hashPassword('amira123'),
        bio: 'Home chef | Recipe creator | Food blogger',
        points: 620,
        level: 'Platinum',
        profileImage:
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=800',
      ),
      User(
        username: 'Youssef_Reviews',
        email: 'youssef@ate.com',
        password: PasswordHelper.hashPassword('youssef123'),
        bio: 'Honest food reviews | No filter',
        points: 95,
        level: 'Bronze',
      ),
      User(
        username: 'Leila_Gourmet',
        email: 'leila@ate.com',
        password: PasswordHelper.hashPassword('leila123'),
        bio: 'Fine dining enthusiast | Wine lover 🍷',
        points: 380,
        level: 'Gold',
        profileImage:
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=800',
      ),
      User(
        username: 'Ahmed_Street',
        email: 'ahmed@ate.com',
        password: PasswordHelper.hashPassword('ahmed123'),
        bio: 'Street food explorer | Finding hidden gems',
        points: 210,
        level: 'Silver',
      ),
      User(
        username: 'Nour_Vegan',
        email: 'nour@ate.com',
        password: PasswordHelper.hashPassword('nour123'),
        bio: 'Plant-based food advocate 🌱',
        points: 155,
        level: 'Silver',
        profileImage:
            'https://images.unsplash.com/photo-1489424731084-a5d8b219a5bb?w=800',
      ),
      User(
        username: 'Karim_Desserts',
        email: 'karim@ate.com',
        password: PasswordHelper.hashPassword('karim123'),
        bio: 'Sweet tooth | Dessert hunter 🍰',
        points: 290,
        level: 'Gold',
      ),
    ];

    for (final user in testUsers) {
      final existing = await userRepository.getUserByEmailFirestore(user.email);
      if (existing == null) {
        // Use a mock UID for seeding local data if not using real Firebase Auth
        final mockUid = 'user_${user.username.toLowerCase()}';
        final userToCreate = user.copyWith(uid: mockUid, id: mockUid);
        await userRepository.setUserFirestore(userToCreate);
        users.add(userToCreate);
      } else {
        users.add(existing);
      }
    }

    return users;
  }

  /// Seed restaurants (20+ restaurants)
  static Future<List<Restaurant>> _seedRestaurants(
    RestaurantRepository restaurantRepository,
  ) async {
    final List<Restaurant> restaurants = [];

    // Helper to create GeoPoint from approximation (Tunis area)
    GeoPoint loc(double lat, double lng) => GeoPoint(lat, lng);

    final testRestaurants = [
      Restaurant(
        name: 'Le Baroque',
        location: loc(36.8789, 10.3278),
        address: 'La Marsa, Tunis',
        cuisine: 'French',
        rating: 4.8,
        images: [
          'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800'
        ],
        postsCount: 0,
        description: 'Elegant French dining experience in the heart of La Marsa.',
      ),
      Restaurant(
        name: 'Dar El Jeld',
        location: loc(36.8008, 10.1690),
        address: 'Medina, Tunis',
        cuisine: 'Tunisian',
        rating: 4.9,
        images: [
          'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=800'
        ],
        postsCount: 0,
        description: 'Traditional Tunisian cuisine in a historic palace.',
      ),
      Restaurant(
        name: 'La Closerie',
        location: loc(36.8587, 10.3312),
        address: 'Carthage, Tunis',
        cuisine: 'Mediterranean',
        rating: 4.7,
        images: [
          'https://images.unsplash.com/photo-1551632436-cbf8dd35adfa?w=800'
        ],
        postsCount: 0,
        description: 'Chic Mediterranean restaurant with a lovely garden.',
      ),
      Restaurant(
        name: 'Chez Zeineb',
        location: loc(36.8701, 10.3418),
        address: 'Sidi Bou Said',
        cuisine: 'Tunisian',
        rating: 4.6,
        images: [
          'https://images.unsplash.com/photo-1514933651103-005eec06c04b?w=800'
        ],
        postsCount: 0,
        description: 'Authentic homemade Tunisian dishes.',
      ),
      Restaurant(
        name: 'Villa Didon',
        location: loc(36.8550, 10.3350),
        address: 'Carthage, Tunis',
        cuisine: 'Fine Dining',
        rating: 4.9,
        images: [
          'https://images.unsplash.com/photo-1592861956120-e524fc739696?w=800'
        ],
        postsCount: 0,
        description: 'Luxury dining with a panoramic view of Carthage.',
      ),
      Restaurant(
        name: 'Le Golfe',
        location: loc(36.8189, 10.3061),
        address: 'La Goulette, Tunis',
        cuisine: 'Seafood',
        rating: 4.5,
        images: [
          'https://images.unsplash.com/photo-1559847844-5315695dadae?w=800'
        ],
        postsCount: 0,
        description: 'Fresh seafood by the sea.',
      ),
      Restaurant(
        name: 'Bœuf sur le Toit',
        location: loc(36.8010, 10.1800),
        address: 'Centre Ville, Tunis',
        cuisine: 'Steakhouse',
        rating: 4.6,
        images: [
          'https://images.unsplash.com/photo-1544025162-d76694265947?w=800'
        ],
        postsCount: 0,
        description: 'Premium steakhouse in downtown Tunis.',
      ),
      Restaurant(
        name: 'Salammbo',
        location: loc(36.8400, 10.3200),
        address: 'Carthage, Tunis',
        cuisine: 'Tunisian',
        rating: 4.4,
        images: [
          'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=800'
        ],
        postsCount: 0,
        description: 'Cozy spot for Tunisian classics.',
      ),
      Restaurant(
        name: 'La Villa Bleue',
        location: loc(36.8710, 10.3425),
        address: 'Sidi Bou Said',
        cuisine: 'Mediterranean',
        rating: 4.8,
        images: [
          'https://images.unsplash.com/photo-1466978913421-dad2ebd01d17?w=800'
        ],
        postsCount: 0,
        description: 'Upscale Mediterranean cuisine in a boutique hotel.',
      ),
      Restaurant(
        name: 'El Ali',
        location: loc(36.7990, 10.1700),
        address: 'Medina, Tunis',
        cuisine: 'Tunisian',
        rating: 4.3,
        images: [
          'https://images.unsplash.com/photo-1590846406792-0adc7f938f1d?w=800'
        ],
        postsCount: 0,
        description: 'Cultural café and restaurant in the Medina.',
      ),
      Restaurant(
        name: 'Sushi Box',
        location: loc(36.8350, 10.2300),
        address: 'Les Berges du Lac',
        cuisine: 'Japanese',
        rating: 4.5,
        images: [
          'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=800'
        ],
        postsCount: 0,
        description: 'Fresh sushi and Japanese rolls.',
      ),
      Restaurant(
        name: 'Le Deck',
        location: loc(36.8800, 10.3290),
        address: 'La Marsa, Tunis',
        cuisine: 'International',
        rating: 4.4,
        images: [
          'https://images.unsplash.com/photo-1550966871-3ed3cdb5ed0c?w=800'
        ],
        postsCount: 0,
        description: 'International menu with a relaxed atmosphere.',
      ),
      Restaurant(
        name: 'La Cigale',
        location: loc(36.9100, 10.2700),
        address: 'Gammarth, Tunis',
        cuisine: 'French',
        rating: 4.7,
        images: [
          'https://images.unsplash.com/photo-1537047902294-62a40c20a6ae?w=800'
        ],
        postsCount: 0,
        description: 'Refined French gastronomy.',
      ),
      Restaurant(
        name: 'Dar Hamouda Pacha',
        location: loc(36.7995, 10.1695),
        address: 'Medina, Tunis',
        cuisine: 'Tunisian',
        rating: 4.6,
        images: [
          'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800'
        ],
        postsCount: 0,
        description: 'Dining in a 17th-century palace.',
      ),
      Restaurant(
        name: 'Le Grand Bleu',
        location: loc(36.8200, 10.3070),
        address: 'La Goulette, Tunis',
        cuisine: 'Seafood',
        rating: 4.5,
        images: [
          'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=800'
        ],
        postsCount: 0,
        description: 'Famous for its fish and sea view.',
      ),
      Restaurant(
        name: 'Café des Nattes',
        location: loc(36.8715, 10.3430),
        address: 'Sidi Bou Said',
        cuisine: 'Café',
        rating: 4.2,
        images: [
          'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=800'
        ],
        postsCount: 0,
        description: 'Historic café with traditional vibes.',
      ),
      Restaurant(
        name: 'La Perle',
        location: loc(36.9110, 10.2710),
        address: 'Gammarth, Tunis',
        cuisine: 'Mediterranean',
        rating: 4.6,
        images: [
          'https://images.unsplash.com/photo-1551632436-cbf8dd35adfa?w=800'
        ],
        postsCount: 0,
        description: 'Mediterranean flavors in Gammarth.',
      ),
      Restaurant(
        name: 'Le Pirate',
        location: loc(36.8810, 10.3300),
        address: 'La Marsa, Tunis',
        cuisine: 'Seafood',
        rating: 4.4,
        images: [
          'https://images.unsplash.com/photo-1559847844-5315695dadae?w=800'
        ],
        postsCount: 0,
        description: 'Pirate-themed seafood restaurant.',
      ),
      Restaurant(
        name: 'La Bouillabaisse',
        location: loc(36.8190, 10.3065),
        address: 'La Goulette, Tunis',
        cuisine: 'French',
        rating: 4.7,
        images: [
          'https://images.unsplash.com/photo-1514933651103-005eec06c04b?w=800'
        ],
        postsCount: 0,
        description: 'Specializing in French bouillabaisse and seafood.',
      ),
      Restaurant(
        name: 'Dar Belhadj',
        location: loc(36.8000, 10.1680),
        address: 'Medina, Tunis',
        cuisine: 'Tunisian',
        rating: 4.5,
        images: [
          'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=800'
        ],
        postsCount: 0,
        description: 'Authentic dining in the heart of the Medina.',
      ),
    ];

    for (final restaurant in testRestaurants) {
      final existingList = await restaurantRepository.searchRestaurants(restaurant.name);
      if (existingList.isEmpty) {
        final id = await restaurantRepository.createRestaurant(restaurant);
        final created = await restaurantRepository.getRestaurantById(id);
        if (created != null) restaurants.add(created);
      } else {
        restaurants.add(existingList.first);
      }
    }

    return restaurants;
  }

  /// Seed posts (50+ posts)
  static Future<List<Post>> _seedPosts(
    PostRepository postRepository,
    List<User> users,
    List<Restaurant> restaurants,
  ) async {
    final List<Post> posts = [];

    // Create varied posts with different users and restaurants
    final postData = [
      {
        'caption': 'Amazing couscous! Best I\'ve had in Tunis 🍲',
        'dishName': 'Couscous Royal',
        'rating': 5.0,
        'images':
            '["https://images.unsplash.com/photo-1601050690597-df0568f70950?w=800"]',
      },
      {
        'caption': 'Perfect brick à l\'oeuf for breakfast 🥚',
        'dishName': 'Brick à l\'Oeuf',
        'rating': 4.5,
        'images':
            '["https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800"]',
      },
      {
        'caption': 'The tagine here is incredible! Must try 😍',
        'dishName': 'Lamb Tagine',
        'rating': 5.0,
        'images':
            '["https://images.unsplash.com/photo-1612874742237-6526221588e3?w=800"]',
      },
      {
        'caption': 'Fresh grilled fish by the sea 🐟',
        'dishName': 'Grilled Sea Bass',
        'rating': 4.8,
        'images':
            '["https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=800"]',
      },
      {
        'caption': 'Best mechouia salad in town! 🥗',
        'dishName': 'Mechouia Salad',
        'rating': 4.3,
        'images':
            '["https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=800"]',
      },
      {
        'caption': 'Mouthwatering ojja merguez 🌶️',
        'dishName': 'Ojja Merguez',
        'rating': 4.7,
        'images':
            '["https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800"]',
      },
      {
        'caption': 'Delicious kamounia, perfect spices!',
        'dishName': 'Kamounia',
        'rating': 4.6,
        'images':
            '["https://images.unsplash.com/photo-1574484284002-952d92456975?w=800"]',
      },
      {
        'caption': 'Crispy brik pastilla with a twist 🥐',
        'dishName': 'Brik Pastilla',
        'rating': 4.4,
        'images':
            '["https://images.unsplash.com/photo-1509440159596-0249088772ff?w=800"]',
      },
      {
        'caption': 'The lablabi here warms the soul ❤️',
        'dishName': 'Lablabi',
        'rating': 4.5,
        'images':
            '["https://images.unsplash.com/photo-1547592166-23ac45744acd?w=800"]',
      },
      {
        'caption': 'Perfectly cooked steak frites 🥩',
        'dishName': 'Steak Frites',
        'rating': 4.9,
        'images':
            '["https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800"]',
      },
    ];

    // Create posts with random combinations
    for (int i = 0; i < 50; i++) {
      final data = postData[i % postData.length];
      final user = users[i % users.length];
      final restaurant = restaurants[i % restaurants.length];

      final List<String> images = (json.decode(data['images'] as String) as List)
          .map((e) => e.toString())
          .toList();

      final post = Post(
        id: 'post_$i',
        userId: user.uid!,
        username: user.username,
        caption: data['caption'] as String,
        restaurantId: restaurant.restaurantId,
        dishName: data['dishName'] as String,
        rating: data['rating'] as double,
        images: images,
        likesCount: (i * 7) % 100, // Varied likes count
        commentsCount: (i * 3) % 50, // Varied comments count
        createdAt: DateTime.now().subtract(Duration(days: i ~/ 2)),
      );

      await postRepository.createPost(post);
      posts.add(post);
    }

    return posts;
  }

  /// Seed comments (100+ comments)
  static Future<List<Comment>> _seedComments(
    CommentRepository commentRepository,
    List<User> users,
    List<Post> posts,
  ) async {
    final List<Comment> comments = [];

    final commentTexts = [
      'Looks delicious! 😍',
      'I need to try this!',
      'Best restaurant ever!',
      'How long did you wait?',
      'The presentation is amazing!',
      'Is it spicy?',
      'I went there last week, loved it!',
      'What would you recommend?',
      'This makes me hungry 🤤',
      'Worth the price?',
      'How\'s the service?',
      'Can I get this vegan?',
      'Portion size looks perfect!',
      'I\'m definitely going this weekend',
      'Thanks for the recommendation!',
    ];

    // Create 2-3 comments per post
    for (int i = 0; i < posts.length * 2; i++) {
      final post = posts[i % posts.length];
      final user = users[i % users.length];
      final text = commentTexts[i % commentTexts.length];

      final comment = Comment(
        id: 'comment_$i',
        postId: post.id!,
        userId: user.uid!,
        content: text,
        createdAt: DateTime.now()
            .subtract(Duration(hours: i))
            .toIso8601String(),
      );

      await commentRepository.createComment(comment);
      comments.add(comment);
    }

    return comments;
  }

  /// Seed likes (200+ likes)
  static Future<List<String>> _seedLikes(
    LikeRepository likeRepository,
    List<User> users,
    List<Post> posts,
  ) async {
    final List<String> likeIds = [];

    // Each user likes multiple posts
    for (int i = 0; i < users.length; i++) {
      final user = users[i];
      // Each user likes 20-30 posts
      final likesCount = 20 + (i % 10);

      for (int j = 0; j < likesCount && j < posts.length; j++) {
        final post = posts[(i + j) % posts.length];

        try {
          final lid = 'like_${i}_$j';
          await likeRepository.likePost(user.uid!, post.id!);
          likeIds.add(lid);
        } catch (e) {
          // Skip if duplicate
          continue;
        }
      }
    }

    return likeIds;
  }

  /// Seed saved posts (50+ saved posts)
  static Future<List<String>> _seedSavedPosts(
    SavedPostRepository savedPostRepository,
    List<User> users,
    List<Post> posts,
  ) async {
    final List<String> savedPostIds = [];

    // Each user saves some posts
    for (int i = 0; i < users.length; i++) {
      final user = users[i];
      // Each user saves 5-10 posts
      final savesCount = 5 + (i % 5);

      for (int j = 0; j < savesCount && j < posts.length; j++) {
        final post = posts[(i * 3 + j) % posts.length];

        try {
          final sid = 'save_${i}_$j';
          await savedPostRepository.savePost(
            user.uid!,
            post.id!,
          );
          savedPostIds.add(sid);
        } catch (e) {
          // Skip if duplicate
          continue;
        }
      }
    }

    return savedPostIds;
  }

  /// Seed search history (100+ entries)
  static Future<List<String>> _seedSearchHistory(
    SearchHistoryRepository searchHistoryRepository,
    List<User> users,
  ) async {
    final List<String> searchHistoryIds = [];

    final searchQueries = [
      'couscous',
      'best restaurants',
      'seafood',
      'french cuisine',
      'la marsa',
      'brick',
      'tunisian food',
      'desserts',
      'sushi',
      'mediterranean',
      'pasta',
      'steak',
      'tagine',
      'lablabi',
      'grilled fish',
    ];

    // Each user has search history
    for (int i = 0; i < users.length; i++) {
      final user = users[i];
      // Each user has 10-15 searches
      final searchCount = 10 + (i % 5);

      for (int j = 0; j < searchCount; j++) {
        final query = searchQueries[(i + j) % searchQueries.length];

        await searchHistoryRepository.addSearchQuery(
          user.uid!,
          query,
        );
        searchHistoryIds.add('search_${i}_$j');
      }
    }

    return searchHistoryIds;
  }
}
