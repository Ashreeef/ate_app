import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../repositories/user_repository.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../utils/password_helper.dart';

/// Bloc for handling authentication logic
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository _userRepository;
  final AuthService _authService;

  AuthBloc({
    required UserRepository userRepository,
    required AuthService authService,
  }) : _userRepository = userRepository,
       _authService = authService,
       super(const AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignupRequested>(_onSignupRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
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

      // Authenticate user
      final user = await _userRepository.authenticate(
        event.email,
        event.password,
      );

      if (user != null) {
        // Save user session
        await _authService.login(user.id!);
        emit(Authenticated(user: user));
      } else {
        emit(const AuthError(message: 'Invalid email or password'));
      }
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

      // Check if email already exists
      final emailExists = await _userRepository.emailExists(event.email);
      if (emailExists) {
        emit(const AuthError(message: 'Email already registered'));
        return;
      }

      // Hash password before storing
      final hashedPassword = PasswordHelper.hashPassword(event.password);

      // Create new user
      final newUser = User(
        username: event.username,
        email: event.email,
        password: hashedPassword,
      );

      final userId = await _userRepository.createUser(newUser);

      if (userId > 0) {
        emit(
          const SignupSuccess(
            message: 'Account created successfully! Please login.',
          ),
        );
      } else {
        emit(const AuthError(message: 'Failed to create account'));
      }
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
      await _authService.logout();
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
      if (_authService.isLoggedIn) {
        final userId = _authService.currentUserId;
        final user = await _userRepository.getUserById(userId!);
        if (user != null) {
          emit(Authenticated(user: user));
        } else {
          await _authService.logout();
          emit(const Unauthenticated());
        }
      } else {
        emit(const Unauthenticated());
      }
    } catch (e) {
      emit(const Unauthenticated());
    }
  }
}
