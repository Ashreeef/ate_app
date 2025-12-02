import 'package:equatable/equatable.dart';
import '../../models/user.dart';

/// Base class for all user events
abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load user details
class LoadUser extends UserEvent {
  final int userId;

  const LoadUser({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// Event to update user profile
class UpdateUser extends UserEvent {
  final User user;

  const UpdateUser({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Event to update user points
class UpdateUserPoints extends UserEvent {
  final int userId;
  final int points;

  const UpdateUserPoints({required this.userId, required this.points});

  @override
  List<Object?> get props => [userId, points];
}

/// Event to refresh user data
class RefreshUser extends UserEvent {
  const RefreshUser();
}
