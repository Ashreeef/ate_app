import 'dart:convert';
import '../models/notification.dart';
import '../database/database_helper.dart';
import '../services/auth_service.dart';

class NotificationRepository {
  static const String _tableName = 'notifications';
  final DatabaseHelper _db = DatabaseHelper.instance;

  /// Save a notification to the local database
  Future<int> saveNotification(AppNotification notification) async {
    try {
      final map = notification.toMap();
      // Convert data map to JSON string for storage
      map['data'] = jsonEncode(notification.data);
      return await _db.insert(_tableName, map);
    } catch (e) {
      print('Error saving notification: $e');
      throw Exception('Failed to save notification: $e');
    }
  }

  /// Get all notifications for current user
  Future<List<AppNotification>> getNotifications({
    int? limit,
    int? offset,
  }) async {
    try {
      final currentUserId = AuthService.instance.currentUserId ?? 1;
      final results = await _db.query(
        _tableName,
        where: 'user_id = ?',
        whereArgs: [currentUserId],
        orderBy: 'created_at DESC',
        limit: limit,
        offset: offset,
      );

      return results.map((map) {
        // Parse data JSON string back to map
        if (map['data'] is String) {
          map['data'] = jsonDecode(map['data']);
        }
        return AppNotification.fromMap(map);
      }).toList();
    } catch (e) {
      print('Error fetching notifications: $e');
      throw Exception('Failed to fetch notifications: $e');
    }
  }

  /// Get unread notification count
  Future<int> getUnreadCount() async {
    try {
      final currentUserId = AuthService.instance.currentUserId ?? 1;
      final results = await _db.query(
        _tableName,
        where: 'user_id = ? AND is_read = 0',
        whereArgs: [currentUserId],
      );
      return results.length;
    } catch (e) {
      print('Error getting unread count: $e');
      return 0;
    }
  }

  /// Mark notification as read
  Future<void> markAsRead(int notificationId) async {
    try {
      await _db.update(
        _tableName,
        {'is_read': 1},
        where: 'id = ?',
        whereArgs: [notificationId],
      );
    } catch (e) {
      print('Error marking notification as read: $e');
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      final currentUserId = AuthService.instance.currentUserId ?? 1;
      await _db.update(
        _tableName,
        {'is_read': 1},
        where: 'user_id = ?',
        whereArgs: [currentUserId],
      );
    } catch (e) {
      print('Error marking all notifications as read: $e');
      throw Exception('Failed to mark all notifications as read: $e');
    }
  }

  /// Delete a notification
  Future<void> deleteNotification(int notificationId) async {
    try {
      await _db.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [notificationId],
      );
    } catch (e) {
      print('Error deleting notification: $e');
      throw Exception('Failed to delete notification: $e');
    }
  }

  /// Delete all notifications for current user
  Future<void> deleteAllNotifications() async {
    try {
      final currentUserId = AuthService.instance.currentUserId ?? 1;
      await _db.delete(
        _tableName,
        where: 'user_id = ?',
        whereArgs: [currentUserId],
      );
    } catch (e) {
      print('Error deleting all notifications: $e');
      throw Exception('Failed to delete all notifications: $e');
    }
  }

  /// Get a single notification by ID
  Future<AppNotification?> getNotificationById(int id) async {
    try {
      final results = await _db.query(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (results.isEmpty) return null;

      final map = results.first;
      // Parse data JSON string back to map
      if (map['data'] is String) {
        map['data'] = jsonDecode(map['data']);
      }
      return AppNotification.fromMap(map);
    } catch (e) {
      print('Error fetching notification: $e');
      return null;
    }
  }
}
