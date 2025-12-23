import 'package:equatable/equatable.dart';
import '../../models/user.dart';

/// Base class for all authentication states
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state when app starts
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// State when authentication is in progress
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// State when user is authenticated
class Authenticated extends AuthState {
  final User user;

  const Authenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

/// State when user is not authenticated
class Unauthenticated extends AuthState {
  const Unauthenticated();
}

/// State when authentication fails
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// State when signup is successful but needs to navigate to login
class SignupSuccess extends AuthState {
  final String message;

  const SignupSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

/// State when password reset email is sent
class PasswordResetEmailSent extends AuthState {
  final String message;

  const PasswordResetEmailSent({required this.message});

  @override
  List<Object?> get props => [message];
}
