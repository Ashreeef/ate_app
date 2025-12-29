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
  final String uid;

  const LoadUser({required this.uid});

  @override
  List<Object?> get props => [uid];
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
  final String uid;
  final int points;

  const UpdateUserPoints({required this.uid, required this.points});

  @override
  List<Object?> get props => [uid, points];
}

/// Event to refresh user data
class RefreshUser extends UserEvent {
  const RefreshUser();
}
