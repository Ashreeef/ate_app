import 'package:flutter_test/flutter_test.dart';
import 'package:ate_app/models/user.dart';
import '../../mocks/mock_data.dart';

void main() {
  group('User Model', () {
    group('Constructor', () {
      test('should create User with required fields', () {
        final user = User(username: 'testuser', email: 'test@example.com');

        expect(user.username, 'testuser');
        expect(user.email, 'test@example.com');
        expect(user.followersCount, 0);
        expect(user.followingCount, 0);
        expect(user.points, 0);
        expect(user.level, 'Bronze');
        expect(user.isRestaurant, false);
      });

      test('should create User with all fields', () {
        final user = MockData.testUser;

        expect(user.uid, 'test-user-uid-123');
        expect(user.username, 'testuser');
        expect(user.email, 'test@example.com');
        expect(user.displayName, 'Test User');
        expect(user.followersCount, 100);
        expect(user.followingCount, 50);
        expect(user.points, 500);
        expect(user.level, 'Gold');
        expect(user.isRestaurant, false);
      });
    });

    group('toFirestore', () {
      test('should convert User to Firestore map', () {
        final user = MockData.testUser;
        final map = user.toFirestore();

        expect(map['uid'], 'test-user-uid-123');
        expect(map['username'], 'testuser');
        expect(map['email'], 'test@example.com');
        expect(map['displayName'], 'Test User');
        expect(map['followersCount'], 100);
        expect(map['followingCount'], 50);
        expect(map['points'], 500);
        expect(map['level'], 'Gold');
        expect(map['isRestaurant'], false);
      });

      test('should generate searchName from displayName if not provided', () {
        final user = User(
          username: 'testuser',
          email: 'test@example.com',
          displayName: 'Test User',
        );
        final map = user.toFirestore();

        expect(map['searchName'], 'test user');
      });

      test(
        'should generate searchName from username if displayName is null',
        () {
          final user = User(username: 'TestUser', email: 'test@example.com');
          final map = user.toFirestore();

          expect(map['searchName'], 'testuser');
        },
      );
    });

    group('fromFirestore', () {
      test('should create User from Firestore map', () {
        final map = MockData.testUserFirestore;
        final user = User.fromFirestore(map);

        expect(user.uid, 'test-user-uid-123');
        expect(user.username, 'testuser');
        expect(user.email, 'test@example.com');
        expect(user.displayName, 'Test User');
        expect(user.followersCount, 100);
        expect(user.followingCount, 50);
      });

      test('should handle null values with defaults', () {
        final map = <String, dynamic>{'uid': 'test-uid'};
        final user = User.fromFirestore(map);

        expect(user.uid, 'test-uid');
        expect(user.username, '');
        expect(user.email, '');
        expect(user.followersCount, 0);
        expect(user.followingCount, 0);
        expect(user.points, 0);
        expect(user.level, 'Bronze');
        expect(user.isRestaurant, false);
      });

      test('should handle missing fields gracefully', () {
        final map = <String, dynamic>{};
        final user = User.fromFirestore(map);

        expect(user.uid, isNull);
        expect(user.username, '');
        expect(user.email, '');
      });
    });

    group('copyWith', () {
      test('should create a copy with updated fields', () {
        final original = MockData.testUser;
        final copy = original.copyWith(
          username: 'newusername',
          followersCount: 200,
        );

        expect(copy.username, 'newusername');
        expect(copy.followersCount, 200);
        // Original unchanged
        expect(original.username, 'testuser');
        expect(original.followersCount, 100);
        // Other fields preserved
        expect(copy.email, original.email);
        expect(copy.uid, original.uid);
      });

      test('should preserve all fields when no updates provided', () {
        final original = MockData.testUser;
        final copy = original.copyWith();

        expect(copy.uid, original.uid);
        expect(copy.username, original.username);
        expect(copy.email, original.email);
        expect(copy.displayName, original.displayName);
      });
    });

    group('Restaurant User', () {
      test('should identify restaurant owner user', () {
        final user = MockData.restaurantOwnerUser;

        expect(user.isRestaurant, true);
        expect(user.restaurantId, 'restaurant-123');
      });

      test('should correctly serialize restaurant user', () {
        final user = MockData.restaurantOwnerUser;
        final map = user.toFirestore();

        expect(map['isRestaurant'], true);
        expect(map['restaurantId'], 'restaurant-123');
      });
    });
  });
}
