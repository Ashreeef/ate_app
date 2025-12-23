# Firebase Authentication - Quick Reference

## 🚀 Quick Start

### How to Use Firebase Auth in Your App

#### 1. Sign Up a New User
```dart
// In your UI (already implemented in SignupScreen)
context.read<AuthBloc>().add(
  SignupRequested(
    username: 'johndoe',
    email: 'john@example.com',
    password: 'secure123',
  ),
);

// Listen for state changes
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is SignupSuccess) {
      // Show success message and navigate to login
    } else if (state is AuthError) {
      // Show error message
    }
  },
)
```

#### 2. Sign In
```dart
// In your UI (already implemented in LoginScreen)
context.read<AuthBloc>().add(
  LoginRequested(
    email: 'john@example.com',
    password: 'secure123',
  ),
);

// Listen for state changes
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is Authenticated) {
      // Navigate to home screen
      final user = state.user; // Access user data
    } else if (state is AuthError) {
      // Show error message
    }
  },
)
```

#### 3. Sign Out
```dart
context.read<AuthBloc>().add(const LogoutRequested());
```

#### 4. Forgot Password
```dart
// In your UI (already implemented in ForgotPasswordScreen)
context.read<AuthBloc>().add(
  ForgotPasswordRequested(email: 'john@example.com'),
);

// Listen for state changes
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is PasswordResetEmailSent) {
      // Show success message
    } else if (state is AuthError) {
      // Show error message
    }
  },
)
```

#### 5. Check Authentication Status
```dart
// On app start (already implemented in main.dart)
context.read<AuthBloc>().add(const AuthCheckRequested());

// Listen for state changes
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is Authenticated) {
      // User is logged in
    } else if (state is Unauthenticated) {
      // User is not logged in
    }
  },
)
```

## 📊 Available Auth States

```dart
AuthInitial()              // Initial state
AuthLoading()              // Processing auth request
Authenticated(user)        // User successfully authenticated
Unauthenticated()          // User not authenticated
AuthError(message)         // Authentication error occurred
SignupSuccess(message)     // Signup successful (navigate to login)
PasswordResetEmailSent(message) // Password reset email sent
```

## 🔐 Direct Repository Access

If you need to access auth repository directly (not through BLoC):

```dart
// Get the repository
final authRepo = context.read<AuthRepository>();

// Check if authenticated
if (authRepo.isAuthenticated) {
  // User is logged in
}

// Get current user ID
final uid = authRepo.currentUserId;

// Get current user data
final user = await authRepo.getCurrentUser();

// Listen to auth state changes
authRepo.authStateChanges.listen((firebaseUser) {
  if (firebaseUser != null) {
    // User is signed in
  } else {
    // User is signed out
  }
});

// Get user stream (real-time updates)
authRepo.currentUserStream.listen((user) {
  // User data updated
});
```

## 👤 User Data Operations

### Get User Data
```dart
final authRepo = context.read<AuthRepository>();

// Get current user
final currentUser = await authRepo.getCurrentUser();

// Get user by UID
final user = await authRepo.getUserByUid('firebase_uid_here');

// Get user by email
final user = await authRepo.getUserByEmail('john@example.com');

// Stream user data (real-time)
authRepo.getUserStream('firebase_uid_here').listen((user) {
  // User data updated
});
```

### Update User Profile
```dart
final authRepo = context.read<AuthRepository>();

// Get current user
final currentUser = await authRepo.getCurrentUser();

// Update user
final updatedUser = currentUser.copyWith(
  displayName: 'New Name',
  bio: 'Updated bio',
  profileImage: 'new_image_url',
);

await authRepo.updateUserProfile(updatedUser);
```

### Update Email
```dart
final authRepo = context.read<AuthRepository>();
await authRepo.updateEmail('newemail@example.com');
```

### Update Password
```dart
final authRepo = context.read<AuthRepository>();
await authRepo.updatePassword('newSecurePassword123');
```

### Delete Account
```dart
final authRepo = context.read<AuthRepository>();
await authRepo.deleteAccount();
// This deletes both Firebase Auth account and Firestore user data
```

## 🔄 Migration from Local DB

### Before (Old Way - Local SQLite)
```dart
// Don't use this anymore ❌
final user = await userRepository.getUserById(userId);
final authenticated = await userRepository.authenticate(email, password);
await authService.login(userId);
```

### After (New Way - Firebase)
```dart
// Use this now ✅
final user = await authRepository.getCurrentUser();
final user = await authRepository.signIn(email: email, password: password);
// No need to manually save session - Firebase handles it
```

## ⚠️ Common Pitfalls

### 1. Using `id` instead of `uid`
```dart
// Wrong ❌
final userId = user.id;

// Correct ✅
final userId = user.uid;
```

### 2. Checking authentication the old way
```dart
// Wrong ❌
if (AuthService.instance.isLoggedIn) { }

// Correct ✅
if (authRepository.isAuthenticated) { }
```

### 3. Manually managing sessions
```dart
// Wrong ❌
await authService.login(userId);
await authService.logout();

// Correct ✅
// Firebase handles sessions automatically
// Just use authRepository.signIn() and authRepository.signOut()
```

## 🎯 Key Points

1. **No Password Storage**: Passwords are never stored in Firestore
2. **Use UID**: Always use `user.uid` instead of `user.id`
3. **Automatic Sessions**: Firebase manages authentication sessions
4. **Real-time Sync**: User data can be streamed in real-time
5. **Offline Support**: Firestore caches data for offline access
6. **Security**: Firebase Auth provides enterprise-grade security

## 📱 UI Integration Examples

### Profile Screen
```dart
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authRepo = context.read<AuthRepository>();
    
    return StreamBuilder<User?>(
      stream: authRepo.currentUserStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data!;
          return Column(
            children: [
              Text(user.displayName ?? user.username),
              Text(user.email),
              Text('Points: ${user.points}'),
              Text('Level: ${user.level}'),
            ],
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
```

### Settings Screen
```dart
ElevatedButton(
  onPressed: () {
    // Sign out
    context.read<AuthBloc>().add(const LogoutRequested());
  },
  child: Text('Sign Out'),
)
```

## 🔒 Security Best Practices

1. **Never log passwords**: Don't print or log password values
2. **Use HTTPS**: Always use HTTPS for production
3. **Validate inputs**: Always validate email and password format
4. **Handle errors gracefully**: Show user-friendly error messages
5. **Implement rate limiting**: Firebase Auth has built-in rate limiting
6. **Enable email verification**: (Optional) Verify user emails

## 📝 Error Messages

The system provides user-friendly error messages:

- "No user found with this email address"
- "Incorrect password"
- "Invalid email address format"
- "An account already exists with this email"
- "Password is too weak. Use at least 6 characters"
- "Too many attempts. Please try again later"
- "Network error. Please check your connection"

## 🛠️ Debugging Tips

1. **Check Firebase Console**: View users in Firebase Console
2. **Enable Debug Logging**: Use Firebase debug mode
3. **Test Offline**: Firebase works offline with cached data
4. **Monitor Auth State**: Use `authStateChanges` stream
5. **Check Security Rules**: Ensure Firestore rules are correct

## 📚 Additional Resources

- [Firebase Auth Docs](https://firebase.google.com/docs/auth)
- [Firestore Docs](https://firebase.google.com/docs/firestore)
- [Flutter Firebase](https://firebase.flutter.dev/)
- Full migration guide: See `FIREBASE_AUTH_MIGRATION.md`
