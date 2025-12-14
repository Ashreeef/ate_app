# Firebase Configuration Guide

This app uses Firebase Cloud Messaging (FCM) to handle push notifications. Follow these steps to set up Firebase:

## Prerequisites
- A Firebase Project (create one at https://console.firebase.google.com/)
- Google Cloud Project linked to Firebase

## Android Setup

### 1. Add `google-services.json`

1. Go to Firebase Console → Your Project → Project Settings
2. Download the `google-services.json` file
3. Place it in `android/app/`

### 2. Add Firebase Gradle Plugin

Already configured in the Android build files.

## iOS Setup

### 1. Add `GoogleService-Info.plist`

1. Go to Firebase Console → Your Project → Project Settings
2. Download the `GoogleService-Info.plist` file
3. Add it to your Xcode project:
   - Open `ios/Runner.xcworkspace` in Xcode
   - Drag and drop the file into the Runner folder
   - Select "Copy items if needed"

### 2. Enable Push Notifications

In Xcode:
1. Select Runner project
2. Select Runner target
3. Go to Signing & Capabilities
4. Click + Capability
5. Search for "Push Notifications" and add it

## Backend Configuration

To send notifications from your backend:

```dart
// Example notification payload
{
  "notification": {
    "title": "New Post",
    "body": "Check out this amazing post!"
  },
  "data": {
    "type": "post",
    "postId": "123"
  }
}
```

### Supported notification types:
- `post` - Navigate to post detail screen
- `comment` - Navigate to post detail screen
- `like` - Navigate to post detail screen
- `custom` - Shows notifications screen

## FCM Token

The FCM token is automatically obtained and can be sent to your backend during user registration:

```dart
final token = await FirebaseMessaging.instance.getToken();
// Send this token to your backend to associate with user
```

## Testing Notifications

### Local Testing (Development)

```dart
// In your app, call this to send a test notification
await NotificationService.instance.sendTestNotification();
```

### Firebase Console Testing

1. Go to Firebase Console
2. Select your project
3. Go to Cloud Messaging
4. Click "Send your first message"
5. Create and send a test notification

## Notification Handling

Notifications are handled in three scenarios:

1. **Foreground (App Open)**: Local notification displayed
2. **Background (App Closed)**: System notification displayed
3. **Notification Tap**: Navigates to appropriate screen based on `type` field

All notifications are saved locally for later reading.

## Troubleshooting

### Notifications not received?

1. Check Firebase project configuration
2. Ensure FCM is enabled in Firebase Console
3. Verify `google-services.json` / `GoogleService-Info.plist` is in correct location
4. Check app permissions for notifications
5. Review Firebase Cloud Messaging quota

### App crashes on notification?

1. Ensure `NotificationService.initialize()` is called in `main()`
2. Check background message handler is properly defined
3. Verify app notification channel is created

## References

- [Firebase Cloud Messaging Documentation](https://firebase.google.com/docs/cloud-messaging)
- [Flutter Firebase Plugin](https://pub.dev/packages/firebase_messaging)
- [Flutter Local Notifications Plugin](https://pub.dev/packages/flutter_local_notifications)
