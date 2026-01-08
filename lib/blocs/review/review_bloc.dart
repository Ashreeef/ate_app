import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/review_repository.dart';
import 'review_event.dart';
import 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository _reviewRepository;

  ReviewBloc({required ReviewRepository reviewRepository})
      : _reviewRepository = reviewRepository,
        super(ReviewInitial()) {
    on<LoadRestaurantReviews>(_onLoadRestaurantReviews);
    on<AddReview>(_onAddReview);
  }

  Future<void> _onLoadRestaurantReviews(
    LoadRestaurantReviews event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewsLoading());
    try {
      final reviews = await _reviewRepository.getReviewsForRestaurant(event.restaurantId);
      emit(ReviewsLoaded(reviews));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> _onAddReview(
    AddReview event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewsLoading()); // Or keep showing the list and just show loading overlay?
                            // Simple approach: Loading state replaces UI. 
                            // Better approach: Separate ActionLoading state.
                            // For now, sticking to simple flow.
    try {
      await _reviewRepository.addReview(event.review);
      emit(ReviewOperationSuccess());
      // Reload reviews
      add(LoadRestaurantReviews(event.review.restaurantId));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }
}
