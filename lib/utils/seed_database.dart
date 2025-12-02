import 'package:shared_preferences/shared_preferences.dart';
import '../database/database_helper.dart';
import '../models/post.dart';
import 'password_helper.dart';

class DatabaseSeeder {
  static Future<void> seedTestData() async {
    try {
      final db = await DatabaseHelper.instance.database;
      final prefs = await SharedPreferences.getInstance();

      // Check if already seeded
      final seeded = prefs.getBool('database_seeded') ?? false;
      if (seeded) {
        print(' Database already seeded, skipping.');
        return;
      }

      print(' Starting database seeding...');

      // Clear existing data
      await db.delete('posts');
      await db.delete('users');

      // Create User 1
      final user1Map = {
        'username': 'amina_food',
        'email': 'amina@example.com',
        'password': PasswordHelper.hashPassword('password123'),
        'display_name': 'Amina Test',
        'phone': '+1234567890',
        'bio':
            'Food enthusiast 🍕 | Restaurant explorer 🌮 | Love trying new dishes!',
        'profile_image':
            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
        'followers_count': 1250,
        'following_count': 340,
        'points': 2500,
        'level': 'Gold',
      };

      final userId1 = await db.insert('users', user1Map);
      print(' User 1 created with ID: $userId1');

      // Create User 2
      final user2Map = {
        'username': 'chef_omar',
        'email': 'omar@example.com',
        'password': PasswordHelper.hashPassword('password123'),
        'display_name': 'Omar Chef',
        'phone': '+1987654321',
        'bio': 'Professional chef 👨‍🍳 | Sharing my culinary adventures',
        'profile_image':
            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
        'followers_count': 3200,
        'following_count': 180,
        'points': 5000,
        'level': 'Platinum',
      };

      final userId2 = await db.insert('users', user2Map);
      print(' User 2 created with ID: $userId2');

      // Seed posts for Amina (User 1)
      final aminaPosts = [
        Post(
          userId: userId1,
          username: 'amina_food',
          caption: 'Best pizza in town! 🍕 The crust was perfectly crispy.',
          dishName: 'Margherita Pizza',
          rating: 4.5,
          images: [
            'https://images.unsplash.com/photo-1513104890138-7c749659a591',
            'https://images.unsplash.com/photo-1574071318508-1cdbab80d002',
          ],
          likesCount: 45,
          commentsCount: 12,
        ),
        Post(
          userId: userId1,
          username: 'amina_food',
          caption: 'Amazing sushi experience! Fresh and delicious 🍣',
          dishName: 'Sushi Platter',
          rating: 5.0,
          images: [
            'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351',
          ],
          likesCount: 78,
          commentsCount: 23,
        ),
        Post(
          userId: userId1,
          username: 'amina_food',
          caption: 'Burger heaven! 🍔 Juicy and flavorful.',
          dishName: 'Classic Burger',
          rating: 4.0,
          images: ['https://images.unsplash.com/photo-1550547660-d9450f859349'],
          likesCount: 34,
          commentsCount: 8,
        ),
      ];

      // Seed posts for Omar (User 2)
      final omarPosts = [
        Post(
          userId: userId2,
          username: 'chef_omar',
          caption: 'Homemade pasta perfection 🍝',
          dishName: 'Carbonara',
          rating: 4.8,
          images: [
            'https://images.unsplash.com/photo-1612874742237-6526221588e3',
          ],
          likesCount: 120,
          commentsCount: 35,
        ),
        Post(
          userId: userId2,
          username: 'chef_omar',
          caption: 'Fresh seafood catch of the day 🦞',
          dishName: 'Grilled Lobster',
          rating: 5.0,
          images: ['https://images.unsplash.com/photo-1559339352-11d035aa65de'],
          likesCount: 156,
          commentsCount: 42,
        ),
      ];

      // Insert all posts
      for (var post in aminaPosts) {
        await db.insert('posts', post.toMap());
      }
      for (var post in omarPosts) {
        await db.insert('posts', post.toMap());
      }
      print(
        ' All posts seeded (${aminaPosts.length} for Amina, ${omarPosts.length} for Omar)',
      );

      // Set user1 as current
      await prefs.setInt('current_user_id', userId1);
      // Store the second user ID for other profile navigation
      await prefs.setInt('other_user_id', userId2);

      // Mark as seeded
      await prefs.setBool('database_seeded', true);
      print(' Database seeding complete');
      print('   Current user (Amina) ID: $userId1');
      print('   Other user (Omar) ID: $userId2');
    } catch (e, stackTrace) {
      print(' Error seeding database: $e');
      print('Stack trace: $stackTrace');
    }
  }
}
