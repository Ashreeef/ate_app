import 'package:flutter_test/flutter_test.dart';
import 'package:ate_app/blocs/auth/auth_event.dart';

void main() {
  group('AuthEvent', () {
    group('LoginRequested', () {
      test('should create LoginRequested event with email and password', () {
        const event = LoginRequested(
          email: 'test@example.com',
          password: 'password123',
        );

        expect(event.email, 'test@example.com');
        expect(event.password, 'password123');
      });

      test('should have correct props', () {
        const event = LoginRequested(
          email: 'test@example.com',
          password: 'password123',
        );

        expect(event.props, ['test@example.com', 'password123']);
      });

      test('should be equal when props are same', () {
        const event1 = LoginRequested(
          email: 'test@example.com',
          password: 'password123',
        );
        const event2 = LoginRequested(
          email: 'test@example.com',
          password: 'password123',
        );

        expect(event1, equals(event2));
      });

      test('should not be equal when props differ', () {
        const event1 = LoginRequested(
          email: 'test@example.com',
          password: 'password123',
        );
        const event2 = LoginRequested(
          email: 'other@example.com',
          password: 'password123',
        );

        expect(event1, isNot(equals(event2)));
      });
    });

    group('SignupRequested', () {
      test('should create SignupRequested event with all fields', () {
        const event = SignupRequested(
          username: 'testuser',
          email: 'test@example.com',
          password: 'password123',
        );

        expect(event.username, 'testuser');
        expect(event.email, 'test@example.com');
        expect(event.password, 'password123');
      });

      test('should have correct props', () {
        const event = SignupRequested(
          username: 'testuser',
          email: 'test@example.com',
          password: 'password123',
        );

        expect(event.props, ['testuser', 'test@example.com', 'password123']);
      });

      test('should be equal when props are same', () {
        const event1 = SignupRequested(
          username: 'testuser',
          email: 'test@example.com',
          password: 'password123',
        );
        const event2 = SignupRequested(
          username: 'testuser',
          email: 'test@example.com',
          password: 'password123',
        );

        expect(event1, equals(event2));
      });
    });

    group('LogoutRequested', () {
      test('should create LogoutRequested event', () {
        const event = LogoutRequested();

        expect(event, isA<LogoutRequested>());
      });

      test('should have empty props', () {
        const event = LogoutRequested();

        expect(event.props, isEmpty);
      });

      test('should be equal to another LogoutRequested', () {
        const event1 = LogoutRequested();
        const event2 = LogoutRequested();

        expect(event1, equals(event2));
      });
    });

    group('AuthCheckRequested', () {
      test('should create AuthCheckRequested event', () {
        const event = AuthCheckRequested();

        expect(event, isA<AuthCheckRequested>());
      });

      test('should have empty props', () {
        const event = AuthCheckRequested();

        expect(event.props, isEmpty);
      });
    });

    group('ForgotPasswordRequested', () {
      test('should create ForgotPasswordRequested event with email', () {
        const event = ForgotPasswordRequested(email: 'test@example.com');

        expect(event.email, 'test@example.com');
      });

      test('should have correct props', () {
        const event = ForgotPasswordRequested(email: 'test@example.com');

        expect(event.props, ['test@example.com']);
      });
    });
  });
}
