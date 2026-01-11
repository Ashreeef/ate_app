import 'package:ate_app/models/user.dart';
import 'package:ate_app/models/post.dart';
import 'package:ate_app/models/restaurant.dart';
import 'package:ate_app/models/review.dart';
import 'package:ate_app/models/notification.dart';

/// Mock data for testing purposes
class MockData {
  // ==================== USERS ====================

  static User get testUser => User(
    uid: 'test-user-uid-123',
    username: 'testuser',
    email: 'test@example.com',
    displayName: 'Test User',
    searchName: 'test user',
    profileImage: 'https://example.com/avatar.jpg',
    bio: 'This is a test user bio',
    phone: '+1234567890',
    followersCount: 100,
    followingCount: 50,
    points: 500,
    level: 'Gold',
    createdAt: '2025-01-01T00:00:00.000Z',
    updatedAt: '2025-01-10T00:00:00.000Z',
    isRestaurant: false,
    restaurantId: null,
  );

  static User get testUser2 => User(
    uid: 'test-user-uid-456',
    username: 'anotheruser',
    email: 'another@example.com',
    displayName: 'Another User',
    searchName: 'another user',
    profileImage: null,
    bio: 'Another test user',
    followersCount: 25,
    followingCount: 30,
    points: 150,
    level: 'Silver',
    createdAt: '2025-01-05T00:00:00.000Z',
    updatedAt: '2025-01-09T00:00:00.000Z',
  );

  static User get restaurantOwnerUser => User(
    uid: 'restaurant-owner-uid',
    username: 'restaurant_owner',
    email: 'owner@restaurant.com',
    displayName: 'Restaurant Owner',
    isRestaurant: true,
    restaurantId: 'restaurant-123',
    createdAt: '2025-01-01T00:00:00.000Z',
  );

  static Map<String, dynamic> get testUserFirestore => testUser.toFirestore();

  // ==================== RESTAURANTS ====================

  static Restaurant get testRestaurant => Restaurant(
    id: 'restaurant-123',
    name: 'Test Restaurant',
    searchName: 'test restaurant',
    location: 'Algiers, Algeria',
    cuisineType: 'Italian',
    rating: 4.5,
    imageUrl: 'https://example.com/restaurant.jpg',
    postsCount: 50,
    createdAt: '2025-01-01T00:00:00.000Z',
    updatedAt: '2025-01-10T00:00:00.000Z',
    isClaimed: true,
    ownerId: 'restaurant-owner-uid',
    hours: 'Mon-Sun: 10:00-22:00',
    description: 'A wonderful test restaurant',
    latitude: 36.7538,
    longitude: 3.0588,
  );

  static Restaurant get unclaimedRestaurant => Restaurant(
    id: 'unclaimed-restaurant-456',
    name: 'Unclaimed Eatery',
    searchName: 'unclaimed eatery',
    location: 'Oran, Algeria',
    cuisineType: 'Algerian',
    rating: 3.8,
    postsCount: 10,
    createdAt: '2025-01-05T00:00:00.000Z',
    isClaimed: false,
  );

  static Map<String, dynamic> get testRestaurantFirestore =>
      testRestaurant.toFirestore();

  // ==================== POSTS ====================

  static Post get testPost => Post(
    postId: 'post-123',
    userUid: 'test-user-uid-123',
    username: 'testuser',
    userAvatarUrl: 'https://example.com/avatar.jpg',
    caption: 'Amazing food at this restaurant! 🍕',
    restaurantUid: 'restaurant-123',
    restaurantName: 'Test Restaurant',
    dishName: 'Margherita Pizza',
    rating: 4.5,
    images: [
      'https://example.com/image1.jpg',
      'https://example.com/image2.jpg',
    ],
    likesCount: 42,
    commentsCount: 8,
    likedByUids: ['test-user-uid-456'],
    savedByUids: [],
    createdAt: DateTime.parse('2025-01-10T12:00:00.000Z'),
    updatedAt: DateTime.parse('2025-01-10T12:00:00.000Z'),
  );

  static Post get testPost2 => Post(
    postId: 'post-456',
    userUid: 'test-user-uid-456',
    username: 'anotheruser',
    caption: 'Great experience!',
    restaurantUid: 'restaurant-123',
    restaurantName: 'Test Restaurant',
    images: ['https://example.com/image3.jpg'],
    likesCount: 10,
    commentsCount: 2,
    createdAt: DateTime.parse('2025-01-09T10:00:00.000Z'),
  );

  static Map<String, dynamic> get testPostFirestore => testPost.toFirestore();

  // ==================== REVIEWS ====================

  static Review get testReview => Review(
    id: 'review-123',
    authorId: 'test-user-uid-123',
    authorName: 'Test User',
    authorAvatarUrl: 'https://example.com/avatar.jpg',
    restaurantId: 'restaurant-123',
    rating: 4.5,
    comment: 'Excellent food and service! Highly recommend.',
    createdAt: '2025-01-10T14:00:00.000Z',
  );

  static Review get testReview2 => Review(
    id: 'review-456',
    authorId: 'test-user-uid-456',
    authorName: 'Another User',
    restaurantId: 'restaurant-123',
    dishId: 'dish-123',
    rating: 3.5,
    comment: 'Good but could be better.',
    createdAt: '2025-01-09T16:00:00.000Z',
  );

  static Map<String, dynamic> get testReviewFirestore =>
      testReview.toFirestore();

  // ==================== NOTIFICATIONS ====================

  static AppNotification get testNotification => AppNotification(
    id: 'notification-123',
    userUid: 'test-user-uid-123',
    type: NotificationType.like,
    title: 'New Like',
    body: 'testuser2 liked your post',
    actorUid: 'test-user-uid-456',
    actorUsername: 'testuser2',
    actorProfileImage: 'https://example.com/avatar2.jpg',
    postId: 'post-123',
    createdAt: DateTime.parse('2025-01-10T15:00:00.000Z'),
    isRead: false,
  );

  static AppNotification get readNotification => AppNotification(
    id: 'notification-456',
    userUid: 'test-user-uid-123',
    type: NotificationType.follow,
    title: 'New Follower',
    body: 'anotheruser started following you',
    actorUid: 'test-user-uid-456',
    actorUsername: 'anotheruser',
    targetUserId: 'test-user-uid-123',
    createdAt: DateTime.parse('2025-01-09T12:00:00.000Z'),
    isRead: true,
  );

  static AppNotification get commentNotification => AppNotification(
    id: 'notification-789',
    userUid: 'test-user-uid-123',
    type: NotificationType.comment,
    title: 'New Comment',
    body: 'testuser2 commented on your post',
    actorUid: 'test-user-uid-456',
    actorUsername: 'testuser2',
    postId: 'post-123',
    createdAt: DateTime.parse('2025-01-10T16:00:00.000Z'),
    isRead: false,
  );

  // ==================== LISTS ====================

  static List<Post> get testPosts => [testPost, testPost2];

  static List<Restaurant> get testRestaurants => [
    testRestaurant,
    unclaimedRestaurant,
  ];

  static List<User> get testUsers => [testUser, testUser2];

  static List<Review> get testReviews => [testReview, testReview2];

  static List<AppNotification> get testNotifications => [
    testNotification,
    readNotification,
    commentNotification,
  ];
}
