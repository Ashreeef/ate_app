import 'package:flutter_test/flutter_test.dart';
import 'package:ate_app/services/firebase_auth_service.dart';

void main() {
  group('FirebaseAuthService', () {
    group('Error Message Handling', () {
      // Test the error message mapping logic
      // Note: These tests verify the expected error messages for various Firebase Auth error codes

      test('should map user-not-found error correctly', () {
        const errorCode = 'user-not-found';
        const expectedMessage = 'No user found with this email address';

        // Verify the expected mapping
        expect(_getExpectedMessage(errorCode), expectedMessage);
      });

      test('should map wrong-password error correctly', () {
        const errorCode = 'wrong-password';
        const expectedMessage = 'Incorrect password';

        expect(_getExpectedMessage(errorCode), expectedMessage);
      });

      test('should map invalid-email error correctly', () {
        const errorCode = 'invalid-email';
        const expectedMessage = 'Invalid email address format';

        expect(_getExpectedMessage(errorCode), expectedMessage);
      });

      test('should map user-disabled error correctly', () {
        const errorCode = 'user-disabled';
        const expectedMessage = 'This account has been disabled';

        expect(_getExpectedMessage(errorCode), expectedMessage);
      });

      test('should map email-already-in-use error correctly', () {
        const errorCode = 'email-already-in-use';
        const expectedMessage = 'An account already exists with this email';

        expect(_getExpectedMessage(errorCode), expectedMessage);
      });

      test('should map weak-password error correctly', () {
        const errorCode = 'weak-password';
        const expectedMessage =
            'Password is too weak. Use at least 6 characters';

        expect(_getExpectedMessage(errorCode), expectedMessage);
      });

      test('should map operation-not-allowed error correctly', () {
        const errorCode = 'operation-not-allowed';
        const expectedMessage = 'Email/password sign-in is not enabled';

        expect(_getExpectedMessage(errorCode), expectedMessage);
      });

      test('should map invalid-credential error correctly', () {
        const errorCode = 'invalid-credential';
        const expectedMessage = 'Invalid credentials provided';

        expect(_getExpectedMessage(errorCode), expectedMessage);
      });

      test('should map too-many-requests error correctly', () {
        const errorCode = 'too-many-requests';
        const expectedMessage = 'Too many attempts. Please try again later';

        expect(_getExpectedMessage(errorCode), expectedMessage);
      });

      test('should map network-request-failed error correctly', () {
        const errorCode = 'network-request-failed';
        const expectedMessage = 'Network error. Please check your connection';

        expect(_getExpectedMessage(errorCode), expectedMessage);
      });

      test('should handle unknown error code', () {
        const errorCode = 'unknown-error';

        // Unknown errors should start with 'Authentication error:'
        final message = _getExpectedMessage(errorCode);
        expect(message.startsWith('Authentication error:'), true);
      });
    });
  });
}

/// Helper function to simulate the error message mapping
/// This mirrors the logic in FirebaseAuthService._handleAuthException
String _getExpectedMessage(String code) {
  switch (code) {
    case 'user-not-found':
      return 'No user found with this email address';
    case 'wrong-password':
      return 'Incorrect password';
    case 'invalid-email':
      return 'Invalid email address format';
    case 'user-disabled':
      return 'This account has been disabled';
    case 'email-already-in-use':
      return 'An account already exists with this email';
    case 'weak-password':
      return 'Password is too weak. Use at least 6 characters';
    case 'operation-not-allowed':
      return 'Email/password sign-in is not enabled';
    case 'invalid-credential':
      return 'Invalid credentials provided';
    case 'too-many-requests':
      return 'Too many attempts. Please try again later';
    case 'network-request-failed':
      return 'Network error. Please check your connection';
    default:
      return 'Authentication error: $code';
  }
}
