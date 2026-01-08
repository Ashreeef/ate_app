# Firebase Authentication Migration Guide

## Overview
This document describes the migration from local SQLite authentication to Firebase Authentication with Firestore for user data storage.

## Changes Made

### 1. User Model (`lib/models/user.dart`)
**Updates:**
- Added `uid` field (Firebase User ID) as the primary identifier
- Added `updatedAt` field for tracking last update timestamp
- Deprecated `id` field (kept for backward compatibility)
- Deprecated `password` field (Firebase handles authentication)
- Added `toFirestore()` method for Firestore serialization
- Added `fromFirestore()` factory method for Firestore deserialization
- Updated `copyWith()` to include new fields

**Migration Notes:**
- The `uid` field is now the primary identifier for users
- The `id` field is kept for backward compatibility during migration
- Passwords are no longer stored in the database (Firebase Auth handles this)

### 2. AuthRepository (NEW: `lib/repositories/auth_repository.dart`)
**Purpose:** Unified authentication repository using Firebase Auth and Firestore

**Key Features:**
- Sign up with email/password (creates Firebase Auth account + Firestore user document)
- Sign in with email/password
- Sign out
- Get current authenticated user
- Check authentication status
- Password reset via email
- Update email/password
- Delete account (removes both Firebase Auth and Firestore data)
- Real-time user data streams

**Public Methods:**
```dart
Future<User> signUp({required String username, required String email, required String password, String? displayName})
Future<User> signIn({required String email, required String password})
Future<void> signOut()
Future<User?> getCurrentUser()
Future<User?> getUserByUid(String uid)
Future<User?> getUserByEmail(String email)
Future<bool> usernameExists(String username)
Future<void> updateUserProfile(User user)
Future<void> sendPasswordResetEmail(String email)
Future<void> updateEmail(String newEmail)
Future<void> updatePassword(String newPassword)
Future<void> reauthenticate(String email, String password)
Future<void> deleteAccount()
Stream<User?> getUserStream(String uid)
Stream<User?> get currentUserStream
```

### 3. UserRepository (`lib/repositories/user_repository.dart`)
**Updates:**
- Added Firestore operations for all CRUD operations
- Deprecated local SQLite methods (marked with `@Deprecated`)
- New methods use `Firestore` suffix (e.g., `getUserByUidFirestore()`)
- Supports both local and Firestore during transition period

**New Firestore Methods:**
- `getUserByUid()` - Get user by Firebase UID
- `getUserByEmailFirestore()` - Get user by email from Firestore
- `updateUserFirestore()` - Update user in Firestore
- `setUserFirestore()` - Create or update user in Firestore
- `deleteUserFirestore()` - Delete user from Firestore
- `getAllUsersFirestore()` - Get all users from Firestore
- `searchUsersFirestore()` - Search users by username (client-side filtering)
- `getUserStreamFirestore()` - Real-time user data stream

**Deprecated Methods:**
- All old SQLite methods are marked as deprecated but still functional

### 4. AuthBloc (`lib/blocs/auth/auth_bloc.dart`)
**Updates:**
- Now uses `AuthRepository` instead of `UserRepository` + `AuthService`
- Removed password hashing (Firebase handles this)
- Added proper exception handling for Firebase errors
- Added password strength validation (minimum 6 characters)
- Added username uniqueness check
- New event handler: `_onForgotPasswordRequested()`

**Changes:**
- Login: Uses `authRepository.signIn()` instead of local authentication
- Signup: Uses `authRepository.signUp()` with username validation
- Logout: Uses `authRepository.signOut()`
- Auth Check: Uses `authRepository.getCurrentUser()`
- Forgot Password: Sends password reset email via Firebase

### 5. AuthEvent (`lib/blocs/auth/auth_event.dart`)
**New Event:**
- `ForgotPasswordRequested` - Triggers password reset email

### 6. AuthState (`lib/blocs/auth/auth_state.dart`)
**New State:**
- `PasswordResetEmailSent` - Indicates password reset email was sent successfully

### 7. Main App (`lib/main.dart`)
**Updates:**
- Removed `AuthService` singleton initialization
- Added `AuthRepository` to global repository instances
- Updated `MultiRepositoryProvider` to provide `AuthRepository`
- Updated `AuthBloc` initialization to use `AuthRepository`
- Updated `UserBloc` to use `AuthRepository`
- Updated `SearchBloc` to use `AuthRepository`
- Updated route guard to use `authRepository.isAuthenticated`
- Added `AuthCheckRequested` event on app start

**Removed:**
- `AuthService.instance.initialize()` call
- Local auth session management

### 8. UserBloc (`lib/blocs/user/user_bloc.dart`)
**Updates:**
- Replaced `AuthService` with `AuthRepository`
- Updated `_onRefreshUser()` to use Firebase current user
- Now uses `authRepository.getCurrentUser()` instead of local storage

### 9. SearchBloc (`lib/blocs/search/search_bloc.dart`)
**Updates:**
- Replaced `AuthService` with `AuthRepository`
- Temporarily disabled search history saving (marked with TODO for migration)
- Updated authentication checks to use `authRepository.isAuthenticated`

### 10. Forgot Password Screen (`lib/screens/auth/forgot_password_screen.dart`)
**Updates:**
- Fully implemented with Firebase Auth
- Uses `AuthBloc` with `ForgotPasswordRequested` event
- Shows loading state while sending email
- Displays success/error messages from Firebase
- Auto-navigates back to login after successful email send

## Firebase Authentication Flow

### Sign Up Flow
1. User enters username, email, and password
2. `AuthBloc` validates inputs (all fields required, password ≥ 6 chars)
3. `AuthBloc` checks if username already exists in Firestore
4. `AuthRepository` creates Firebase Auth account
5. `AuthRepository` creates Firestore user document with user data
6. Success message shown, user redirected to login

### Sign In Flow
1. User enters email and password
2. `AuthBloc` validates inputs
3. `AuthRepository` authenticates with Firebase Auth
4. `AuthRepository` fetches user data from Firestore
5. User is authenticated and navigated to home screen

### Sign Out Flow
1. User triggers logout
2. `AuthBloc` calls `authRepository.signOut()`
3. Firebase Auth signs out
4. User is unauthenticated and redirected to login

### Password Reset Flow
1. User enters email on forgot password screen
2. `AuthBloc` validates email
3. `AuthRepository` sends password reset email via Firebase
4. Success message shown, user redirected to login

## Security Improvements

1. **No Password Storage**: Passwords are no longer stored in the database
2. **Firebase Auth Security**: Leverages Firebase's enterprise-grade security
3. **Secure Password Reset**: Uses Firebase's secure email-based password reset
4. **Session Management**: Firebase handles secure session tokens
5. **Email Verification**: Can be easily added using Firebase Auth methods

## Data Structure

### Firestore User Document
```json
{
  "uid": "firebase_user_id",
  "username": "user123",
  "email": "user@example.com",
  "displayName": "John Doe",
  "profileImage": "url_to_image",
  "bio": "User bio",
  "phone": "+1234567890",
  "followersCount": 0,
  "followingCount": 0,
  "points": 0,
  "level": "Bronze",
  "createdAt": "2025-12-23T10:30:00.000Z",
  "updatedAt": "2025-12-23T10:30:00.000Z"
}
```

## Error Handling

The `FirebaseAuthService` provides user-friendly error messages for:
- `user-not-found`: "No user found with this email address"
- `wrong-password`: "Incorrect password"
- `invalid-email`: "Invalid email address format"
- `email-already-in-use`: "An account already exists with this email"
- `weak-password`: "Password is too weak. Use at least 6 characters"
- `too-many-requests`: "Too many attempts. Please try again later"
- `network-request-failed`: "Network error. Please check your connection"

## Migration Checklist

### Completed ✅
- [x] Update User model with Firebase UID support
- [x] Create AuthRepository with Firebase Auth integration
- [x] Migrate AuthBloc to use Firebase
- [x] Update UserRepository with Firestore methods
- [x] Update main.dart to use AuthRepository
- [x] Implement forgot password functionality
- [x] Update UserBloc to use AuthRepository
- [x] Update SearchBloc to use AuthRepository

### Pending 📋
- [ ] Migrate existing local users to Firebase (if needed)
- [ ] Update all other BLoCs that reference user IDs to use UIDs
- [ ] Migrate search history to use Firebase UIDs
- [ ] Update post/comment repositories to use Firebase UIDs
- [ ] Remove deprecated SQLite user methods after full migration
- [ ] Add email verification flow (optional)
- [ ] Add social authentication (Google, Facebook, etc.) (optional)

## Testing Recommendations

1. **New User Registration**
   - Test with valid credentials
   - Test with weak password (< 6 characters)
   - Test with existing email
   - Test with existing username
   - Test with invalid email format

2. **User Login**
   - Test with valid credentials
   - Test with wrong password
   - Test with non-existent email
   - Test with invalid email format

3. **Password Reset**
   - Test with registered email
   - Test with non-existent email
   - Verify email is received
   - Test password reset link

4. **Session Management**
   - Test app restart with logged-in user
   - Test logout functionality
   - Test route guards

## Best Practices

1. **Always use UID**: When referencing users, always use the Firebase UID (`user.uid`)
2. **Error Handling**: Always wrap Firebase operations in try-catch blocks
3. **Loading States**: Show loading indicators during Firebase operations
4. **Offline Support**: Firestore supports offline persistence (already enabled in `FirestoreService`)
5. **Security Rules**: Ensure Firestore security rules are properly configured

## Firestore Security Rules Example

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      // Allow users to read their own profile
      allow read: if request.auth != null && request.auth.uid == userId;
      
      // Allow users to update their own profile
      allow update: if request.auth != null && request.auth.uid == userId;
      
      // Allow authenticated users to create their profile (during signup)
      allow create: if request.auth != null && request.auth.uid == userId;
      
      // Only allow users to delete their own profile
      allow delete: if request.auth != null && request.auth.uid == userId;
    }
    
    // Public user data (for profiles, search, etc.)
    match /users/{userId} {
      // Allow all authenticated users to read public user data
      allow read: if request.auth != null;
    }
  }
}
```

## Next Steps

1. **Test the authentication flow** thoroughly in development
2. **Configure Firebase security rules** for Firestore
3. **Migrate existing data** if you have users in the local database
4. **Update other features** that depend on user authentication
5. **Remove deprecated methods** after confirming everything works
6. **Add email verification** for enhanced security (optional)
7. **Add social authentication** providers (optional)

## Support

For Firebase Authentication documentation, visit:
- [Firebase Auth Documentation](https://firebase.google.com/docs/auth)
- [Firestore Documentation](https://firebase.google.com/docs/firestore)
- [Flutter Firebase Setup](https://firebase.flutter.dev/docs/overview)
