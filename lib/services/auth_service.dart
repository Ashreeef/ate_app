/// Authentication service for managing user sessions
class AuthService {
  // Singleton pattern
  static final AuthService instance = AuthService._init();
  AuthService._init();

  int? _currentUserId;

  /// Get current logged in user ID
  int? get currentUserId => _currentUserId;

  /// Check if user is logged in
  bool get isLoggedIn => _currentUserId != null;

  /// Login user
  Future<void> login(int userId) async {
    _currentUserId = userId;
    // TODO: Save to shared preferences for persistent login
  }

  /// Logout user
  Future<void> logout() async {
    _currentUserId = null;
    // TODO: Clear from shared preferences
  }
}
