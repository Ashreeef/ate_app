import 'package:flutter_test/flutter_test.dart';
import 'package:ate_app/models/notification.dart';
import '../../mocks/mock_data.dart';

void main() {
  group('NotificationType', () {
    test('should have correct value for each type', () {
      expect(NotificationType.follow.value, 'follow');
      expect(NotificationType.like.value, 'like');
      expect(NotificationType.comment.value, 'comment');
    });

    test('should parse from string correctly', () {
      expect(
        NotificationTypeExtension.fromString('follow'),
        NotificationType.follow,
      );
      expect(
        NotificationTypeExtension.fromString('like'),
        NotificationType.like,
      );
      expect(
        NotificationTypeExtension.fromString('comment'),
        NotificationType.comment,
      );
    });

    test('should default to follow for unknown type', () {
      expect(
        NotificationTypeExtension.fromString('unknown'),
        NotificationType.follow,
      );
      expect(NotificationTypeExtension.fromString(''), NotificationType.follow);
    });
  });

  group('AppNotification Model', () {
    group('Constructor', () {
      test('should create notification with required fields', () {
        final notification = AppNotification(
          userUid: 'user-123',
          type: NotificationType.like,
          title: 'New Like',
          body: 'Someone liked your post',
          actorUid: 'actor-123',
          actorUsername: 'actor',
          createdAt: DateTime.now(),
        );

        expect(notification.userUid, 'user-123');
        expect(notification.type, NotificationType.like);
        expect(notification.title, 'New Like');
        expect(notification.body, 'Someone liked your post');
        expect(notification.isRead, false);
      });

      test('should create like notification', () {
        final notification = MockData.testNotification;

        expect(notification.id, 'notification-123');
        expect(notification.type, NotificationType.like);
        expect(notification.postId, 'post-123');
        expect(notification.actorUsername, 'testuser2');
      });

      test('should create follow notification', () {
        final notification = MockData.readNotification;

        expect(notification.type, NotificationType.follow);
        expect(notification.targetUserId, 'test-user-uid-123');
        expect(notification.isRead, true);
      });

      test('should create comment notification', () {
        final notification = MockData.commentNotification;

        expect(notification.type, NotificationType.comment);
        expect(notification.postId, 'post-123');
      });
    });

    group('toFirestore', () {
      test('should convert notification to Firestore map', () {
        final notification = MockData.testNotification;
        final map = notification.toFirestore();

        expect(map['userUid'], 'test-user-uid-123');
        expect(map['type'], 'like');
        expect(map['title'], 'New Like');
        expect(map['body'], 'testuser2 liked your post');
        expect(map['actorUid'], 'test-user-uid-456');
        expect(map['actorUsername'], 'testuser2');
        expect(map['postId'], 'post-123');
        expect(map['isRead'], false);
      });

      test('should include all optional fields', () {
        final notification = MockData.testNotification;
        final map = notification.toFirestore();

        expect(map.containsKey('imageUrl'), true);
        expect(map.containsKey('actorProfileImage'), true);
        expect(map.containsKey('postId'), true);
        expect(map.containsKey('targetUserId'), true);
      });

      test('should format createdAt as ISO string', () {
        final notification = MockData.testNotification;
        final map = notification.toFirestore();

        expect(map['createdAt'], isA<String>());
        expect(map['createdAt'], contains('2025-01-10'));
      });
    });

    group('data getter', () {
      test('should return legacy data map', () {
        final notification = MockData.testNotification;
        final data = notification.data;

        expect(data['type'], 'like');
        expect(data['actorUid'], 'test-user-uid-456');
        expect(data['actorUsername'], 'testuser2');
        expect(data['postId'], 'post-123');
      });
    });

    group('copyWith', () {
      test('should create a copy with updated fields', () {
        final original = MockData.testNotification;
        final copy = original.copyWith(isRead: true, title: 'Updated Title');

        expect(copy.isRead, true);
        expect(copy.title, 'Updated Title');
        // Original unchanged
        expect(original.isRead, false);
        expect(original.title, 'New Like');
        // Other fields preserved
        expect(copy.id, original.id);
        expect(copy.type, original.type);
      });

      test('should update notification type', () {
        final original = MockData.testNotification;
        final copy = original.copyWith(type: NotificationType.comment);

        expect(copy.type, NotificationType.comment);
        expect(original.type, NotificationType.like);
      });

      test('should preserve all fields when no updates', () {
        final original = MockData.testNotification;
        final copy = original.copyWith();

        expect(copy.id, original.id);
        expect(copy.userUid, original.userUid);
        expect(copy.type, original.type);
        expect(copy.title, original.title);
        expect(copy.body, original.body);
        expect(copy.isRead, original.isRead);
      });
    });

    group('toString', () {
      test('should return formatted string', () {
        final notification = MockData.testNotification;
        final str = notification.toString();

        expect(str, contains('notification-123'));
        expect(str, contains('like'));
        expect(str, contains('test-user-uid-123'));
        expect(str, contains('New Like'));
      });
    });

    group('Edge Cases', () {
      test('should handle null optional fields', () {
        final notification = AppNotification(
          userUid: 'user-123',
          type: NotificationType.follow,
          title: 'New Follower',
          body: 'Someone followed you',
          actorUid: 'actor-123',
          actorUsername: 'actor',
          createdAt: DateTime.now(),
        );

        expect(notification.id, isNull);
        expect(notification.imageUrl, isNull);
        expect(notification.actorProfileImage, isNull);
        expect(notification.postId, isNull);
        expect(notification.targetUserId, isNull);
      });

      test('should handle read status transition', () {
        final unread = MockData.testNotification;
        expect(unread.isRead, false);

        final read = unread.copyWith(isRead: true);
        expect(read.isRead, true);
      });

      test('should differentiate notification types', () {
        final like = MockData.testNotification;
        final follow = MockData.readNotification;
        final comment = MockData.commentNotification;

        expect(like.type, NotificationType.like);
        expect(follow.type, NotificationType.follow);
        expect(comment.type, NotificationType.comment);
      });
    });
  });
}
