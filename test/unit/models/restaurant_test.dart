import 'package:flutter_test/flutter_test.dart';
import 'package:ate_app/models/restaurant.dart';
import '../../mocks/mock_data.dart';

void main() {
  group('Restaurant Model', () {
    group('Constructor', () {
      test('should create Restaurant with required name', () {
        final restaurant = Restaurant(name: 'Test Restaurant');

        expect(restaurant.name, 'Test Restaurant');
        expect(restaurant.rating, 0.0);
        expect(restaurant.postsCount, 0);
        expect(restaurant.isClaimed, false);
      });

      test('should create Restaurant with all fields', () {
        final restaurant = MockData.testRestaurant;

        expect(restaurant.id, 'restaurant-123');
        expect(restaurant.name, 'Test Restaurant');
        expect(restaurant.searchName, 'test restaurant');
        expect(restaurant.location, 'Algiers, Algeria');
        expect(restaurant.cuisineType, 'Italian');
        expect(restaurant.rating, 4.5);
        expect(restaurant.postsCount, 50);
        expect(restaurant.isClaimed, true);
        expect(restaurant.ownerId, 'restaurant-owner-uid');
        expect(restaurant.latitude, 36.7538);
        expect(restaurant.longitude, 3.0588);
      });
    });

    group('toFirestore', () {
      test('should convert Restaurant to Firestore map', () {
        final restaurant = MockData.testRestaurant;
        final map = restaurant.toFirestore();

        expect(map['id'], 'restaurant-123');
        expect(map['name'], 'Test Restaurant');
        expect(map['searchName'], 'test restaurant');
        expect(map['location'], 'Algiers, Algeria');
        expect(map['cuisineType'], 'Italian');
        expect(map['rating'], 4.5);
        expect(map['postsCount'], 50);
        expect(map['isClaimed'], true);
        expect(map['ownerId'], 'restaurant-owner-uid');
        expect(map['latitude'], 36.7538);
        expect(map['longitude'], 3.0588);
      });

      test('should generate searchName from name if not provided', () {
        final restaurant = Restaurant(name: 'My Restaurant');
        final map = restaurant.toFirestore();

        expect(map['searchName'], 'my restaurant');
      });
    });

    group('fromFirestore', () {
      test('should create Restaurant from Firestore map', () {
        final map = MockData.testRestaurantFirestore;
        final restaurant = Restaurant.fromFirestore('restaurant-123', map);

        expect(restaurant.id, 'restaurant-123');
        expect(restaurant.name, 'Test Restaurant');
        expect(restaurant.rating, 4.5);
        expect(restaurant.isClaimed, true);
      });

      test('should handle null values with defaults', () {
        final map = <String, dynamic>{'name': 'Test'};
        final restaurant = Restaurant.fromFirestore('test-id', map);

        expect(restaurant.id, 'test-id');
        expect(restaurant.name, 'Test');
        expect(restaurant.rating, 0.0);
        expect(restaurant.postsCount, 0);
        expect(restaurant.isClaimed, false);
        expect(restaurant.ownerId, isNull);
      });

      test('should handle location as String', () {
        final map = <String, dynamic>{
          'name': 'Test',
          'location': 'Algiers, Algeria',
        };
        final restaurant = Restaurant.fromFirestore('test-id', map);

        expect(restaurant.location, 'Algiers, Algeria');
      });

      test('should parse rating from num to double', () {
        final map = <String, dynamic>{'name': 'Test', 'rating': 4};
        final restaurant = Restaurant.fromFirestore('test-id', map);

        expect(restaurant.rating, 4.0);
        expect(restaurant.rating is double, true);
      });
    });

    group('toMap (SQLite)', () {
      test('should convert Restaurant to SQLite map', () {
        final restaurant = Restaurant(
          legacyId: 1,
          name: 'Test Restaurant',
          location: 'Algiers',
          cuisineType: 'Italian',
          rating: 4.5,
          imageUrl: 'image.jpg',
          postsCount: 10,
          createdAt: '2025-01-01',
        );
        final map = restaurant.toMap();

        expect(map['id'], 1);
        expect(map['name'], 'Test Restaurant');
        expect(map['location'], 'Algiers');
        expect(map['cuisine_type'], 'Italian');
        expect(map['rating'], 4.5);
        expect(map['image_url'], 'image.jpg');
        expect(map['posts_count'], 10);
        expect(map['created_at'], '2025-01-01');
      });
    });

    group('copyWith', () {
      test('should create a copy with updated fields', () {
        final original = MockData.testRestaurant;
        final copy = original.copyWith(rating: 5.0, postsCount: 100);

        expect(copy.rating, 5.0);
        expect(copy.postsCount, 100);
        // Original unchanged
        expect(original.rating, 4.5);
        expect(original.postsCount, 50);
        // Other fields preserved
        expect(copy.id, original.id);
        expect(copy.name, original.name);
      });

      test('should update claim status', () {
        final unclaimed = MockData.unclaimedRestaurant;
        final claimed = unclaimed.copyWith(
          isClaimed: true,
          ownerId: 'new-owner-uid',
        );

        expect(unclaimed.isClaimed, false);
        expect(claimed.isClaimed, true);
        expect(claimed.ownerId, 'new-owner-uid');
      });
    });

    group('Edge Cases', () {
      test('should handle null coordinates', () {
        final restaurant = Restaurant(name: 'Test');

        expect(restaurant.latitude, isNull);
        expect(restaurant.longitude, isNull);

        final map = restaurant.toFirestore();
        expect(map['latitude'], isNull);
        expect(map['longitude'], isNull);
      });

      test('should handle special characters in name', () {
        final restaurant = Restaurant(name: "O'Brien's Irish Pub & Grill");

        expect(restaurant.name, "O'Brien's Irish Pub & Grill");

        final map = restaurant.toFirestore();
        final restored = Restaurant.fromFirestore('id', map);
        expect(restored.name, restaurant.name);
      });

      test('should differentiate claimed vs unclaimed', () {
        final claimed = MockData.testRestaurant;
        final unclaimed = MockData.unclaimedRestaurant;

        expect(claimed.isClaimed, true);
        expect(claimed.ownerId, isNotNull);

        expect(unclaimed.isClaimed, false);
        expect(unclaimed.ownerId, isNull);
      });
    });
  });
}
