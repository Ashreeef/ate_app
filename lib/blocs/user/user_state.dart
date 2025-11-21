import 'package:equatable/equatable.dart';
import '../../models/user.dart';

/// Base class for all user states
abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class UserInitial extends UserState {
  const UserInitial();
}

/// State when loading user data
class UserLoading extends UserState {
  const UserLoading();
}

/// State when user data is loaded
class UserLoaded extends UserState {
  final User user;

  const UserLoaded({required this.user});

  @override
  List<Object?> get props => [user];
}

/// State when user update is successful
class UserUpdateSuccess extends UserState {
  final User user;
  final String message;

  const UserUpdateSuccess({required this.user, required this.message});

  @override
  List<Object?> get props => [user, message];
}

/// State when user operation fails
class UserError extends UserState {
  final String message;

  const UserError({required this.message});

  @override
  List<Object?> get props => [message];
}
