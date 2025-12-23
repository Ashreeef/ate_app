import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_event.dart';
import 'user_state.dart';
import '../../repositories/user_repository.dart';
import '../../repositories/auth_repository.dart';

/// Bloc for handling user profile management
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;
  final AuthRepository _authRepository;

  UserBloc({
    required UserRepository userRepository,
    required AuthRepository authRepository,
  }) : _userRepository = userRepository,
       _authRepository = authRepository,
       super(const UserInitial()) {
    on<LoadUser>(_onLoadUser);
    on<UpdateUser>(_onUpdateUser);
    on<UpdateUserPoints>(_onUpdateUserPoints);
    on<RefreshUser>(_onRefreshUser);
  }

  /// Load user details
  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    emit(const UserLoading());

    try {
      final user = await _userRepository.getUserById(event.userId);

      if (user != null) {
        emit(UserLoaded(user: user));
      } else {
        emit(const UserError(message: 'User not found'));
      }
    } catch (e) {
      emit(UserError(message: 'Failed to load user: ${e.toString()}'));
    }
  }

  /// Update user profile
  Future<void> _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    emit(const UserLoading());

    try {
      final result = await _userRepository.updateUser(event.user);

      if (result > 0) {
        final updatedUser = await _userRepository.getUserById(event.user.id!);
        if (updatedUser != null) {
          emit(
            UserUpdateSuccess(
              user: updatedUser,
              message: 'Profile updated successfully',
            ),
          );
        } else {
          emit(const UserError(message: 'Failed to fetch updated user'));
        }
      } else {
        emit(const UserError(message: 'Failed to update profile'));
      }
    } catch (e) {
      emit(UserError(message: 'Update failed: ${e.toString()}'));
    }
  }

  /// Update user points
  Future<void> _onUpdateUserPoints(
    UpdateUserPoints event,
    Emitter<UserState> emit,
  ) async {
    try {
      final user = await _userRepository.getUserById(event.userId);
      if (user != null) {
        final updatedUser = user.copyWith(points: event.points);
        await _userRepository.updateUser(updatedUser);

        final refreshedUser = await _userRepository.getUserById(event.userId);
        if (refreshedUser != null) {
          emit(UserLoaded(user: refreshedUser));
        }
      }
    } catch (e) {
      emit(UserError(message: 'Failed to update points: ${e.toString()}'));
    }
  }

  /// Refresh current user data
  Future<void> _onRefreshUser(
    RefreshUser event,
    Emitter<UserState> emit,
  ) async {
    try {
      if (_authRepository.isAuthenticated) {
        final user = await _authRepository.getCurrentUser();

        if (user != null) {
          emit(UserLoaded(user: user));
        } else {
          emit(const UserError(message: 'User not found'));
        }
      } else {
        emit(const UserError(message: 'No user logged in'));
      }
    } catch (e) {
      emit(UserError(message: 'Refresh failed: ${e.toString()}'));
    }
  }
}
