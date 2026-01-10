import 'package:flutter_test/flutter_test.dart';
import 'package:ate_app/models/post.dart';
import '../../mocks/mock_data.dart';

void main() {
  group('Post Model', () {
    group('Constructor', () {
      test('should create Post with required fields', () {
        final post = Post(
          username: 'testuser',
          caption: 'Test caption',
          images: ['image1.jpg'],
        );

        expect(post.username, 'testuser');
        expect(post.caption, 'Test caption');
        expect(post.images.length, 1);
        expect(post.likesCount, 0);
        expect(post.commentsCount, 0);
        expect(post.likedByUids, isEmpty);
        expect(post.savedByUids, isEmpty);
      });

      test('should create Post with all fields', () {
        final post = MockData.testPost;

        expect(post.postId, 'post-123');
        expect(post.userUid, 'test-user-uid-123');
        expect(post.username, 'testuser');
        expect(post.caption, 'Amazing food at this restaurant! 🍕');
        expect(post.restaurantName, 'Test Restaurant');
        expect(post.dishName, 'Margherita Pizza');
        expect(post.rating, 4.5);
        expect(post.images.length, 2);
        expect(post.likesCount, 42);
        expect(post.commentsCount, 8);
      });

      test('should default createdAt to now if not provided', () {
        final beforeCreate = DateTime.now();
        final post = Post(username: 'testuser', caption: 'Test', images: []);
        final afterCreate = DateTime.now();

        expect(
          post.createdAt.isAfter(beforeCreate.subtract(Duration(seconds: 1))),
          true,
        );
        expect(
          post.createdAt.isBefore(afterCreate.add(Duration(seconds: 1))),
          true,
        );
      });
    });

    group('toFirestore', () {
      test('should convert Post to Firestore map', () {
        final post = MockData.testPost;
        final map = post.toFirestore();

        expect(map['postId'], 'post-123');
        expect(map['userId'], 'test-user-uid-123');
        expect(map['username'], 'testuser');
        expect(map['caption'], 'Amazing food at this restaurant! 🍕');
        expect(map['restaurantId'], 'restaurant-123');
        expect(map['restaurantName'], 'Test Restaurant');
        expect(map['dishName'], 'Margherita Pizza');
        expect(map['rating'], 4.5);
        expect(map['images'], hasLength(2));
        expect(map['likesCount'], 42);
        expect(map['commentsCount'], 8);
      });

      test('should use toMapForFirestore as alias', () {
        final post = MockData.testPost;

        expect(post.toFirestore(), equals(post.toMapForFirestore()));
      });

      test('should serialize likedBy and savedBy as UIDs', () {
        final post = MockData.testPost;
        final map = post.toFirestore();

        expect(map['likedBy'], ['test-user-uid-456']);
        expect(map['savedBy'], isEmpty);
      });
    });

    group('fromFirestore', () {
      test('should create Post from Firestore map', () {
        final map = MockData.testPostFirestore;
        final post = Post.fromFirestore(map);

        expect(post.postId, 'post-123');
        expect(post.userUid, 'test-user-uid-123');
        expect(post.username, 'testuser');
        expect(post.caption, 'Amazing food at this restaurant! 🍕');
        expect(post.restaurantUid, 'restaurant-123');
        expect(post.dishName, 'Margherita Pizza');
        expect(post.rating, 4.5);
      });

      test('should handle null values with defaults', () {
        final map = <String, dynamic>{'postId': 'test-post'};
        final post = Post.fromFirestore(map);

        expect(post.postId, 'test-post');
        expect(post.username, '');
        expect(post.caption, '');
        expect(post.images, isEmpty);
        expect(post.likesCount, 0);
        expect(post.commentsCount, 0);
        expect(post.likedByUids, isEmpty);
        expect(post.savedByUids, isEmpty);
      });

      test('should parse rating as double from num', () {
        final map = <String, dynamic>{'rating': 4};
        final post = Post.fromFirestore(map);

        expect(post.rating, 4.0);
        expect(post.rating is double, true);
      });

      test('should parse createdAt from ISO string', () {
        final map = <String, dynamic>{'createdAt': '2025-01-10T12:00:00.000Z'};
        final post = Post.fromFirestore(map);

        expect(post.createdAt.year, 2025);
        expect(post.createdAt.month, 1);
        expect(post.createdAt.day, 10);
        expect(post.createdAt.hour, 12);
      });
    });

    group('copyWith', () {
      test('should create a copy with updated fields', () {
        final original = MockData.testPost;
        final copy = original.copyWith(
          likesCount: 100,
          caption: 'Updated caption',
        );

        expect(copy.likesCount, 100);
        expect(copy.caption, 'Updated caption');
        // Original unchanged
        expect(original.likesCount, 42);
        expect(original.caption, 'Amazing food at this restaurant! 🍕');
        // Other fields preserved
        expect(copy.postId, original.postId);
        expect(copy.username, original.username);
      });

      test('should update likedByUids list', () {
        final original = MockData.testPost;
        final newLikedBy = [...original.likedByUids, 'new-user-uid'];
        final copy = original.copyWith(likedByUids: newLikedBy);

        expect(copy.likedByUids, contains('new-user-uid'));
        expect(original.likedByUids.length, 1);
        expect(copy.likedByUids.length, 2);
      });
    });

    group('Edge Cases', () {
      test('should handle empty images list', () {
        final post = Post(
          username: 'testuser',
          caption: 'No images',
          images: [],
        );

        expect(post.images, isEmpty);

        final map = post.toFirestore();
        expect(map['images'], isEmpty);
      });

      test('should handle null optional fields', () {
        final post = Post(
          username: 'testuser',
          caption: 'Simple post',
          images: ['image.jpg'],
        );

        expect(post.restaurantUid, isNull);
        expect(post.restaurantName, isNull);
        expect(post.dishName, isNull);
        expect(post.rating, isNull);
        expect(post.updatedAt, isNull);
      });

      test('should handle special characters in caption', () {
        final post = Post(
          username: 'testuser',
          caption: 'Delicious! 🍕🍝 #food @restaurant',
          images: ['image.jpg'],
        );

        expect(post.caption, 'Delicious! 🍕🍝 #food @restaurant');

        final map = post.toFirestore();
        final restored = Post.fromFirestore(map);
        expect(restored.caption, post.caption);
      });
    });
  });
}
