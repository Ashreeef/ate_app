import 'package:flutter_test/flutter_test.dart';
import 'package:ate_app/models/review.dart';
import '../../mocks/mock_data.dart';

void main() {
  group('Review Model', () {
    group('Constructor', () {
      test('should create Review with required fields', () {
        final review = Review(
          authorId: 'user-123',
          authorName: 'Test User',
          restaurantId: 'restaurant-123',
          rating: 4.5,
          comment: 'Great food!',
          createdAt: '2025-01-10T00:00:00.000Z',
        );

        expect(review.authorId, 'user-123');
        expect(review.authorName, 'Test User');
        expect(review.restaurantId, 'restaurant-123');
        expect(review.rating, 4.5);
        expect(review.comment, 'Great food!');
      });

      test('should create Review with all fields', () {
        final review = MockData.testReview;

        expect(review.id, 'review-123');
        expect(review.authorId, 'test-user-uid-123');
        expect(review.authorName, 'Test User');
        expect(review.authorAvatarUrl, 'https://example.com/avatar.jpg');
        expect(review.restaurantId, 'restaurant-123');
        expect(review.rating, 4.5);
        expect(review.comment, 'Excellent food and service! Highly recommend.');
      });

      test('should support optional dishId', () {
        final reviewWithDish = MockData.testReview2;

        expect(reviewWithDish.dishId, 'dish-123');
      });
    });

    group('toFirestore', () {
      test('should convert Review to Firestore map', () {
        final review = MockData.testReview;
        final map = review.toFirestore();

        expect(map['id'], 'review-123');
        expect(map['authorId'], 'test-user-uid-123');
        expect(map['authorName'], 'Test User');
        expect(map['authorAvatarUrl'], 'https://example.com/avatar.jpg');
        expect(map['restaurantId'], 'restaurant-123');
        expect(map['rating'], 4.5);
        expect(map['comment'], 'Excellent food and service! Highly recommend.');
        expect(map['createdAt'], '2025-01-10T14:00:00.000Z');
      });

      test('should include null fields', () {
        final review = Review(
          authorId: 'user-123',
          authorName: 'Test',
          restaurantId: 'rest-123',
          rating: 3.0,
          comment: 'OK',
          createdAt: '2025-01-10T00:00:00.000Z',
        );
        final map = review.toFirestore();

        expect(map.containsKey('dishId'), true);
        expect(map['dishId'], isNull);
        expect(map.containsKey('authorAvatarUrl'), true);
        expect(map['authorAvatarUrl'], isNull);
      });
    });

    group('fromFirestore', () {
      test('should create Review from Firestore map', () {
        final map = MockData.testReviewFirestore;
        final review = Review.fromFirestore(map);

        expect(review.id, 'review-123');
        expect(review.authorId, 'test-user-uid-123');
        expect(review.authorName, 'Test User');
        expect(review.rating, 4.5);
        expect(review.comment, 'Excellent food and service! Highly recommend.');
      });

      test('should handle null values with defaults', () {
        final map = <String, dynamic>{};
        final review = Review.fromFirestore(map);

        expect(review.id, isNull);
        expect(review.authorId, '');
        expect(review.authorName, 'Anonymous');
        expect(review.restaurantId, '');
        expect(review.rating, 0.0);
        expect(review.comment, '');
        // createdAt should default to current time
        expect(review.createdAt, isNotEmpty);
      });

      test('should parse rating from num to double', () {
        final map = <String, dynamic>{'rating': 4};
        final review = Review.fromFirestore(map);

        expect(review.rating, 4.0);
        expect(review.rating is double, true);
      });
    });

    group('Equatable', () {
      test('should be equal when all props match', () {
        final review1 = Review(
          id: 'review-123',
          authorId: 'user-123',
          authorName: 'Test',
          restaurantId: 'rest-123',
          rating: 4.0,
          comment: 'Great',
          createdAt: '2025-01-10T00:00:00.000Z',
        );

        final review2 = Review(
          id: 'review-123',
          authorId: 'user-123',
          authorName: 'Test',
          restaurantId: 'rest-123',
          rating: 4.0,
          comment: 'Great',
          createdAt: '2025-01-10T00:00:00.000Z',
        );

        expect(review1, equals(review2));
      });

      test('should not be equal when props differ', () {
        final review1 = MockData.testReview;
        final review2 = MockData.testReview2;

        expect(review1, isNot(equals(review2)));
      });

      test('should have correct props list', () {
        final review = MockData.testReview;
        final props = review.props;

        expect(props, contains(review.id));
        expect(props, contains(review.authorId));
        expect(props, contains(review.authorName));
        expect(props, contains(review.rating));
        expect(props, contains(review.comment));
        expect(props.length, 9);
      });
    });

    group('Rating Validation', () {
      test('should allow ratings from 0 to 5', () {
        for (double rating = 0; rating <= 5; rating += 0.5) {
          final review = Review(
            authorId: 'user-123',
            authorName: 'Test',
            restaurantId: 'rest-123',
            rating: rating,
            comment: 'Test',
            createdAt: '2025-01-10T00:00:00.000Z',
          );
          expect(review.rating, rating);
        }
      });

      test('should preserve decimal ratings', () {
        final review = Review(
          authorId: 'user-123',
          authorName: 'Test',
          restaurantId: 'rest-123',
          rating: 3.7,
          comment: 'Test',
          createdAt: '2025-01-10T00:00:00.000Z',
        );
        expect(review.rating, 3.7);
      });
    });
  });
}
