import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_state.dart';
import '../../repositories/profile_repository.dart';
import '../../models/user.dart';

/// Cubit managing user profile state and operations
class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repo;

  ProfileCubit(this._repo) : super(const ProfileState());

  /// Load current user profile from database
  Future<void> loadProfile() async {
    try {
      emit(state.copyWith(status: ProfileStatus.loading));
      final user = await _repo.getCurrentUser();
      if (user != null) {
        emit(state.copyWith(status: ProfileStatus.loaded, user: user));
      } else {
        emit(state.copyWith(status: ProfileStatus.loaded, user: null));
      }
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.error, message: e.toString()));
    }
  }

  /// Save updated profile to database
  Future<void> saveProfile(User user) async {
    try {
      emit(state.copyWith(status: ProfileStatus.saving));
      await _repo.updateUser(user);
      // re-fetch latest user
      final updated = await _repo.getCurrentUser();
      emit(state.copyWith(status: ProfileStatus.loaded, user: updated));
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.error, message: e.toString()));
    }
  }
}
