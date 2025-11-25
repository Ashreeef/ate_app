import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_state.dart';
import '../../repositories/profile_repository.dart';
import '../../models/user.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repo;

  ProfileCubit(this._repo) : super(const ProfileState());

  Future<void> loadProfile() async {
    try {
      emit(state.copyWith(status: ProfileStatus.loading));
      final user = await _repo.getCurrentUser();
      print(' ProfileCubit loaded user: ${user?.username} (ID: ${user?.id})');
      print(
        ' User stats - Followers: ${user?.followersCount}, Points: ${user?.points}, Level: ${user?.level}',
      );
      if (user != null) {
        emit(state.copyWith(status: ProfileStatus.loaded, user: user));
      } else {
        emit(state.copyWith(status: ProfileStatus.loaded, user: null));
      }
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.error, message: e.toString()));
    }
  }

  Future<void> saveProfile(User user) async {
    try {
      print('Saving profile: ${user.username}, ${user.displayName}');
      print(' Bio: ${user.bio}');
      print(' Phone: ${user.phone}');
      emit(state.copyWith(status: ProfileStatus.saving));
      await _repo.updateUser(user);
      print(' Profile saved successfully');
      // re-fetch latest user
      final updated = await _repo.getCurrentUser();
      print(' Reloaded user: ${updated?.username}');
      emit(state.copyWith(status: ProfileStatus.loaded, user: updated));
    } catch (e) {
      print(' Error saving profile: $e');
      emit(state.copyWith(status: ProfileStatus.error, message: e.toString()));
    }
  }
}
