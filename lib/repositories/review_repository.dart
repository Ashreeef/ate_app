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
    await _restaurantRepository.recalculateAverageRating(review.restaurantId);
  }

  /// Get reviews for a restaurant
  Future<List<Review>> getReviewsForRestaurant(String restaurantId) async {
    final snapshot = await _reviews
        .where('restaurantId', isEqualTo: restaurantId)
        .limit(20)
        .get();

    final reviews = snapshot.docs
        .map((doc) => Review.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList();

    // Sort in memory to avoid Firestore index requirement for where + orderBy
    reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return reviews;
  }

}
