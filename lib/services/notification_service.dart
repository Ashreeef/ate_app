import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/notification.dart' as app_notification;
import '../repositories/notification_repository.dart';
import '../services/auth_service.dart';

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
      'app_icon',
    ); // Use your app's icon
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
  /// Handle incoming message
  Future<void> _handleMessage(
    RemoteMessage message, {
    bool fromForeground = false,
    bool fromNotificationTap = false,
  }) async {
    final userId = AuthService.instance.currentUserId ?? '1';
    final title = message.notification?.title ?? 'New Notification';
    final body = message.notification?.body ?? '';
    final imageUrl =
        message.notification?.android?.imageUrl ??
        message.notification?.apple?.imageUrl;

    // Parse notification data
    final data = Map<String, dynamic>.from(message.data);

    // Create app notification object
    final notification = app_notification.AppNotification(
      userId: userId,
      title: title,
      body: body,
      imageUrl: imageUrl,
      data: data,
      createdAt: DateTime.now(),
      isRead: false,
    );

    // Save to local database
    await _notificationRepository.saveNotification(notification);

    // Show local notification if app is in foreground
    if (fromForeground) {
      await _showLocalNotification(notification);
    }

    // Handle tap (navigate to screen)
    if (fromNotificationTap && _onNotificationTap != null) {
      _onNotificationTap!(data);
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

    // Local notifications require an int ID. Use hashCode of the string ID or fallback to current time
    final localId = notification.id?.hashCode ?? DateTime.now().millisecondsSinceEpoch;

    await _localNotifications.show(
      localId,
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
    final userId = AuthService.instance.currentUserId ?? '1';
    final notification = app_notification.AppNotification(
      userId: userId,
      title: message.notification?.title ?? 'New Notification',
      body: message.notification?.body ?? '',
      imageUrl: message.notification?.android?.imageUrl,
      data: Map<String, dynamic>.from(message.data),
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
    return await _notificationRepository.getNotifications(
      limit: limit,
      offset: offset,
    );
  }

  /// Get unread count
  Future<int> getUnreadCount() async {
    return await _notificationRepository.getUnreadCount();
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    await _notificationRepository.markAsRead(notificationId);
  }

  /// Mark all as read
  Future<void> markAllAsRead() async {
    await _notificationRepository.markAllAsRead();
  }

  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    await _notificationRepository.deleteNotification(notificationId);
  }

  /// Delete all notifications
  Future<void> deleteAllNotifications() async {
    await _notificationRepository.deleteAllNotifications();
  }

  /// Test notification (for development)
  Future<void> sendTestNotification() async {
    final userId = AuthService.instance.currentUserId ?? '1';
    final notification = app_notification.AppNotification(
      userId: userId,
      title: 'Test Notification',
      body: 'This is a test notification',
      data: {'type': 'post', 'postId': 1},
      createdAt: DateTime.now(),
      isRead: false,
    );

    await _notificationRepository.saveNotification(notification);
    await _showLocalNotification(notification);
  }
}
