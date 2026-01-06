import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review.dart';
import 'restaurant_repository.dart';

class ReviewRepository {
  final CollectionReference _reviews =
      FirebaseFirestore.instance.collection('reviews');
  final RestaurantRepository _restaurantRepository;

  ReviewRepository({
    required RestaurantRepository restaurantRepository,
  }) : _restaurantRepository = restaurantRepository;

  /// Add a new review
  Future<void> addReview(Review review) async {
    final docRef = _reviews.doc();
    final reviewData = review.toFirestore();
    reviewData['id'] = docRef.id;
    
    await docRef.set(reviewData);

    // Update Restaurant average rating
    // NOTE: This is a simplified approach. For production, use Cloud Functions or distributed counters.
    await _updateRestaurantRating(review.restaurantId, review.rating);
  }

  /// Get reviews for a restaurant
  Future<List<Review>> getReviewsForRestaurant(String restaurantId) async {
    final snapshot = await _reviews
        .where('restaurantId', isEqualTo: restaurantId)
        .orderBy('createdAt', descending: true)
        .limit(20)
        .get();

    return snapshot.docs
        .map((doc) => Review.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// Recalculate and update restaurant rating
  Future<void> _updateRestaurantRating(String restaurantId, double newRating) async {
    // Fetch current rating and count from Restaurant (need to ensure Restaurant model has reviewCount)
    // For now, let's just fetch all reviews and average them (inefficient but accurate for small scale)
    
    final snapshot = await _reviews.where('restaurantId', isEqualTo: restaurantId).get();
    
    if (snapshot.docs.isEmpty) return;
    
    double totalRating = 0;
    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      totalRating += (data['rating'] as num?)?.toDouble() ?? 0.0;
    }
    
    final average = totalRating / snapshot.docs.length;
    
    // Update restaurant
    await _restaurantRepository.updateRating(restaurantId, average);
  }
}
