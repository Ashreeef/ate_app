import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:ate_app/blocs/auth/auth_bloc.dart';
import 'package:ate_app/blocs/auth/auth_event.dart';
import 'package:ate_app/blocs/auth/auth_state.dart';
import 'package:ate_app/repositories/auth_repository.dart';
import '../../mocks/mock_data.dart';

@GenerateMocks([AuthRepository])
import 'auth_bloc_test.mocks.dart';

void main() {
  late AuthBloc authBloc;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authBloc = AuthBloc(authRepository: mockAuthRepository);
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    test('initial state is AuthInitial', () {
      expect(authBloc.state, const AuthInitial());
    });

    group('LoginRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, Authenticated] when login succeeds',
        build: () {
          when(
            mockAuthRepository.signIn(
              email: 'test@example.com',
              password: 'password123',
            ),
          ).thenAnswer((_) async => MockData.testUser);
          return authBloc;
        },
        act: (bloc) => bloc.add(
          const LoginRequested(
            email: 'test@example.com',
            password: 'password123',
          ),
        ),
        expect: () => [
          const AuthLoading(),
          isA<Authenticated>().having(
            (s) => s.user.uid,
            'user uid',
            'test-user-uid-123',
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when email is empty',
        build: () => authBloc,
        act: (bloc) =>
            bloc.add(const LoginRequested(email: '', password: 'password123')),
        expect: () => [
          const AuthLoading(),
          const AuthError(message: 'Email and password are required'),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when password is empty',
        build: () => authBloc,
        act: (bloc) => bloc.add(
          const LoginRequested(email: 'test@example.com', password: ''),
        ),
        expect: () => [
          const AuthLoading(),
          const AuthError(message: 'Email and password are required'),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when login fails',
        build: () {
          when(
            mockAuthRepository.signIn(
              email: 'test@example.com',
              password: 'wrongpassword',
            ),
          ).thenThrow(Exception('Invalid credentials'));
          return authBloc;
        },
        act: (bloc) => bloc.add(
          const LoginRequested(
            email: 'test@example.com',
            password: 'wrongpassword',
          ),
        ),
        expect: () => [const AuthLoading(), isA<AuthError>()],
      );

      blocTest<AuthBloc, AuthState>(
        'trims email whitespace before login',
        build: () {
          when(
            mockAuthRepository.signIn(
              email: 'test@example.com',
              password: 'password123',
            ),
          ).thenAnswer((_) async => MockData.testUser);
          return authBloc;
        },
        act: (bloc) => bloc.add(
          const LoginRequested(
            email: '  test@example.com  ',
            password: 'password123',
          ),
        ),
        verify: (_) {
          verify(
            mockAuthRepository.signIn(
              email: 'test@example.com',
              password: 'password123',
            ),
          ).called(1);
        },
      );
    });

    group('SignupRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, Authenticated] when signup succeeds',
        build: () {
          when(
            mockAuthRepository.usernameExists('testuser'),
          ).thenAnswer((_) async => false);
          when(
            mockAuthRepository.signUp(
              username: 'testuser',
              email: 'test@example.com',
              password: 'password123',
              displayName: 'testuser',
            ),
          ).thenAnswer((_) async => MockData.testUser);
          return authBloc;
        },
        act: (bloc) => bloc.add(
          const SignupRequested(
            username: 'testuser',
            email: 'test@example.com',
            password: 'password123',
          ),
        ),
        expect: () => [
          const AuthLoading(),
          isA<Authenticated>().having(
            (s) => s.user.username,
            'user username',
            'testuser',
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when fields are empty',
        build: () => authBloc,
        act: (bloc) => bloc.add(
          const SignupRequested(
            username: '',
            email: 'test@example.com',
            password: 'password123',
          ),
        ),
        expect: () => [
          const AuthLoading(),
          const AuthError(message: 'All fields are required'),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when password is too short',
        build: () => authBloc,
        act: (bloc) => bloc.add(
          const SignupRequested(
            username: 'testuser',
            email: 'test@example.com',
            password: '12345',
          ),
        ),
        expect: () => [
          const AuthLoading(),
          const AuthError(
            message: 'Password must be at least 6 characters long',
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when username already exists',
        build: () {
          when(
            mockAuthRepository.usernameExists('existinguser'),
          ).thenAnswer((_) async => true);
          return authBloc;
        },
        act: (bloc) => bloc.add(
          const SignupRequested(
            username: 'existinguser',
            email: 'test@example.com',
            password: 'password123',
          ),
        ),
        expect: () => [
          const AuthLoading(),
          const AuthError(message: 'Username already taken'),
        ],
      );
    });

    group('LogoutRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [Unauthenticated] when logout succeeds',
        build: () {
          when(mockAuthRepository.signOut()).thenAnswer((_) async {});
          return authBloc;
        },
        act: (bloc) => bloc.add(const LogoutRequested()),
        expect: () => [const Unauthenticated()],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthError] when logout fails',
        build: () {
          when(
            mockAuthRepository.signOut(),
          ).thenThrow(Exception('Logout failed'));
          return authBloc;
        },
        act: (bloc) => bloc.add(const LogoutRequested()),
        expect: () => [isA<AuthError>()],
      );
    });

    group('AuthCheckRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [Authenticated] when user is logged in',
        build: () {
          when(mockAuthRepository.isAuthenticated).thenReturn(true);
          when(
            mockAuthRepository.getCurrentUser(),
          ).thenAnswer((_) async => MockData.testUser);
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthCheckRequested()),
        expect: () => [
          isA<Authenticated>().having(
            (s) => s.user.uid,
            'user uid',
            'test-user-uid-123',
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [Unauthenticated] when user is not logged in',
        build: () {
          when(mockAuthRepository.isAuthenticated).thenReturn(false);
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthCheckRequested()),
        expect: () => [const Unauthenticated()],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [Unauthenticated] when user data not found',
        build: () {
          when(mockAuthRepository.isAuthenticated).thenReturn(true);
          when(
            mockAuthRepository.getCurrentUser(),
          ).thenAnswer((_) async => null);
          when(mockAuthRepository.signOut()).thenAnswer((_) async {});
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthCheckRequested()),
        expect: () => [const Unauthenticated()],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [Unauthenticated] when check throws error',
        build: () {
          when(mockAuthRepository.isAuthenticated).thenReturn(true);
          when(
            mockAuthRepository.getCurrentUser(),
          ).thenThrow(Exception('Network error'));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthCheckRequested()),
        expect: () => [const Unauthenticated()],
      );
    });

    group('ForgotPasswordRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when email is empty',
        build: () => authBloc,
        act: (bloc) => bloc.add(const ForgotPasswordRequested(email: '')),
        expect: () => [
          const AuthLoading(),
          const AuthError(message: 'Email is required'),
        ],
      );
    });
  });
}
