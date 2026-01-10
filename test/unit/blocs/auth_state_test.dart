import 'package:flutter_test/flutter_test.dart';
import 'package:ate_app/blocs/auth/auth_state.dart';
import '../../mocks/mock_data.dart';

void main() {
  group('AuthState', () {
    group('AuthInitial', () {
      test('should create AuthInitial state', () {
        const state = AuthInitial();

        expect(state, isA<AuthInitial>());
        expect(state, isA<AuthState>());
      });

      test('should have empty props', () {
        const state = AuthInitial();

        expect(state.props, isEmpty);
      });

      test('should be equal to another AuthInitial', () {
        const state1 = AuthInitial();
        const state2 = AuthInitial();

        expect(state1, equals(state2));
      });
    });

    group('AuthLoading', () {
      test('should create AuthLoading state', () {
        const state = AuthLoading();

        expect(state, isA<AuthLoading>());
      });

      test('should have empty props', () {
        const state = AuthLoading();

        expect(state.props, isEmpty);
      });

      test('should be equal to another AuthLoading', () {
        const state1 = AuthLoading();
        const state2 = AuthLoading();

        expect(state1, equals(state2));
      });
    });

    group('Authenticated', () {
      test('should create Authenticated state with user', () {
        final user = MockData.testUser;
        final state = Authenticated(user: user);

        expect(state, isA<Authenticated>());
        expect(state.user, user);
      });

      test('should have user in props', () {
        final user = MockData.testUser;
        final state = Authenticated(user: user);

        expect(state.props, [user]);
      });

      test('should be equal when users are same', () {
        final user = MockData.testUser;
        final state1 = Authenticated(user: user);
        final state2 = Authenticated(user: user);

        expect(state1, equals(state2));
      });

      test('should provide access to user properties', () {
        final user = MockData.testUser;
        final state = Authenticated(user: user);

        expect(state.user.uid, 'test-user-uid-123');
        expect(state.user.username, 'testuser');
        expect(state.user.email, 'test@example.com');
      });
    });

    group('Unauthenticated', () {
      test('should create Unauthenticated state', () {
        const state = Unauthenticated();

        expect(state, isA<Unauthenticated>());
      });

      test('should have empty props', () {
        const state = Unauthenticated();

        expect(state.props, isEmpty);
      });

      test('should be equal to another Unauthenticated', () {
        const state1 = Unauthenticated();
        const state2 = Unauthenticated();

        expect(state1, equals(state2));
      });
    });

    group('AuthError', () {
      test('should create AuthError state with message', () {
        const state = AuthError(message: 'Login failed');

        expect(state, isA<AuthError>());
        expect(state.message, 'Login failed');
      });

      test('should have message in props', () {
        const state = AuthError(message: 'Login failed');

        expect(state.props, ['Login failed']);
      });

      test('should be equal when messages are same', () {
        const state1 = AuthError(message: 'Login failed');
        const state2 = AuthError(message: 'Login failed');

        expect(state1, equals(state2));
      });

      test('should not be equal when messages differ', () {
        const state1 = AuthError(message: 'Login failed');
        const state2 = AuthError(message: 'Network error');

        expect(state1, isNot(equals(state2)));
      });
    });

    group('SignupSuccess', () {
      test('should create SignupSuccess state with message', () {
        const state = SignupSuccess(message: 'Account created successfully');

        expect(state, isA<SignupSuccess>());
        expect(state.message, 'Account created successfully');
      });

      test('should have message in props', () {
        const state = SignupSuccess(message: 'Success');

        expect(state.props, ['Success']);
      });
    });

    group('PasswordResetEmailSent', () {
      test('should create PasswordResetEmailSent state with message', () {
        const state = PasswordResetEmailSent(
          message: 'Reset email sent to test@example.com',
        );

        expect(state, isA<PasswordResetEmailSent>());
        expect(state.message, 'Reset email sent to test@example.com');
      });

      test('should have message in props', () {
        const state = PasswordResetEmailSent(message: 'Email sent');

        expect(state.props, ['Email sent']);
      });
    });

    group('State Transitions', () {
      test('should differentiate between all states', () {
        const initial = AuthInitial();
        const loading = AuthLoading();
        final authenticated = Authenticated(user: MockData.testUser);
        const unauthenticated = Unauthenticated();
        const error = AuthError(message: 'Error');

        expect(initial, isNot(equals(loading)));
        expect(loading, isNot(equals(authenticated)));
        expect(authenticated, isNot(equals(unauthenticated)));
        expect(unauthenticated, isNot(equals(error)));
        expect(error, isNot(equals(initial)));
      });
    });
  });
}
