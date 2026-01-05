import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/notification.dart';
import '../../repositories/notification_repository.dart';
import '../../services/firebase_auth_service.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _notificationRepository;
  final FirebaseAuthService _authService;

  StreamSubscription? _notificationSubscription;

  NotificationBloc({
    required NotificationRepository notificationRepository,
    required FirebaseAuthService authService,
  }) : _notificationRepository = notificationRepository,
       _authService = authService,
       super(const NotificationInitial()) {
    // Event handlers
    on<LoadNotifications>(_onLoadNotifications);
    on<SubscribeToNotifications>(_onSubscribeToNotifications);
    on<MarkNotificationAsRead>(_onMarkNotificationAsRead);
    on<MarkAllNotificationsAsRead>(_onMarkAllNotificationsAsRead);
    on<DeleteNotification>(_onDeleteNotification);
    on<NotificationReceived>(_onNotificationReceived);
    on<RefreshUnreadCount>(_onRefreshUnreadCount);
  }

  /// Load notifications from repository
  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      emit(const NotificationLoading());

      final userId = _authService.currentUserId;
      if (userId == null) {
        emit(const NotificationError('User not authenticated'));
        return;
      }

      final notifications = await _notificationRepository.getNotifications(
        userId,
      );
      final unreadCount = await _notificationRepository.getUnreadCount(userId);

      emit(
        NotificationLoaded(
          notifications: notifications,
          unreadCount: unreadCount,
        ),
      );
    } catch (e) {
      emit(NotificationError('Failed to load notifications: $e'));
    }
  }

  /// Subscribe to real-time notification updates
  Future<void> _onSubscribeToNotifications(
    SubscribeToNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final userId = _authService.currentUserId;
      if (userId == null) {
        emit(const NotificationError('User not authenticated'));
        return;
      }

      // Cancel existing subscription if any
      await _notificationSubscription?.cancel();

      // Subscribe to notification stream
      _notificationSubscription = _notificationRepository
          .getNotificationsStream(userId)
          .listen(
            (notifications) {
              add(NotificationReceived(notifications));
            },
            onError: (error) {
              add(const NotificationReceived([]));
            },
          );

      // Load initial notifications
      add(const LoadNotifications());
    } catch (e) {
      emit(NotificationError('Failed to subscribe to notifications: $e'));
    }
  }

  /// Handle real-time notification updates
  Future<void> _onNotificationReceived(
    NotificationReceived event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final userId = _authService.currentUserId;
      if (userId == null) return;

      final notifications = event.notifications
          .map((doc) => AppNotification.fromFirestore(doc))
          .toList();

      final unreadCount = notifications.where((n) => !n.isRead).length;

      emit(
        NotificationLoaded(
          notifications: notifications,
          unreadCount: unreadCount,
        ),
      );
    } catch (e) {
      // Maintain current state if error occurs
      if (state is NotificationLoaded) {
        // Keep current state
      } else {
        emit(NotificationError('Failed to process notifications: $e'));
      }
    }
  }

  /// Mark notification as read
  Future<void> _onMarkNotificationAsRead(
    MarkNotificationAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final userId = _authService.currentUserId;
      if (userId == null) return;

      await _notificationRepository.markAsRead(userId, event.notificationId);

      // Refresh notifications
      add(const LoadNotifications());
    } catch (e) {
      emit(NotificationError('Failed to mark notification as read: $e'));
    }
  }

  /// Mark all notifications as read
  Future<void> _onMarkAllNotificationsAsRead(
    MarkAllNotificationsAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final userId = _authService.currentUserId;
      if (userId == null) return;

      await _notificationRepository.markAllAsRead(userId);

      // Refresh notifications
      add(const LoadNotifications());
    } catch (e) {
      emit(NotificationError('Failed to mark all notifications as read: $e'));
    }
  }

  /// Delete notification
  Future<void> _onDeleteNotification(
    DeleteNotification event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final userId = _authService.currentUserId;
      if (userId == null) return;

      await _notificationRepository.deleteNotification(
        userId,
        event.notificationId,
      );

      // Refresh notifications
      add(const LoadNotifications());
    } catch (e) {
      emit(NotificationError('Failed to delete notification: $e'));
    }
  }

  /// Refresh unread count
  Future<void> _onRefreshUnreadCount(
    RefreshUnreadCount event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final userId = _authService.currentUserId;
      if (userId == null) return;

      final unreadCount = await _notificationRepository.getUnreadCount(userId);

      if (state is NotificationLoaded) {
        emit((state as NotificationLoaded).copyWith(unreadCount: unreadCount));
      }
    } catch (e) {
      // Silently fail - don't disrupt current state
    }
  }

  @override
  Future<void> close() {
    _notificationSubscription?.cancel();
    return super.close();
  }
}
