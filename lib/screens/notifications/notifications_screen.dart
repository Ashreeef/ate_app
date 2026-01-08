import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/notification/notification_bloc.dart';
import '../../blocs/notification/notification_event.dart';
import '../../blocs/notification/notification_state.dart';
import '../../l10n/app_localizations.dart';
import '../../models/notification.dart';
import '../../utils/constants.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Subscribe to real-time notifications
    context.read<NotificationBloc>().add(const SubscribeToNotifications());
  }

  Future<void> _refreshNotifications() async {
    context.read<NotificationBloc>().add(const LoadNotifications());
  }

  Future<void> _markAllAsRead() async {
    context.read<NotificationBloc>().add(const MarkAllNotificationsAsRead());
  }

  Future<void> _deleteNotification(String notificationId) async {
    context.read<NotificationBloc>().add(DeleteNotification(notificationId));
  }

  Future<void> _markAsRead(String notificationId) async {
    context.read<NotificationBloc>().add(
      MarkNotificationAsRead(notificationId),
    );
  }

  String _getLocalizedTitle(AppNotification notification) {
    final l10n = AppLocalizations.of(context)!;
    switch (notification.type) {
      case NotificationType.follow:
        return l10n.newFollowerTitle;
      case NotificationType.like:
        return l10n.newLikeTitle;
      case NotificationType.comment:
        return l10n.newCommentTitle;
    }
  }

  String _getLocalizedBody(AppNotification notification) {
    final l10n = AppLocalizations.of(context)!;
    final username = notification.actorUsername;

    switch (notification.type) {
      case NotificationType.follow:
        return l10n.startedFollowingYou(username);
      case NotificationType.like:
        return l10n.likedYourPost(username);
      case NotificationType.comment:
        return l10n.commentedOnYourPost(username);
    }
  }

  void _handleNotificationTap(AppNotification notification) {
    // Mark as read when tapped
    if (!notification.isRead && notification.id != null) {
      _markAsRead(notification.id!);
    }

    // Navigate based on notification type
    switch (notification.type) {
      case NotificationType.follow:
        // Navigate to user profile
        // TODO: Implement profile navigation
        Navigator.of(
          context,
        ).pushNamed('/profile', arguments: notification.actorUid);
        break;
      case NotificationType.like:
      case NotificationType.comment:
        // Navigate to post detail
        if (notification.postId != null) {
          // TODO: Implement post detail navigation
          Navigator.of(
            context,
          ).pushNamed('/post-detail', arguments: notification.postId);
        }
        break;
    }
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
            tooltip: l10n.markAllAsRead,
          ),
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotificationError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 80, color: AppColors.error),
                    SizedBox(height: AppSpacing.lg),
                    Text(
                      l10n.error,
                      style: AppTextStyles.heading3,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSpacing.md),
                    Text(
                      state.message,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textMedium,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSpacing.lg),
                    ElevatedButton(
                      onPressed: _refreshNotifications,
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is NotificationLoaded) {
            final notifications = state.notifications;

            if (notifications.isEmpty) {
              return RefreshIndicator(
                onRefresh: _refreshNotifications,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 200,
                    child: Center(
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
                              l10n.allCaughtUp,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textMedium,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _refreshNotifications,
              child: ListView.builder(
                padding: EdgeInsets.all(AppSpacing.md),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return _buildNotificationCard(context, notification);
                },
              ),
            );
          }

          // Initial state
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    AppNotification notification,
  ) {
    // Get notification icon based on type
    IconData getNotificationIcon() {
      switch (notification.type) {
        case NotificationType.follow:
          return Icons.person_add;
        case NotificationType.like:
          return Icons.favorite;
        case NotificationType.comment:
          return Icons.comment;
      }
    }

    // Get notification color based on type
    Color getNotificationColor() {
      switch (notification.type) {
        case NotificationType.follow:
          return AppColors.primary;
        case NotificationType.like:
          return Colors.red;
        case NotificationType.comment:
          return Colors.blue;
      }
    }

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
        elevation: notification.isRead ? 0 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          side: !notification.isRead
              ? BorderSide(color: AppColors.primary.withOpacity(0.3), width: 1)
              : BorderSide.none,
        ),
        color: notification.isRead
            ? Theme.of(context).cardColor
            : AppColors.primary.withOpacity(0.05),
        child: InkWell(
          onTap: () => _handleNotificationTap(notification),
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User avatar or notification icon
                CircleAvatar(
                  radius: 24,
                  backgroundColor: getNotificationColor().withOpacity(0.1),
                  backgroundImage: notification.actorProfileImage != null
                      ? NetworkImage(notification.actorProfileImage!)
                      : null,
                  child: notification.actorProfileImage == null
                      ? Icon(
                          getNotificationIcon(),
                          color: getNotificationColor(),
                          size: 24,
                        )
                      : null,
                ),
                SizedBox(width: AppSpacing.md),

                // Notification content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _getLocalizedTitle(notification),
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: notification.isRead
                                    ? FontWeight.w500
                                    : FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              margin: EdgeInsets.only(left: AppSpacing.xs),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        _getLocalizedBody(notification),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textMedium,
                          fontWeight: notification.isRead
                              ? FontWeight.normal
                              : FontWeight.w500,
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

                // Action button
                SizedBox(width: AppSpacing.sm),
                IconButton(
                  icon: Icon(
                    notification.isRead ? Icons.delete_outline : Icons.clear,
                    size: 20,
                    color: AppColors.textLight,
                  ),
                  onPressed: () {
                    if (notification.id != null) {
                      if (notification.isRead) {
                        _deleteNotification(notification.id!);
                      } else {
                        _markAsRead(notification.id!);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if (difference.inDays > 0) {
      return l10n.daysAgo(difference.inDays.toString());
    } else if (difference.inHours > 0) {
      return l10n.hoursAgo(difference.inHours.toString());
    } else if (difference.inMinutes > 0) {
      return l10n.minutesAgo(difference.inMinutes.toString());
    } else {
      return l10n.justNow;
    }
  }
}
