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
      // Use Firebase compatible method
      final user = await _userRepository.getUserByUid(event.userId.toString());

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
      // Use Firebase compatible method (returns void)
      await _userRepository.updateUserFirestore(event.user);

      final updatedUser = await _userRepository.getUserByUid(event.user.id!);
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
      final user = await _userRepository.getUserByUid(event.userId.toString());
      if (user != null) {
        final updatedUser = user.copyWith(points: event.points);
        await _userRepository.updateUserFirestore(updatedUser);

        final refreshedUser = await _userRepository.getUserByUid(event.userId.toString());
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
        final userId = _authRepository.currentUserId;
        if (userId != null) {
            final user = await _userRepository.getUserByUid(userId);
             if (user != null) {
                emit(UserLoaded(user: user));
             } else {
                emit(const UserError(message: 'User not found'));
             }
        }
      } else {
        emit(const UserError(message: 'No user logged in'));
      }
    } catch (e) {
      emit(UserError(message: 'Refresh failed: ${e.toString()}'));
    }
  }
}
