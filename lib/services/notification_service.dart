import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/notification.dart' as app_notification;
import '../models/notification.dart';
import '../repositories/notification_repository.dart';
import '../services/firebase_auth_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  static NotificationService get instance => _instance;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final NotificationRepository _notificationRepository =
      NotificationRepository();

  // For local notifications
  late FlutterLocalNotificationsPlugin _localNotifications;

  // Navigation callback
  late Function(Map<String, dynamic>)? _onNotificationTap;

  /// Initialize notification service
  Future<void> initialize({
    required Function(Map<String, dynamic>) onNotificationTap,
  }) async {
    _onNotificationTap = onNotificationTap;

    // Initialize Firebase
    try {
      await Firebase.initializeApp();
    } catch (e) {
      print('Firebase already initialized or error: $e');
    }

    // Initialize local notifications
    _initLocalNotifications();

    // Request notification permissions
    await _requestPermissions();

    // Set up message handlers
    _setupMessageHandlers();

    // Get FCM token
    await _getFCMToken();
  }

  /// Initialize local notifications
  void _initLocalNotifications() {
    _localNotifications = FlutterLocalNotificationsPlugin();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _handleLocalNotificationTap,
    );
  }

  /// Request notification permissions (iOS)
  Future<void> _requestPermissions() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('Notification permission status: ${settings.authorizationStatus}');
  }

  /// Get FCM token (send to backend)
  Future<void> _getFCMToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      print('FCM Token: $token');
      // TODO: Send this token to your backend for user registration
      // This allows the backend to send messages to this specific device
    } catch (e) {
      print('Error getting FCM token: $e');
    }
  }

  /// Set up message handlers
  void _setupMessageHandlers() {
    // Handle message when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message while app is in foreground: ${message.data}');
      _handleMessage(message, fromForeground: true);
    });

    // Handle message when app is in background and user taps on it
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('App opened from background message: ${message.data}');
      _handleMessage(message, fromNotificationTap: true);
    });

    // Handle background messages (must be a top-level function)
    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  }

  /// Handle incoming message
  Future<void> _handleMessage(
    RemoteMessage message, {
    bool fromForeground = false,
    bool fromNotificationTap = false,
  }) async {
    final userUid = FirebaseAuthService().currentUserId;
    if (userUid == null) return;

    final title = message.notification?.title ?? 'New Notification';
    final body = message.notification?.body ?? '';
    final imageUrl =
        message.notification?.android?.imageUrl ??
        message.notification?.apple?.imageUrl;

    // Parse notification data
    final data = Map<String, dynamic>.from(message.data);

    // Extract notification type
    final typeString = data['type'] as String? ?? 'follow';
    final type = NotificationTypeExtension.fromString(typeString);

    // Create app notification object
    final notification = app_notification.AppNotification(
      userUid: userUid,
      type: type,
      title: title,
      body: body,
      imageUrl: imageUrl,
      actorUid: data['actorUid'] ?? '',
      actorUsername: data['actorUsername'] ?? '',
      actorProfileImage: data['actorProfileImage'],
      postId: data['postId'],
      targetUserId: data['targetUserId'],
      createdAt: DateTime.now(),
      isRead: false,
    );

    // Save to Firestore
    await _notificationRepository.saveNotification(notification);

    // Show local notification if app is in foreground
    if (fromForeground) {
      await _showLocalNotification(notification);
    }

    // Handle tap (navigate to screen)
    if (fromNotificationTap && _onNotificationTap != null) {
      _onNotificationTap!(Map<String, dynamic>.from(notification.data));
    }
  }

  /// Show local notification
  Future<void> _showLocalNotification(
    app_notification.AppNotification notification,
  ) async {
    const androidDetails = AndroidNotificationDetails(
      'ate_app_channel',
      'ATE App Notifications',
      channelDescription: 'Notifications from ATE App',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      int.tryParse(notification.id ?? '') ??
          DateTime.now().millisecondsSinceEpoch,
      notification.title,
      notification.body,
      notificationDetails,
      payload: jsonEncode(notification.data),
    );
  }

  /// Handle local notification tap
  void _handleLocalNotificationTap(NotificationResponse notificationResponse) {
    final payload = notificationResponse.payload;
    if (payload != null && _onNotificationTap != null) {
      try {
        final data = jsonDecode(payload) as Map<String, dynamic>;
        _onNotificationTap!(data);
      } catch (e) {
        print('Error parsing notification payload: $e');
      }
    }
  }

  /// Background message handler (must be a top-level function)
  static Future<void> _backgroundMessageHandler(RemoteMessage message) async {
    print('Handling background message: ${message.data}');
    // Save notification when app is terminated
    final userUid = FirebaseAuthService().currentUserId;
    if (userUid == null) return;

    final data = Map<String, dynamic>.from(message.data);
    final typeString = data['type'] as String? ?? 'follow';
    final type = NotificationTypeExtension.fromString(typeString);

    final notification = app_notification.AppNotification(
      userUid: userUid,
      type: type,
      title: message.notification?.title ?? 'New Notification',
      body: message.notification?.body ?? '',
      imageUrl: message.notification?.android?.imageUrl,
      actorUid: data['actorUid'] ?? '',
      actorUsername: data['actorUsername'] ?? '',
      actorProfileImage: data['actorProfileImage'],
      postId: data['postId'],
      targetUserId: data['targetUserId'],
      createdAt: DateTime.now(),
      isRead: false,
    );

    final repository = NotificationRepository();
    await repository.saveNotification(notification);
  }

  /// Get all notifications
  Future<List<app_notification.AppNotification>> getNotifications({
    int? limit,
    int? offset,
  }) async {
    final userUid = FirebaseAuthService().currentUserId;
    if (userUid == null) return [];

    return await _notificationRepository.getNotifications(
      userUid,
      limit: limit ?? 50,
    );
  }

  /// Get unread count
  Future<int> getUnreadCount() async {
    final userUid = FirebaseAuthService().currentUserId;
    if (userUid == null) return 0;

    return await _notificationRepository.getUnreadCount(userUid);
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    final userUid = FirebaseAuthService().currentUserId;
    if (userUid == null) return;

    await _notificationRepository.markAsRead(userUid, notificationId);
  }

  /// Mark all as read
  Future<void> markAllAsRead() async {
    final userUid = FirebaseAuthService().currentUserId;
    if (userUid == null) return;

    await _notificationRepository.markAllAsRead(userUid);
  }

  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    final userUid = FirebaseAuthService().currentUserId;
    if (userUid == null) return;

    await _notificationRepository.deleteNotification(userUid, notificationId);
  }

  /// Delete all notifications
  Future<void> deleteAllNotifications() async {
    final userUid = FirebaseAuthService().currentUserId;
    if (userUid == null) return;

    await _notificationRepository.deleteAllNotifications(userUid);
  }

  /// Test notification (for development)
  Future<void> sendTestNotification() async {
    final userUid = FirebaseAuthService().currentUserId;
    if (userUid == null) return;

    final notification = app_notification.AppNotification(
      userUid: userUid,
      type: NotificationType.like,
      title: 'Test Notification',
      body: 'This is a test notification',
      actorUid: 'test_user_123',
      actorUsername: 'TestUser',
      postId: 'test_post_123',
      createdAt: DateTime.now(),
      isRead: false,
    );

    await _notificationRepository.saveNotification(notification);
    await _showLocalNotification(notification);
  }
}
