import 'package:shared_preferences/shared_preferences.dart';
import '../database/database_helper.dart';
import '../models/post.dart';

class DatabaseSeeder {
  static Future<void> seedTestData() async {
    try {
      final db = await DatabaseHelper.instance.database;

      // Clear existing data first to ensure fresh test data
      await db.delete('posts');
      await db.delete('users');
      print('🗑️ Cleared existing database data');

      // Insert test users
      final user1Map = {
        'username': 'amina_food',
        'email': 'amina@example.com',
        'password': 'password123', // Required by schema
        'display_name': 'Amina Test',
        'phone': '+1234567890',
        'bio':
            'Food enthusiast 🍕 | Restaurant explorer 🌮 | Love trying new dishes!',
        'profile_image': 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
        'followers_count': 1250,
        'following_count': 340,
        'points': 2500,
        'level': 'Gold',
      };

      final user2Map = {
        'username': 'chef_omar',
        'email': 'omar@example.com',
        'password': 'password123', // Required by schema
        'display_name': 'Omar Ali',
        'phone': '+1987654321',
        'bio': 'Professional chef 👨‍🍳 | Sharing my culinary adventures',
        'profile_image': 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
        'followers_count': 3200,
        'following_count': 180,
        'points': 5000,
        'level': 'Platinum',
      };

      // Insert users into database
      final userId1 = await db.insert('users', user1Map);
      final userId2 = await db.insert('users', user2Map);

      // Set user1 as the current logged-in user
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('current_user_id', userId1);

      print(' Inserted users: $userId1, $userId2');
      print('Set user1 (ID: $userId1) as current user');

      // Insert test posts for user1
      final post1 = Post(
        userId: userId1,
        caption: 'Best pizza in town! 🍕 The crust was perfectly crispy.',
        dishName: 'Margherita Pizza',
        rating: 4.5,
        images:
            'https://images.unsplash.com/photo-1513104890138-7c749659a591,https://images.unsplash.com/photo-1574071318508-1cdbab80d002',
        likesCount: 45,
        commentsCount: 12,
      );

      final post2 = Post(
        userId: userId1,
        caption: 'Amazing sushi experience! Fresh and delicious 🍣',
        dishName: 'Sushi Platter',
        rating: 5.0,
        images: 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351',
        likesCount: 78,
        commentsCount: 23,
      );

      final post3 = Post(
        userId: userId1,
        caption: 'Burger heaven! 🍔 Juicy and flavorful.',
        dishName: 'Classic Burger',
        rating: 4.0,
        images: 'https://images.unsplash.com/photo-1550547660-d9450f859349',
        likesCount: 34,
        commentsCount: 8,
      );

      // Insert posts for user2
      final post4 = Post(
        userId: userId2,
        caption: 'Homemade pasta perfection 🍝',
        dishName: 'Carbonara',
        rating: 4.8,
        images: 'https://images.unsplash.com/photo-1612874742237-6526221588e3',
        likesCount: 120,
        commentsCount: 35,
      );

      final post5 = Post(
        userId: userId2,
        caption: 'Fresh seafood catch of the day 🦞',
        dishName: 'Grilled Lobster',
        rating: 5.0,
        images: 'https://images.unsplash.com/photo-1559339352-11d035aa65de',
        likesCount: 156,
        commentsCount: 42,
      );

      // Insert posts into database
      await db.insert('posts', post1.toMap());
      await db.insert('posts', post2.toMap());
      await db.insert('posts', post3.toMap());
      await db.insert('posts', post4.toMap());
      await db.insert('posts', post5.toMap());

      print('Inserted 5 test posts');
      print('Database seeding completed successfully!');
    } catch (e, stackTrace) {
      print('Error seeding database: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Clear all data from database
  static Future<void> clearDatabase() async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('posts');
    await db.delete('users');
    print(' Database cleared');
  }

  /// Reset database with fresh test data
  static Future<void> resetDatabase() async {
    await clearDatabase();
    await seedTestData();
  }
}
