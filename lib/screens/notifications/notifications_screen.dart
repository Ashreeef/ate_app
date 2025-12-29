import 'package:flutter/material.dart';
import 'package:ate_app/utils/constants.dart';
import '../../l10n/app_localizations.dart';
import '../../models/notification.dart';
import '../../services/notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService _notificationService = NotificationService.instance;
  late Future<List<AppNotification>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = _notificationService.getNotifications();
  }

  Future<void> _refreshNotifications() async {
    setState(() {
      _notificationsFuture = _notificationService.getNotifications();
    });
  }

  Future<void> _markAllAsRead() async {
    await _notificationService.markAllAsRead();
    _refreshNotifications();
  }

  Future<void> _deleteNotification(String notificationId) async {
    await _notificationService.deleteNotification(notificationId);
    _refreshNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.notifications, style: AppTextStyles.heading3),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.done_all, size: AppSizes.icon),
            onPressed: _markAllAsRead,
            tooltip: 'Mark all as read',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshNotifications,
        child: FutureBuilder<List<AppNotification>>(
          future: _notificationsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final notifications = snapshot.data ?? [];

            if (notifications.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_off_outlined,
                        size: 80,
                        color: AppColors.textLight,
                      ),
                      SizedBox(height: AppSpacing.lg),
                      Text(
                        l10n.noNotifications,
                        style: AppTextStyles.heading3,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppSpacing.md),
                      Text(
                        'You are all caught up!',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textMedium,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(AppSpacing.md),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _buildNotificationCard(context, notification);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    AppNotification notification,
  ) {
    return Dismissible(
      key: Key(
        notification.id?.toString() ?? notification.createdAt.toString(),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        if (notification.id != null) {
          _deleteNotification(notification.id!);
        }
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
        child: Icon(Icons.delete, color: AppColors.white),
      ),
      child: Card(
        margin: EdgeInsets.only(bottom: AppSpacing.md),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
        color: notification.isRead
            ? Theme.of(context).cardColor
            : Theme.of(context).cardColor.withOpacity(0.8),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Unread indicator
              if (!notification.isRead)
                Container(
                  width: 8,
                  height: 8,
                  margin: EdgeInsets.only(right: AppSpacing.sm, top: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                )
              else
                SizedBox(width: 8 + AppSpacing.sm),

              // Notification content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      notification.body,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textMedium,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      _formatTime(notification.createdAt),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),

              // Close button
              SizedBox(width: AppSpacing.sm),
              if (!notification.isRead)
                GestureDetector(
                  onTap: () {
                    if (notification.id != null) {
                      _notificationService.markAsRead(notification.id!);
                      _refreshNotifications();
                    }
                  },
                  child: Icon(
                    Icons.clear,
                    size: AppSizes.icon,
                    color: AppColors.textMedium,
                  ),
                )
              else
                GestureDetector(
                  onTap: () {
                    if (notification.id != null) {
                      _deleteNotification(notification.id!);
                    }
                  },
                  child: Icon(
                    Icons.delete_outline,
                    size: AppSizes.icon,
                    color: AppColors.textLight,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
