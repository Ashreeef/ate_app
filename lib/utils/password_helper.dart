import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Utility class for secure password hashing and verification
class PasswordHelper {
  /// Hash a password using SHA-256
  ///
  /// Note: For production, we may consider using a more robust algorithm (bcrypt or argon2 via native plugins for e.g.)
  /// SHA-256 with salt is a basic implementation for demonstration.
  static String hashPassword(String password, {String? salt}) {
    final saltToUse = salt ?? _generateSalt();
    final bytes = utf8.encode(password + saltToUse);
    final digest = sha256.convert(bytes);
    // Store salt with hash (format: salt:hash)
    return '$saltToUse:${digest.toString()}';
  }

  /// Verify a password against a stored hash
  static bool verifyPassword(String password, String storedHash) {
    try {
      final parts = storedHash.split(':');
      if (parts.length != 2) {
        return false;
      }

      final salt = parts[0];
      final hash = parts[1];

      final bytes = utf8.encode(password + salt);
      final digest = sha256.convert(bytes);

      return digest.toString() == hash;
    } catch (e) {
      return false;
    }
  }

  /// Generate a random salt
  static String _generateSalt() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final bytes = utf8.encode(timestamp);
    final digest = sha256.convert(bytes);
    return digest.toString().substring(0, 16);
  }
}
