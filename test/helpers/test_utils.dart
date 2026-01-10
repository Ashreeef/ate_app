import 'package:flutter_test/flutter_test.dart';

class TestUtils {
  /// Creates a matcher for a specific exception message
  static Matcher throwsExceptionWithMessage(String message) {
    return throwsA(
      predicate(
        (e) => e is Exception && e.toString().contains(message),
        'Exception with message: $message',
      ),
    );
  }

  /// Waits for async operations to complete
  static Future<void> pumpAndSettle() async {
    await Future.delayed(Duration.zero);
  }

  /// Test email validation
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  /// Test password strength
  static bool isStrongPassword(String password) {
    return password.length >= 6;
  }
}

void main() {
  group('TestUtils', () {
    group('isValidEmail', () {
      test('should return true for valid email', () {
        expect(TestUtils.isValidEmail('test@example.com'), true);
        expect(TestUtils.isValidEmail('user.name@domain.org'), true);
        expect(TestUtils.isValidEmail('test123@test.co'), true);
      });

      test('should return false for invalid email', () {
        expect(TestUtils.isValidEmail(''), false);
        expect(TestUtils.isValidEmail('invalid'), false);
        expect(TestUtils.isValidEmail('missing@domain'), false);
        expect(TestUtils.isValidEmail('@nodomain.com'), false);
      });
    });

    group('isStrongPassword', () {
      test('should return true for valid passwords', () {
        expect(TestUtils.isStrongPassword('123456'), true);
        expect(TestUtils.isStrongPassword('password'), true);
        expect(TestUtils.isStrongPassword('longerpassword123'), true);
      });

      test('should return false for weak passwords', () {
        expect(TestUtils.isStrongPassword(''), false);
        expect(TestUtils.isStrongPassword('12345'), false);
        expect(TestUtils.isStrongPassword('abc'), false);
      });
    });
  });
}
