import '../database/database_helper.dart';
import '../models/restaurant.dart';

/// Repository for Restaurant data operations
class RestaurantRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  // ==================== CREATE ====================

  /// Create a new restaurant
  Future<int> createRestaurant(Restaurant restaurant) async {
    return await _db.insert('restaurants', restaurant.toMap());
  }

  /// Create multiple restaurants in batch
  Future<void> createRestaurants(List<Restaurant> restaurants) async {
    final maps = restaurants.map((r) => r.toMap()).toList();
    await _db.insertBatch('restaurants', maps);
  }

  // ==================== READ ====================

  /// Get a restaurant by ID
  Future<Restaurant?> getRestaurantById(int id) async {
    final map = await _db.queryOne(
      'restaurants',
      where: 'id = ?',
      whereArgs: [id],
    );
    return map != null ? Restaurant.fromMap(map) : null;
  }

  /// Get all restaurants
  Future<List<Restaurant>> getAllRestaurants({
    String? orderBy = 'name ASC',
    int? limit,
  }) async {
    final maps = await _db.query('restaurants', orderBy: orderBy, limit: limit);
    return maps.map((map) => Restaurant.fromMap(map)).toList();
  }

  /// Search restaurants by name or location
  Future<List<Restaurant>> searchRestaurants(String query) async {
    final maps = await _db.rawQuery(
      '''
      SELECT * FROM restaurants 
      WHERE name LIKE ? OR location LIKE ? OR cuisine_type LIKE ?
      ORDER BY name ASC
    ''',
      ['%$query%', '%$query%', '%$query%'],
    );
    return maps.map((map) => Restaurant.fromMap(map)).toList();
  }

  /// Get restaurants by cuisine type
  Future<List<Restaurant>> getRestaurantsByCuisine(String cuisineType) async {
    final maps = await _db.query(
      'restaurants',
      where: 'cuisine_type = ?',
      whereArgs: [cuisineType],
      orderBy: 'name ASC',
    );
    return maps.map((map) => Restaurant.fromMap(map)).toList();
  }

  /// Get restaurants by location
  Future<List<Restaurant>> getRestaurantsByLocation(String location) async {
    final maps = await _db.query(
      'restaurants',
      where: 'location LIKE ?',
      whereArgs: ['%$location%'],
      orderBy: 'name ASC',
    );
    return maps.map((map) => Restaurant.fromMap(map)).toList();
  }

  /// Get top rated restaurants
  Future<List<Restaurant>> getTopRatedRestaurants({int limit = 10}) async {
    final maps = await _db.query(
      'restaurants',
      orderBy: 'rating DESC',
      limit: limit,
    );
    return maps.map((map) => Restaurant.fromMap(map)).toList();
  }

  /// Get trending restaurants (most posts)
  Future<List<Restaurant>> getTrendingRestaurants({int limit = 10}) async {
    final maps = await _db.query(
      'restaurants',
      orderBy: 'posts_count DESC',
      limit: limit,
    );
    return maps.map((map) => Restaurant.fromMap(map)).toList();
  }

  /// Get restaurant by name (exact match)
  Future<Restaurant?> getRestaurantByName(String name) async {
    final map = await _db.queryOne(
      'restaurants',
      where: 'name = ?',
      whereArgs: [name],
    );
    return map != null ? Restaurant.fromMap(map) : null;
  }

  // ==================== UPDATE ====================

  /// Update a restaurant
  Future<int> updateRestaurant(Restaurant restaurant) async {
    return await _db.update(
      'restaurants',
      restaurant.toMap(),
      where: 'id = ?',
      whereArgs: [restaurant.id],
    );
  }

  /// Increment posts count
  Future<void> incrementPostsCount(int restaurantId) async {
    await _db.rawUpdate(
      'UPDATE restaurants SET posts_count = posts_count + 1 WHERE id = ?',
      [restaurantId],
    );
  }

  /// Decrement posts count
  Future<void> decrementPostsCount(int restaurantId) async {
    await _db.rawUpdate(
      'UPDATE restaurants SET posts_count = posts_count - 1 WHERE id = ? AND posts_count > 0',
      [restaurantId],
    );
  }

  /// Update restaurant rating
  Future<void> updateRating(int restaurantId, double newRating) async {
    await _db.update(
      'restaurants',
      {'rating': newRating},
      where: 'id = ?',
      whereArgs: [restaurantId],
    );
  }

  // ==================== DELETE ====================

  /// Delete a restaurant by ID
  Future<int> deleteRestaurant(int id) async {
    return await _db.delete('restaurants', where: 'id = ?', whereArgs: [id]);
  }

  // ==================== UTILITY ====================

  /// Check if a restaurant exists
  Future<bool> restaurantExists(int id) async {
    return await _db.exists('restaurants', where: 'id = ?', whereArgs: [id]);
  }

  /// Check if a restaurant exists by name
  Future<bool> restaurantExistsByName(String name) async {
    return await _db.exists(
      'restaurants',
      where: 'name = ?',
      whereArgs: [name],
    );
  }

  /// Get total restaurants count
  Future<int> getTotalRestaurantsCount() async {
    return await _db.getCount('restaurants');
  }

  /// Get all unique cuisine types
  Future<List<String>> getAllCuisineTypes() async {
    final maps = await _db.rawQuery('''
      SELECT DISTINCT cuisine_type FROM restaurants 
      WHERE cuisine_type IS NOT NULL 
      ORDER BY cuisine_type ASC
    ''');
    return maps.map((map) => map['cuisine_type'] as String).toList();
  }

  /// Get all unique locations
  Future<List<String>> getAllLocations() async {
    final maps = await _db.rawQuery('''
      SELECT DISTINCT location FROM restaurants 
      WHERE location IS NOT NULL 
      ORDER BY location ASC
    ''');
    return maps.map((map) => map['location'] as String).toList();
  }
}
