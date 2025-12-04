import 'package:ate_app/database/database_helper.dart';
import 'package:ate_app/repositories/user_repository.dart';
import 'package:ate_app/repositories/restaurant_repository.dart';
import 'package:ate_app/repositories/post_repository.dart';
import 'package:ate_app/repositories/comment_repository.dart';

/// Quick database validation - verifies seed data was created
class QuickDatabaseValidation {
  static final DatabaseHelper _db = DatabaseHelper.instance;

  /// Run quick validation
  static Future<void> validate() async {
    print('\n🔍 QUICK DATABASE VALIDATION');
    print('=' * 60);

    try {
      // Get table counts
      final tables = [
        'users',
        'restaurants',
        'posts',
        'comments',
        'likes',
        'saved_posts',
        'search_history',
      ];

      print('\n📊 Table Counts:');
      for (final table in tables) {
        final count = await _db.getCount(table);
        final status = count > 0 ? '✅' : '❌';
        print('   $status $table: $count rows');
      }

      // Sample data
      print('\n📋 Sample Data:');

      // Users
      final userRepo = UserRepository();
      final users = await userRepo.getAllUsers();
      if (users.isNotEmpty) {
        print('   👤 Users: ${users.length} total');
        print('      Sample: ${users.first.username} (${users.first.email})');
      }

      // Restaurants
      final restaurantRepo = RestaurantRepository();
      final restaurants = await restaurantRepo.getAllRestaurants();
      if (restaurants.isNotEmpty) {
        print('   🏪 Restaurants: ${restaurants.length} total');
        print('      Sample: ${restaurants.first.name}');
      }

      // Posts
      final postRepo = PostRepository();
      final posts = await postRepo.getAllPosts();
      if (posts.isNotEmpty) {
        print('   📝 Posts: ${posts.length} total');
        print('      Sample: ${posts.first.dishName}');
      }

      // Comments
      final commentRepo = CommentRepository();
      final comments = await commentRepo.getRecentComments(limit: 1);
      if (comments.isNotEmpty) {
        final totalComments = await _db.getCount('comments');
        print('   💬 Comments: $totalComments total');
        print('      Sample: "${comments.first.content}"');
      }

      // Likes
      final totalLikes = await _db.getCount('likes');
      print('   ❤️ Likes: $totalLikes total');

      // Saved Posts
      final totalSaved = await _db.getCount('saved_posts');
      print('   🔖 Saved Posts: $totalSaved total');

      // Search History
      final totalSearches = await _db.getCount('search_history');
      print('   🔍 Search History: $totalSearches total');

      print('\n✅ Database validation completed successfully!');
      print('=' * 60);
    } catch (e) {
      print('\n❌ Validation failed: $e');
      print('=' * 60);
    }
  }
}
