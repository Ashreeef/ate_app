import '../models/user.dart';
import '../repositories/user_repository.dart';

/// Seeds the database with test data for development
class SeedData {
  static Future<void> seedDatabase(UserRepository userRepository) async {
    try {
      // Check if test user already exists
      final existingUser = await userRepository.getUserByEmail('test@ate.com');

      if (existingUser == null) {
        // Create test user
        final testUser = User(
          username: 'testuser',
          email: 'test@ate.com',
          password: 'password123', // In production, this would be hashed
          bio: 'Test user for development',
          points: 100,
          level: 'Bronze',
        );

        await userRepository.createUser(testUser);
        print('✅ Test user created: email=test@ate.com, password=password123');
      } else {
        print('ℹ️ Test user already exists');
      }

      // Create another test user
      final existingUser2 = await userRepository.getUserByEmail('flen@ate.com');

      if (existingUser2 == null) {
        final testUser2 = User(
          username: 'Flen',
          email: 'flen@ate.com',
          password: 'flen123',
          bio: 'Food enthusiast sharing my culinary adventures 🍽️',
          points: 232,
          level: 'Gold',
          profileImage:
              'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800&auto=format&fit=crop&q=80',
        );

        await userRepository.createUser(testUser2);
        print('✅ Test user 2 created: email=flen@ate.com, password=flen123');
      } else {
        print('ℹ️ Test user 2 already exists');
      }
    } catch (e) {
      print('❌ Error seeding database: $e');
    }
  }
}
