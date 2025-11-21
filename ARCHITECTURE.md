# Project Architecture

## Folder Structure

```
lib/
├── blocs/              # State management (Bloc/Cubit)
├── repositories/       # Data access layer
├── database/          # SQLite database setup
├── l10n/              # Localization files (ARB)
├── services/          # Business logic services
├── models/            # Data models
├── screens/           # UI screens
├── widgets/           # Reusable widgets
├── routes/            # App routing
├── utils/             # Utilities and constants
└── data/              # Fake data (temporary)
```

## Dependencies Added

### State Management
- **flutter_bloc**: ^8.1.6 - BLoC pattern for state management
- **equatable**: ^2.0.5 - Value equality for Dart classes

### Local Database
- **sqflite**: ^2.3.3+1 - SQLite database for Flutter
- **path**: ^1.9.0 - Path manipulation utilities

### Localization
- **flutter_localizations**: SDK - Flutter localization support
- **intl**: ^0.19.0 - Internationalization utilities

## Database Schema

### Tables Created
1. **users** - User accounts and profiles
2. **posts** - User posts with images and ratings
3. **restaurants** - Restaurant information
4. **likes** - Post likes tracking
5. **comments** - Post comments
6. **saved_posts** - User's saved posts
7. **search_history** - User search queries

## Localization Setup

Languages supported:
- English (en)
- Arabic (ar)
- French (fr)

ARB files located in `lib/l10n/`:
- `app_en.arb` - English translations
- `app_ar.arb` - Arabic translations
- `app_fr.arb` - French translations

## Next Steps

1. Run `flutter pub get` to install dependencies
2. Run `flutter gen-l10n` to generate localization files
3. Implement Bloc classes in `lib/blocs/`
4. Create repository implementations in `lib/repositories/`
5. Update `main.dart` to configure localization

## Files Created

### Database Layer
- `lib/database/database_helper.dart` - SQLite database helper with schema

### Repository Layer
- `lib/repositories/base_repository.dart` - Base repository interface

### Services Layer
- `lib/services/auth_service.dart` - Authentication service

### Localization
- `lib/l10n/app_en.arb` - English translations
- `lib/l10n/app_ar.arb` - Arabic translations
- `lib/l10n/app_fr.arb` - French translations
- `l10n.yaml` - Localization configuration

## Usage Examples

### Database Helper
```dart
// Get database instance
final db = await DatabaseHelper.instance.database;

// Clear all data
await DatabaseHelper.instance.clearAllData();
```

### Auth Service
```dart
// Login
await AuthService.instance.login(userId);

// Check if logged in
if (AuthService.instance.isLoggedIn) {
  // User is logged in
}

// Logout
await AuthService.instance.logout();
```
