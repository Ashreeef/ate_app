# Notification Feature - Quick Reference

## Quick Start

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Configure Firebase
- Android: Add `google-services.json` to `android/app/`
- iOS: Add `GoogleService-Info.plist` to Xcode and enable Push Notifications capability
- See `FIREBASE_SETUP.md` for detailed instructions

### 3. Test Locally
```dart
// Send test notification
await NotificationService.instance.sendTestNotification();
```

## 📱 User-Facing Features

### Viewing Notifications
- Tap notifications bell icon
- Pull down to refresh
- Tap notification to navigate to source
- Mark as read by tapping X icon
- Swipe left to delete

### Notification Types
- **Post**: New post from followed users
- **Comment**: Someone commented on your post
- **Like**: Someone liked your post
- **Custom**: Other messages from backend

## 🔌 Backend Integration

### 1. Send Notification via FCM
```bash
curl -X POST https://fcm.googleapis.com/v1/projects/YOUR_PROJECT/messages:send \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "message": {
      "token": "DEVICE_TOKEN",
      "notification": {"title": "Title", "body": "Body"},
      "data": {"type": "post", "postId": "123"}
    }
  }'
```

### 2. Payload Format
```json
{
  "notification": {
    "title": "Notification Title",
    "body": "Notification Body",
    "image": "https://url-to-image.jpg"
  },
  "data": {
    "type": "post|comment|like|custom",
    "postId": "123",
    "userId": "456"
  }
}
```

### 3. Store FCM Token
After user login, send FCM token to backend:
```
POST /api/users/fcm-token
{
  "userId": "123",
  "token": "FCM_TOKEN_HERE"
}
```

##  API Reference

### NotificationService
```dart
// Initialize (already done in main.dart)
NotificationService.instance.initialize(onNotificationTap: callback);

// Get notifications
List<AppNotification> notifications = 
  await NotificationService.instance.getNotifications();

// Mark as read
await NotificationService.instance.markAsRead(notificationId);

// Mark all as read
await NotificationService.instance.markAllAsRead();

// Delete notification
await NotificationService.instance.deleteNotification(notificationId);

// Get unread count
int count = await NotificationService.instance.getUnreadCount();

// Send test notification
await NotificationService.instance.sendTestNotification();
```

## 🗄️ Database

### Notifications Table
```sql
notifications (
  id INTEGER PRIMARY KEY,
  user_id INTEGER,
  title TEXT,
  body TEXT,
  image_url TEXT,
  data TEXT (JSON),
  created_at TEXT,
  is_read INTEGER (0 or 1)
)
```

##  UI Components

### NotificationsScreen
- Location: `lib/screens/notifications/notifications_screen.dart`
- Route: `/notifications`
- Features:
  - List of all notifications
  - Pull-to-refresh
  - Mark as read
  - Swipe to delete
  - Empty state
  - Dark mode support

## ⚙️ Configuration

### App Localization
- English: "notifications", "noNotifications", "markAllAsRead"
- French: "notifications", "noNotifications", "markAllAsRead"

### Navigation Routes
- `/notifications` → NotificationsScreen (protected)

### Theme Support
- Fully respects app's dark/light theme
- Colors from AppColors constants
- Consistent with design system

##  Troubleshooting

### Notifications Not Received
1. Check Firebase is properly configured
2. Verify FCM token is being sent to backend
3. Check app has notification permissions
4. Test with Firebase Console first

### Wrong Screen Opens
- Verify notification data includes `type` field
- Check `_handleNotificationTap()` in main.dart
- Ensure IDs (postId, etc.) are correct

### Duplicate Notifications
- Check background message handler
- Ensure notification IDs are unique
- Verify FCM deduplication

## 📊 File Structure
```
lib/
├── models/
│   └── notification.dart
├── repositories/
│   └── notification_repository.dart
├── services/
│   └── notification_service.dart
├── screens/
│   └── notifications/
│       └── notifications_screen.dart
└── main.dart

Docs/
├── FIREBASE_SETUP.md
├── NOTIFICATION_FEATURE.md
├── IMPLEMENTATION_SUMMARY.md
└── NOTIFICATION_QUICK_REFERENCE.md (this file)
```

##  Checklist Before Production

- [ ] Firebase project created and configured
- [ ] google-services.json added to Android
- [ ] GoogleService-Info.plist added to iOS
- [ ] Push Notifications capability enabled in Xcode
- [ ] Backend FCM integration implemented
- [ ] Tested with Firebase Console
- [ ] Tested on real devices (not emulator)
- [ ] Notification permissions handled
- [ ] Error handling for failed deliveries
- [ ] Analytics tracking implemented (optional)
- [ ] Rate limiting on backend implemented
- [ ] Security review completed

## 🔗 Links

- [Firebase Console](https://console.firebase.google.com)
- [FCM Documentation](https://firebase.google.com/docs/cloud-messaging)
- [Flutter Firebase Plugin](https://pub.dev/packages/firebase_messaging)
- [Local Notifications Plugin](https://pub.dev/packages/flutter_local_notifications)

##  Tips

1. **Testing**: Use `sendTestNotification()` during development
2. **Permissions**: Always test permission requests on real devices
3. **FCM Token**: Store token with user profile for backend sending
4. **Data Size**: Keep notification payload under 4KB
5. **Frequency**: Don't send too many notifications (user fatigue)
6. **Personalization**: Use user data to customize notifications
7. **Timing**: Send at optimal times based on user timezone
8. **Rich Media**: Consider adding images/GIFs for engagement

---

**Last Updated**: December 14, 2025
**Version**: 1.0
**Status**: Ready for Production
