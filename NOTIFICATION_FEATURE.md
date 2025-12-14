# Notification Feature Documentation

## Overview

The ATE App implements a comprehensive push notification system with the following features:

-  Firebase Cloud Messaging (FCM) for remote push notifications
-  Local notifications for foreground handling
-  Persistent notification storage in SQLite
-  Deep linking to appropriate screens based on notification type
-  Mark as read / Delete functionality
-  Theme-aware notification UI
-  Support for multiple notification types

## Architecture

### Components

#### 1. **NotificationService** (`lib/services/notification_service.dart`)
Main service handling all notification operations:
- Firebase initialization
- Permission requests
- Message handlers (foreground & background)
- Local notification display
- Navigation on tap

#### 2. **NotificationRepository** (`lib/repositories/notification_repository.dart`)
Database operations for notifications:
- Save notifications locally
- Fetch user's notifications
- Mark as read
- Delete notifications
- Get unread count

#### 3. **AppNotification Model** (`lib/models/notification.dart`)
Data model for notifications:
- Stores title, body, image, and custom data
- Timestamp and read status tracking

#### 4. **NotificationsScreen** (`lib/screens/notifications/notifications_screen.dart`)
UI for viewing all notifications:
- Displays notification list with timestamps
- Mark as read functionality
- Delete with swipe gesture
- Pull-to-refresh

## Notification Types

The app supports the following notification types via the `type` field in data:

| Type | Action | Screen |
|------|--------|--------|
| `post` | New post from user | Post Detail |
| `comment` | New comment on post | Post Detail |
| `like` | New like on post | Post Detail |
| `default` | Custom message | Notifications Screen |

## Database Schema

```sql
CREATE TABLE notifications (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  image_url TEXT,
  data TEXT,  -- JSON string
  created_at TEXT,
  is_read INTEGER DEFAULT 0,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
)
```

## Usage

### Initialize in App

Already done in `main.dart`:

```dart
await NotificationService.instance.initialize(
  onNotificationTap: _handleNotificationTap,
);
```

### Send Test Notification

```dart
await NotificationService.instance.sendTestNotification();
```

### Get User's Notifications

```dart
final notifications = await NotificationService.instance.getNotifications(
  limit: 20,
  offset: 0,
);
```

### Mark as Read

```dart
await NotificationService.instance.markAsRead(notificationId);
```

### Get Unread Count

```dart
final count = await NotificationService.instance.getUnreadCount();
```

### Delete Notification

```dart
await NotificationService.instance.deleteNotification(notificationId);
```

## Backend Integration

### 1. Sending Notifications via FCM

**REST API Example:**

```bash
curl -X POST https://fcm.googleapis.com/v1/projects/YOUR_PROJECT/messages:send \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "message": {
      "token": "DEVICE_FCM_TOKEN",
      "notification": {
        "title": "New Post",
        "body": "Check out this amazing dish!"
      },
      "data": {
        "type": "post",
        "postId": "123"
      }
    }
  }'
```

**Python Example:**

```python
from firebase_admin import messaging

message = messaging.Message(
    notification=messaging.Notification(
        title="New Post",
        body="Check out this amazing dish!"
    ),
    data={
        "type": "post",
        "postId": "123"
    },
    token="DEVICE_FCM_TOKEN"
)

response = messaging.send(message)
print(f"Message sent: {response}")
```

### 2. Scheduled Notifications

For periodic notifications, implement scheduled tasks on the backend:

```python
# Example: Send daily digest at 9 AM
from apscheduler.schedulers.background import BackgroundScheduler

scheduler = BackgroundScheduler()

def send_daily_digest():
    # Get all users' FCM tokens
    # Send personalized notifications
    pass

scheduler.add_job(send_daily_digest, 'cron', hour=9, minute=0)
scheduler.start()
```

### 3. FCM Token Management

After user login, send FCM token to backend:

```dart
// In NotificationService._getFCMToken()
final token = await _firebaseMessaging.getToken();

// Send to backend
// POST /api/users/fcm-token
// {
//   "token": "FCM_TOKEN"
// }
```

## Notification Payload Format

### Complete Payload Example

```json
{
  "message": {
    "token": "DEVICE_TOKEN",
    "notification": {
      "title": "New comment on your post",
      "body": "John: Amazing! I love it!",
      "image": "https://example.com/user-avatar.jpg"
    },
    "data": {
      "type": "comment",
      "postId": "456",
      "commentId": "789",
      "fromUserId": "123",
      "fromUsername": "john_doe"
    },
    "android": {
      "priority": "high",
      "ttl": "86400s"
    },
    "apns": {
      "headers": {
        "apns-priority": "10"
      }
    }
  }
}
```

## Features

### 1. Offline Storage

All notifications are stored locally in SQLite, allowing users to:
- View notifications when offline
- Maintain notification history
- Mark notifications as read

### 2. Smart Navigation

Notification taps automatically navigate to:
- Post detail screen (for post, comment, like)
- Notifications screen (for other types)

### 3. Mark as Read

- Individual mark as read
- Mark all as read button in header
- Visual indicator for unread notifications

### 4. Delete Notifications

- Swipe to delete
- Delete icon for each notification
- Delete with confirmation

### 5. Refresh

- Pull-to-refresh to get latest notifications
- Real-time updates in background

## Permission Handling

### iOS

- Requests user permission on first notification
- Supports alert, badge, and sound
- User can modify in Settings → Notifications

### Android

- Runtime permissions for Android 13+
- Uses notification channel for Android 8+
- User can disable via app settings

## Testing

### Development

1. **Enable Test Mode**: Add test devices in Firebase Console
2. **Send Test Notification**: Use Firebase Console or Admin SDK
3. **Local Testing**: Call `sendTestNotification()` method

### Staging

1. Create beta users
2. Send staging notifications via Firebase Console
3. Monitor notification delivery and engagement

## Troubleshooting

### Issue: Notifications not received

**Solutions:**
1. Verify Firebase configuration is correct
2. Check FCM is enabled in Firebase Console
3. Ensure device token is registered
4. Check app permissions
5. Review Firebase quotas

### Issue: Wrong navigation on tap

**Solutions:**
1. Verify `_handleNotificationTap()` logic
2. Check notification data contains correct `type` and IDs
3. Ensure routes are registered in `onGenerateRoute`

### Issue: Duplicate notifications

**Solutions:**
1. Check background handler isn't called multiple times
2. Verify notification ID is unique
3. Check FCM deduplication settings

## Performance Considerations

1. **Batch Notifications**: Limit frequency to avoid notification fatigue
2. **Data Size**: Keep notification payload < 4KB
3. **Local Storage**: Implement cleanup for old notifications
4. **Permissions**: Request at right time (after meaningful interaction)

## Security Considerations

1. **Token Management**: Rotate FCM tokens periodically
2. **Data Validation**: Validate notification data before navigation
3. **User Privacy**: Don't send sensitive data in notification body
4. **Rate Limiting**: Implement backend rate limiting to prevent spam

## Future Enhancements

- [ ] Notification categories (mentions, follows, messages)
- [ ] In-app notification center badge
- [ ] Sound and vibration settings
- [ ] Notification scheduling
- [ ] A/B testing for notification content
- [ ] Analytics and engagement tracking
- [ ] Push notification templates
- [ ] Rich media notifications (images, GIFs)

## References

- [Firebase Cloud Messaging Docs](https://firebase.google.com/docs/cloud-messaging)
- [Flutter Firebase Plugin](https://pub.dev/packages/firebase_messaging)
- [Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications)
- [FCM Best Practices](https://firebase.google.com/docs/cloud-messaging/best-practices)
