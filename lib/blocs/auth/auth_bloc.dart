import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../repositories/auth_repository.dart';

/// Bloc for handling authentication logic with Firebase
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignupRequested>(_onSignupRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
  }

  /// Handle login request
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // Validate inputs
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(const AuthError(message: 'Email and password are required'));
        return;
      }

      // Sign in with Firebase
      final user = await _authRepository.signIn(
        email: event.email.trim(),
        password: event.password,
      );

      emit(Authenticated(user: user));
    } on Exception catch (e) {
      // Firebase auth exceptions are already formatted by FirebaseAuthService
      emit(AuthError(message: e.toString()));
    } catch (e) {
      emit(AuthError(message: 'Login failed: ${e.toString()}'));
    }
  }

  /// Handle signup request
  Future<void> _onSignupRequested(
    SignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // Validate inputs
      if (event.username.isEmpty ||
          event.email.isEmpty ||
          event.password.isEmpty) {
        emit(const AuthError(message: 'All fields are required'));
        return;
      }

      // Validate password strength (Firebase requires minimum 6 characters)
      if (event.password.length < 6) {
        emit(
          const AuthError(
            message: 'Password must be at least 6 characters long',
          ),
        );
        return;
      }

      // Check if username already exists
      final usernameExists = await _authRepository.usernameExists(
        event.username.trim(),
      );
      if (usernameExists) {
        emit(const AuthError(message: 'Username already taken'));
        return;
      }

      // Create new user with Firebase
      final user = await _authRepository.signUp(
        username: event.username.trim(),
        email: event.email.trim(),
        password: event.password,
        displayName: event.username.trim(),
      );

      emit(Authenticated(user: user));
    } on Exception catch (e) {
      // Firebase auth exceptions are already formatted by FirebaseAuthService
      emit(AuthError(message: e.toString()));
    } catch (e) {
      emit(AuthError(message: 'Signup failed: ${e.toString()}'));
    }
  }

  /// Handle logout request
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authRepository.signOut();
      emit(const Unauthenticated());
    } catch (e) {
      emit(AuthError(message: 'Logout failed: ${e.toString()}'));
    }
  }

  /// Check authentication status
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      if (_authRepository.isAuthenticated) {
        final user = await _authRepository.getCurrentUser();
        if (user != null) {
          emit(Authenticated(user: user));
        } else {
          await _authRepository.signOut();
          emit(const Unauthenticated());
        }
      } else {
        emit(const Unauthenticated());
      }
    } catch (e) {
      emit(const Unauthenticated());
    }
  }

  /// Handle forgot password request
  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // Validate email
      if (event.email.isEmpty) {
        emit(const AuthError(message: 'Email is required'));
        return;
      }

      // Send password reset email
      await _authRepository.sendPasswordResetEmail(event.email.trim());

      emit(
        const PasswordResetEmailSent(
          message: 'Password reset email sent. Please check your inbox.',
        ),
      );
    } on Exception catch (e) {
      emit(AuthError(message: e.toString()));
    } catch (e) {
      emit(
        AuthError(
          message: 'Failed to send password reset email: ${e.toString()}',
        ),
      );
    }
  }
}
