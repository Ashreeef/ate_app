import 'package:shared_preferences/shared_preferences.dart';

/// Authentication service for managing user sessions
class AuthService {
  // Singleton pattern
  static final AuthService instance = AuthService._init();
  AuthService._init();

  static const String _keyUserId = 'user_id';
  int? _currentUserId;

  /// Get current logged in user ID
  int? get currentUserId => _currentUserId;

  /// Check if user is logged in
  bool get isLoggedIn => _currentUserId != null;

  /// Initialize auth service and restore session
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt(_keyUserId);
    if (userId != null) {
      _currentUserId = userId;
    }
  }

  /// Login user
  Future<void> login(int userId) async {
    _currentUserId = userId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyUserId, userId);
  }

  /// Logout user
  Future<void> logout() async {
    _currentUserId = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
  }
}
