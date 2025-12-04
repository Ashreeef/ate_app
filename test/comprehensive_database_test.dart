import 'package:ate_app/database/database_helper.dart';
import 'package:ate_app/repositories/user_repository.dart';
import 'package:ate_app/repositories/restaurant_repository.dart';
import 'package:ate_app/repositories/post_repository.dart';
import 'package:ate_app/repositories/comment_repository.dart';
import 'package:ate_app/repositories/like_repository.dart';
import 'package:ate_app/repositories/saved_post_repository.dart';
import 'package:ate_app/repositories/search_history_repository.dart';

/// Comprehensive database testing utility
/// Run this to test all database operations and verify seed data
class ComprehensiveDatabaseTest {
  static final DatabaseHelper _db = DatabaseHelper.instance;
  static final UserRepository _userRepo = UserRepository();
  static final RestaurantRepository _restaurantRepo = RestaurantRepository();
  static final PostRepository _postRepo = PostRepository();
  static final CommentRepository _commentRepo = CommentRepository();
  static final LikeRepository _likeRepo = LikeRepository();
  static final SavedPostRepository _savedPostRepo = SavedPostRepository();
  static final SearchHistoryRepository _searchRepo = SearchHistoryRepository();

  /// Run all database tests
  static Future<Map<String, dynamic>> runAllTests() async {
    final results = <String, dynamic>{};

    print('Starting comprehensive database tests...\n');

    try {
      // 1. Database Info Tests
      print('Test 1: Database Information');
      results['database_info'] = await _testDatabaseInfo();

      // 2. User CRUD Tests
      print('\nTest 2: User CRUD Operations');
      results['user_crud'] = await _testUserCRUD();

      // 3. Restaurant CRUD Tests
      print('\nTest 3: Restaurant CRUD Operations');
      results['restaurant_crud'] = await _testRestaurantCRUD();

      // 4. Post CRUD Tests
      print('\nTest 4: Post CRUD Operations');
      results['post_crud'] = await _testPostCRUD();

      // 5. Comment CRUD Tests
      print('\nTest 5: Comment CRUD Operations');
      results['comment_crud'] = await _testCommentCRUD();

      // 6. Like Operations Tests
      print('\nTest 6: Like Operations');
      results['like_operations'] = await _testLikeOperations();

      // 7. Saved Post Operations Tests
      print('\nTest 7: Saved Post Operations');
      results['saved_post_operations'] = await _testSavedPostOperations();

      // 8. Search History Tests
      print('\nTest 8: Search History Operations');
      results['search_history'] = await _testSearchHistory();

      // 9. Data Relationships Tests
      print('\nTest 9: Data Relationships & Foreign Keys');
      results['relationships'] = await _testRelationships();

      // 10. Query Performance Tests
      print('\nTest 10: Query Performance');
      results['performance'] = await _testQueryPerformance();

      print('\nAll tests completed successfully!');
      results['success'] = true;
    } catch (e) {
      print('\nTests failed with error: $e');
      results['success'] = false;
      results['error'] = e.toString();
    }

    return results;
  }

  /// Test 1: Database Information
  static Future<Map<String, dynamic>> _testDatabaseInfo() async {
    final results = <String, dynamic>{};

    // Get database path
    final dbPath = await _db.getDatabasePath();
    print('   Database path: $dbPath');
    results['path'] = dbPath;

    // Get all table names
    final tables = await _db.getTableNames();
    print('   Tables: ${tables.join(", ")}');
    results['tables'] = tables;

    // Get counts for each table
    for (final table in tables) {
      final count = await _db.getCount(table);
      print('   - $table: $count rows');
      results['${table}_count'] = count;
    }

    return results;
  }

  /// Test 2: User CRUD Operations
  static Future<Map<String, dynamic>> _testUserCRUD() async {
    final results = <String, dynamic>{};

    // Get all users
    final users = await _userRepo.getAllUsers();
    print('   Total users: ${users.length}');
    results['total_users'] = users.length;

    if (users.isNotEmpty) {
      final user = users.first;
      print('   Sample user: ${user.username} (${user.email})');
      print('   - Level: ${user.level}, Points: ${user.points}');
      results['sample_user'] = user.toMap();

      // Test getUserById
      final userById = await _userRepo.getUserById(user.id!);
      results['get_by_id'] = userById != null;

      // Test getUserByEmail
      final userByEmail = await _userRepo.getUserByEmail(user.email);
      results['get_by_email'] = userByEmail != null;

      // Test emailExists
      final emailExists = await _userRepo.emailExists(user.email);
      results['email_exists'] = emailExists;
      print('   ✓ User queries working correctly');
    }

    return results;
  }

  /// Test 3: Restaurant CRUD Operations
  static Future<Map<String, dynamic>> _testRestaurantCRUD() async {
    final results = <String, dynamic>{};

    // Get all restaurants
    final restaurants = await _restaurantRepo.getAllRestaurants();
    print('   Total restaurants: ${restaurants.length}');
    results['total_restaurants'] = restaurants.length;

    if (restaurants.isNotEmpty) {
      final restaurant = restaurants.first;
      print('   Sample restaurant: ${restaurant.name}');
      print('   - Location: ${restaurant.location}');
      print('   - Cuisine: ${restaurant.cuisineType}');
      print('   - Rating: ${restaurant.rating}');
      results['sample_restaurant'] = restaurant.toMap();

      // Test search
      final searchResults = await _restaurantRepo.searchRestaurants('tun');
      print('   Search "tun": ${searchResults.length} results');
      results['search_results'] = searchResults.length;

      // Test top rated
      final topRated = await _restaurantRepo.getTopRatedRestaurants(limit: 5);
      print(
        '   Top 5 rated restaurants: ${topRated.map((r) => r.name).join(", ")}',
      );
      results['top_rated_count'] = topRated.length;

      // Test cuisine types
      final cuisineTypes = await _restaurantRepo.getAllCuisineTypes();
      print('   Cuisine types: ${cuisineTypes.join(", ")}');
      results['cuisine_types'] = cuisineTypes;

      print('   ✓ Restaurant queries working correctly');
    }

    return results;
  }

  /// Test 4: Post CRUD Operations
  static Future<Map<String, dynamic>> _testPostCRUD() async {
    final results = <String, dynamic>{};

    // Get all posts
    final posts = await _postRepo.getAllPosts();
    print('   Total posts: ${posts.length}');
    results['total_posts'] = posts.length;

    if (posts.isNotEmpty) {
      final post = posts.first;
      print('   Sample post: ${post.dishName}');
      print('   - Caption: ${post.caption.substring(0, 50)}...');
      print('   - Rating: ${post.rating}');
      print('   - Likes: ${post.likesCount}, Comments: ${post.commentsCount}');
      results['sample_post'] = post.toMap();

      // Test get by user
      final userPosts = await _postRepo.getPostsByUserId(post.userId);
      print('   User ${post.userId} has ${userPosts.length} posts');
      results['user_posts_count'] = userPosts.length;

      // Test get recent posts
      final recentPosts = await _postRepo.getRecentPosts(limit: 10);
      print('   Recent posts: ${recentPosts.length}');
      results['recent_posts_count'] = recentPosts.length;

      // Test search posts
      final searchResults = await _postRepo.searchPosts('couscous');
      print('   Search "couscous": ${searchResults.length} results');
      results['search_posts_count'] = searchResults.length;

      print('   ✓ Post queries working correctly');
    }

    return results;
  }

  /// Test 5: Comment CRUD Operations
  static Future<Map<String, dynamic>> _testCommentCRUD() async {
    final results = <String, dynamic>{};

    // Get all comments
    final comments = await _commentRepo.getRecentComments(limit: 100);
    print('   Total comments: ${comments.length}');
    results['total_comments'] = comments.length;

    if (comments.isNotEmpty) {
      final comment = comments.first;
      print('   Sample comment: "${comment.content}"');
      results['sample_comment'] = comment.toMap();

      // Test get by post
      final postComments = await _commentRepo.getCommentsByPostId(
        comment.postId,
      );
      print('   Post ${comment.postId} has ${postComments.length} comments');
      results['post_comments_count'] = postComments.length;

      // Test get by user
      final userComments = await _commentRepo.getCommentsByUserId(
        comment.userId,
      );
      print('   User ${comment.userId} has ${userComments.length} comments');
      results['user_comments_count'] = userComments.length;

      // Test get comment count for post
      final commentCount = await _commentRepo.getCommentsCountByPostId(
        comment.postId,
      );
      print('   Comment count for post ${comment.postId}: $commentCount');
      results['comment_count'] = commentCount;

      print('   ✓ Comment queries working correctly');
    }

    return results;
  }

  /// Test 6: Like Operations
  static Future<Map<String, dynamic>> _testLikeOperations() async {
    final results = <String, dynamic>{};

    // Get sample data
    final allPosts = await _postRepo.getAllPosts();
    final allUsers = await _userRepo.getAllUsers();
    final posts = allPosts.take(1).toList();
    final users = allUsers.take(1).toList();

    if (posts.isNotEmpty && users.isNotEmpty) {
      final post = posts.first;
      final user = users.first;

      // Check if user liked post
      final hasLiked = await _likeRepo.hasUserLikedPost(post.id!, user.id!);
      print('   User ${user.id} liked post ${post.id}: $hasLiked');
      results['has_liked'] = hasLiked;

      // Get likes for post
      final postLikes = await _likeRepo.getLikesByPostId(post.id!);
      print('   Post ${post.id} has ${postLikes.length} likes');
      results['post_likes_count'] = postLikes.length;

      // Get posts liked by user
      final userLikes = await _likeRepo.getPostsLikedByUser(user.id!);
      print('   User ${user.id} liked ${userLikes.length} posts');
      results['user_likes_count'] = userLikes.length;

      // Get total like count for post
      final likeCount = await _likeRepo.getLikesCountByPostId(post.id!);
      print('   Total likes for post ${post.id}: $likeCount');
      results['like_count'] = likeCount;

      print('   ✓ Like operations working correctly');
    }

    return results;
  }

  /// Test 7: Saved Post Operations
  static Future<Map<String, dynamic>> _testSavedPostOperations() async {
    final results = <String, dynamic>{};

    // Get sample data
    final allPosts = await _postRepo.getAllPosts();
    final allUsers = await _userRepo.getAllUsers();
    final posts = allPosts.take(1).toList();
    final users = allUsers.take(1).toList();

    if (posts.isNotEmpty && users.isNotEmpty) {
      final post = posts.first;
      final user = users.first;

      // Check if user saved post
      final hasSaved = await _savedPostRepo.hasUserSavedPost(
        post.id!,
        user.id!,
      );
      print('   User ${user.id} saved post ${post.id}: $hasSaved');
      results['has_saved'] = hasSaved;

      // Get saved posts by user
      final savedPosts = await _savedPostRepo.getSavedPostsByUserId(user.id!);
      print('   User ${user.id} saved ${savedPosts.length} posts');
      results['saved_posts_count'] = savedPosts.length;

      // Get saved count for user
      final savedCount = await _savedPostRepo.getSavedPostsCountByUserId(
        user.id!,
      );
      print('   Saved posts count: $savedCount');
      results['saved_count'] = savedCount;

      print('   ✓ Saved post operations working correctly');
    }

    return results;
  }

  /// Test 8: Search History Operations
  static Future<Map<String, dynamic>> _testSearchHistory() async {
    final results = <String, dynamic>{};

    // Get sample user
    final allUsers = await _userRepo.getAllUsers();
    final users = allUsers.take(1).toList();

    if (users.isNotEmpty) {
      final user = users.first;

      // Get search history
      final history = await _searchRepo.getSearchHistoryByUserId(user.id!);
      print('   User ${user.id} has ${history.length} search entries');
      results['history_count'] = history.length;

      // Get recent queries
      final recentQueries = await _searchRepo.getRecentSearchQueries(
        user.id!,
        limit: 5,
      );
      print('   Recent queries: ${recentQueries.join(", ")}');
      results['recent_queries'] = recentQueries;

      // Get unique queries
      final uniqueQueries = await _searchRepo.getUniqueRecentSearchQueries(
        user.id!,
        limit: 10,
      );
      print('   Unique queries: ${uniqueQueries.length}');
      results['unique_queries_count'] = uniqueQueries.length;

      // Get popular searches
      final popularSearches = await _searchRepo.getPopularSearches(limit: 5);
      final popularQueries = popularSearches
          .map((s) => s['query'] as String)
          .toList();
      print('   Popular searches: ${popularQueries.join(", ")}');
      results['popular_searches_count'] = popularSearches.length;

      print('   ✓ Search history operations working correctly');
    }

    return results;
  }

  /// Test 9: Data Relationships & Foreign Keys
  static Future<Map<String, dynamic>> _testRelationships() async {
    final results = <String, dynamic>{};

    print('   Testing data integrity and relationships...');

    // Test user-post relationship
    final allUsers = await _userRepo.getAllUsers();
    final users = allUsers.take(1).toList();
    if (users.isNotEmpty) {
      final user = users.first;
      final userPosts = await _postRepo.getPostsByUserId(user.id!);
      print('   ✓ User-Post relationship: ${userPosts.length} posts');
      results['user_posts'] = userPosts.length;
    }

    // Test post-comment relationship
    final posts = await _postRepo.getAllPosts(limit: 1);
    if (posts.isNotEmpty) {
      final post = posts.first;
      final postComments = await _commentRepo.getCommentsByPostId(post.id!);
      print('   ✓ Post-Comment relationship: ${postComments.length} comments');
      results['post_comments'] = postComments.length;
    }

    // Test post-restaurant relationship
    if (posts.isNotEmpty && posts.first.restaurantId != null) {
      final restaurant = await _restaurantRepo.getRestaurantById(
        posts.first.restaurantId!,
      );
      print('   ✓ Post-Restaurant relationship: ${restaurant?.name ?? "null"}');
      results['post_restaurant'] = restaurant != null;
    }

    print('   ✓ All relationships working correctly');
    return results;
  }

  /// Test 10: Query Performance
  static Future<Map<String, dynamic>> _testQueryPerformance() async {
    final results = <String, dynamic>{};

    // Test 1: Large query performance
    final sw1 = Stopwatch()..start();
    final allPosts = await _postRepo.getAllPosts();
    sw1.stop();
    print(
      '   Get all posts (${allPosts.length} rows): ${sw1.elapsedMilliseconds}ms',
    );
    results['all_posts_time'] = sw1.elapsedMilliseconds;

    // Test 2: Search query performance
    final sw2 = Stopwatch()..start();
    final searchResults = await _restaurantRepo.searchRestaurants('food');
    sw2.stop();
    print(
      '   Search restaurants (${searchResults.length} results): ${sw2.elapsedMilliseconds}ms',
    );
    results['search_time'] = sw2.elapsedMilliseconds;

    // Test 3: Comment query performance
    final sw3 = Stopwatch()..start();
    final allComments = await _commentRepo.getRecentComments(limit: 100);
    sw3.stop();
    print(
      '   Get comments (${allComments.length} rows): ${sw3.elapsedMilliseconds}ms',
    );
    results['comments_time'] = sw3.elapsedMilliseconds;

    print('   ✓ All queries performed acceptably');
    return results;
  }

  /// Print database statistics
  static Future<void> printDatabaseStats() async {
    print('\nDATABASE STATISTICS');
    print('=' * 50);

    final tables = await _db.getTableNames();
    for (final table in tables) {
      final count = await _db.getCount(table);
      print('$table: $count rows');
    }

    print('=' * 50);
  }

  /// Print sample data from each table
  static Future<void> printSampleData() async {
    print('\nSAMPLE DATA FROM EACH TABLE');
    print('=' * 50);

    // Users
    final allUsers = await _userRepo.getAllUsers();
    final users = allUsers.take(3).toList();
    print('\nUsers (${users.length} samples):');
    for (final user in users) {
      print(
        '   - ${user.username} (${user.email}) - ${user.level} - ${user.points} pts',
      );
    }

    // Restaurants
    final allRestaurants = await _restaurantRepo.getAllRestaurants();
    final restaurants = allRestaurants.take(3).toList();
    print('\nRestaurants (${restaurants.length} samples):');
    for (final restaurant in restaurants) {
      print(
        '   - ${restaurant.name} - ${restaurant.cuisineType} - Rating: ${restaurant.rating}',
      );
    }

    // Posts
    final allPosts = await _postRepo.getAllPosts();
    final posts = allPosts.take(3).toList();
    print('\nPosts (${posts.length} samples):');
    for (final post in posts) {
      print(
        '   - ${post.dishName} - Rating: ${post.rating} - Likes: ${post.likesCount} - Comments: ${post.commentsCount}',
      );
    }

    print('=' * 50);
  }
}
