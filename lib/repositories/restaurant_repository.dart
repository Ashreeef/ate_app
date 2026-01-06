import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/restaurant.dart';
import '../models/dish.dart';
import '../services/error_service.dart';

/// Repository for Restaurant data operations - Firestore Version
class RestaurantRepository {
  final CollectionReference _restaurants = FirebaseFirestore.instance.collection('restaurants');

  // ==================== CREATE ====================

  /// Create a new restaurant (used by seeding or admin)
  Future<void> createRestaurant(Restaurant restaurant) async {
    final docRef = _restaurants.doc(restaurant.id);
    await docRef.set(restaurant.toFirestore());
  }

  /// Add a new dish for a restaurant
  Future<String> addDish(Dish dish) async {
    final docRef = _restaurants.doc(dish.restaurantId).collection('dishes').doc();
    // Ensure the ID is set in the document data
    final dishData = dish.toFirestore();
    dishData['id'] = docRef.id;
    
    // Add createdAt if missing
    if (dish.createdAt == null) {
      dishData['createdAt'] = DateTime.now().toIso8601String();
    }
    
    await docRef.set(dishData);
    return docRef.id;
  }

  // ==================== READ ====================

  /// Get a restaurant by ID (UID)
  Future<Restaurant?> getRestaurantById(String id) async {
    final doc = await _restaurants.doc(id).get();
    if (!doc.exists) return null;
    return Restaurant.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
  }

  /// Get dishes for a restaurant
  Future<List<Dish>> getDishesForRestaurant(String restaurantId) async {
    try {
      final snapshot = await _restaurants
          .doc(restaurantId)
          .collection('dishes')
          .orderBy('rating', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Dish.fromFirestore(doc.data()))
          .toList();
    } catch (e, stackTrace) {
      ErrorService().logError(
        e,
        stackTrace,
        context: 'RestaurantRepository.getDishesForRestaurant',
      );
      return [];
    }
  }

  /// Get all restaurants
  Future<List<Restaurant>> getAllRestaurants({int limit = 50}) async {
    final snapshot = await _restaurants
        .orderBy('name')
        .limit(limit)
        .get();
    return snapshot.docs
        .map((doc) => Restaurant.fromFirestore(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// Search restaurants by name
  /// Note: Firestore doesn't support full-text search. Using a prefix search for now.
  Future<List<Restaurant>> searchRestaurants(String query) async {
    if (query.isEmpty) return [];
    
    final lowerQuery = query.toLowerCase();
    
    // Simple prefix search using lowercase searchName field
    final snapshot = await _restaurants
        .where('searchName', isGreaterThanOrEqualTo: lowerQuery)
        .where('searchName', isLessThanOrEqualTo: '$lowerQuery\uf8ff')
        .limit(20)
        .get();
        
    return snapshot.docs
        .map((doc) => Restaurant.fromFirestore(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// Get top rated restaurants
  Future<List<Restaurant>> getTopRatedRestaurants({int limit = 10}) async {
    final snapshot = await _restaurants
        .orderBy('rating', descending: true)
        .limit(limit)
        .get();
    return snapshot.docs
        .map((doc) => Restaurant.fromFirestore(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// Get restaurant by name (case-sensitive exact match)
  Future<Restaurant?> getRestaurantByName(String name) async {
    final snapshot = await _restaurants.where('name', isEqualTo: name).limit(1).get();
    if (snapshot.docs.isEmpty) return null;
    final doc = snapshot.docs.first;
    return Restaurant.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
  }

  /// Get trending restaurants (most posts)
  Future<List<Restaurant>> getTrendingRestaurants({int limit = 10}) async {
    final snapshot = await _restaurants
        .orderBy('postsCount', descending: true)
        .limit(limit)
        .get();
    return snapshot.docs
        .map((doc) => Restaurant.fromFirestore(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  // ==================== UPDATE ====================

  /// Update restaurant rating
  Future<void> updateRating(String restaurantId, double newRating) async {
    await _restaurants.doc(restaurantId).update({
      'rating': newRating,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  /// Update restaurant details
  Future<void> updateRestaurant(Restaurant restaurant) async {
    if (restaurant.id == null) {
      throw Exception('Restaurant ID is required for update');
    }
    
    final data = restaurant.toFirestore();
    data['updatedAt'] = DateTime.now().toIso8601String();
    
    // Ensure searchName is updated if name changes
    data['searchName'] = restaurant.name.toLowerCase();

    await _restaurants.doc(restaurant.id).update(data);
  }

  /// Update a dish
  Future<void> updateDish(Dish dish) async {
    if (dish.id == null) {
      throw Exception('Dish ID is required for update');
    }
    
    await _restaurants
        .doc(dish.restaurantId)
        .collection('dishes')
        .doc(dish.id)
        .update(dish.toFirestore());
  }

  /// Delete a dish
  Future<void> deleteDish(String restaurantId, String dishId) async {
    await _restaurants
        .doc(restaurantId)
        .collection('dishes')
        .doc(dishId)
        .delete();
  }

  /// Increment posts count
  Future<void> incrementPostsCount(String restaurantId) async {
    await _restaurants.doc(restaurantId).update({
      'postsCount': FieldValue.increment(1),
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  /// Decrement posts count
  Future<void> decrementPostsCount(String restaurantId) async {
    await _restaurants.doc(restaurantId).update({
      'postsCount': FieldValue.increment(-1),
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  // ==================== DELETE ====================

  /// Delete a restaurant (Admin only usually)
  Future<void> deleteRestaurant(String id) async {
    await _restaurants.doc(id).delete();
  }
}
