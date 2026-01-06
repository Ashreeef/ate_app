import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../models/restaurant.dart';
import '../repositories/user_repository.dart';
import '../repositories/restaurant_repository.dart';

/// Service for converting a regular user account to a restaurant account
/// This is a one-way conversion that cannot be reversed
class RestaurantConversionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserRepository _userRepository;
  final RestaurantRepository _restaurantRepository;

  RestaurantConversionService({
    required UserRepository userRepository,
    required RestaurantRepository restaurantRepository,
  })  : _userRepository = userRepository,
        _restaurantRepository = restaurantRepository;

  /// Convert a user account to a restaurant account
  /// 
  /// This operation:
  /// 1. Validates the user can be converted
  /// 2. Creates a new restaurant document
  /// 3. Updates the user document with restaurant info
  /// 
  /// Uses a Firestore transaction to ensure atomicity
  /// 
  /// Returns the created restaurant ID on success
  /// Throws an exception on failure
  Future<String> convertUserToRestaurant({
    required String userId,
    required String restaurantName,
    required String cuisineType,
    required String location,
    String? hours,
    String? description,
    String? imageUrl,
  }) async {
    try {
      // 1. Fetch current user data
      final user = await _userRepository.getUserById(userId);
      
      if (user == null) {
        throw Exception('User not found');
      }

      // 2. Validate user can be converted
      if (!user.canConvertToRestaurant()) {
        throw Exception('User is already a restaurant account');
      }

      // 3. Validate required restaurant data
      if (restaurantName.trim().isEmpty) {
        throw Exception('Restaurant name is required');
      }
      
      if (cuisineType.trim().isEmpty) {
        throw Exception('Cuisine type is required');
      }
      
      if (location.trim().isEmpty) {
        throw Exception('Location is required');
      }

      // 4. Use Firestore transaction for atomicity
      final String restaurantId = await _firestore.runTransaction<String>(
        (transaction) async {
          // Create restaurant document reference
          final restaurantRef = _firestore.collection('restaurants').doc();
          final restaurantId = restaurantRef.id;
          
          final now = DateTime.now().toIso8601String();

          // Create restaurant data
          final restaurant = Restaurant(
            id: restaurantId,
            name: restaurantName,
            searchName: restaurantName.toLowerCase(),
            location: location,
            cuisineType: cuisineType,
            rating: 0.0,
            imageUrl: imageUrl,
            postsCount: 0,
            createdAt: now,
            updatedAt: now,
          );

          // Create restaurant document in transaction
          transaction.set(restaurantRef, restaurant.toFirestore());

          // Update user document in transaction
          final userRef = _firestore.collection('users').doc(userId);
          transaction.update(userRef, {
            'isRestaurant': true,
            'restaurantId': restaurantId,
            'updatedAt': now,
          });

          return restaurantId;
        },
      );

      return restaurantId;
    } catch (e) {
      throw Exception('Failed to convert user to restaurant: ${e.toString()}');
    }
  }

  /// Check if a user can be converted to a restaurant
  /// Returns a validation result with error message if invalid
  Future<ValidationResult> validateConversion(String userId) async {
    try {
      final user = await _userRepository.getUserById(userId);
      
      if (user == null) {
        return ValidationResult(
          isValid: false,
          errorMessage: 'User not found',
        );
      }

      if (!user.canConvertToRestaurant()) {
        return ValidationResult(
          isValid: false,
          errorMessage: 'This account is already a restaurant',
        );
      }

      return ValidationResult(isValid: true);
    } catch (e) {
      return ValidationResult(
        isValid: false,
        errorMessage: 'Validation error: ${e.toString()}',
      );
    }
  }
}

/// Result of validation check
class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  ValidationResult({
    required this.isValid,
    this.errorMessage,
  });
}
