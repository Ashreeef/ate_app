import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_state.dart';
import '../../repositories/profile_repository.dart';
import '../../models/user.dart';
import '../../utils/password_helper.dart';

class SettingsCubit extends Cubit<SettingsState> {
  static const _kNotificationsKey = 'pref_notifications';
  static const _kDarkThemeKey = 'pref_dark_theme';
  static const _kLanguageKey = 'pref_language';
  static const _kPrivateAccountKey = 'pref_private_account';
  static const _kShowOnlineStatusKey = 'pref_show_online_status';

  final ProfileRepository _profileRepository;

  SettingsCubit({ProfileRepository? profileRepository})
    : _profileRepository = profileRepository ?? ProfileRepository(),
      super(const SettingsState());

  Future<void> loadSettings() async {
    try {
      emit(state.copyWith(status: SettingsStatus.loading));

      final prefs = await SharedPreferences.getInstance();
      final notifications = prefs.getBool(_kNotificationsKey) ?? true;
      final darkTheme = prefs.getBool(_kDarkThemeKey) ?? false;
      final language = prefs.getString(_kLanguageKey) ?? 'fr';
      final privateAccount = prefs.getBool(_kPrivateAccountKey) ?? false;
      final showOnlineStatus = prefs.getBool(_kShowOnlineStatusKey) ?? true;

      emit(
        state.copyWith(
          status: SettingsStatus.loaded,
          notifications: notifications,
          darkTheme: darkTheme,
          language: language,
          privateAccount: privateAccount,
          showOnlineStatus: showOnlineStatus,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SettingsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> setNotifications(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kNotificationsKey, value);
      emit(state.copyWith(notifications: value));
    } catch (e) {
      emit(
        state.copyWith(
          status: SettingsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> setDarkTheme(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kDarkThemeKey, value);
      emit(state.copyWith(darkTheme: value));
    } catch (e) {
      emit(
        state.copyWith(
          status: SettingsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> setLanguage(String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kLanguageKey, value);
      emit(state.copyWith(language: value));
    } catch (e) {
      emit(
        state.copyWith(
          status: SettingsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> setPrivateAccount(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kPrivateAccountKey, value);
      emit(state.copyWith(privateAccount: value));
    } catch (e) {
      emit(
        state.copyWith(
          status: SettingsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> setShowOnlineStatus(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kShowOnlineStatusKey, value);
      emit(state.copyWith(showOnlineStatus: value));
    } catch (e) {
      emit(
        state.copyWith(
          status: SettingsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<bool> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      emit(state.copyWith(status: SettingsStatus.saving));

      // Get current user
      final currentUser = await _profileRepository.getCurrentUser();

      if (currentUser == null) {
        emit(
          state.copyWith(
            status: SettingsStatus.error,
            errorMessage: 'User not found',
          ),
        );
        return false;
      }

      // Check if user has a password set
      if (currentUser.password == null || currentUser.password!.isEmpty) {
        emit(
          state.copyWith(
            status: SettingsStatus.error,
            errorMessage: 'No password set for this account',
          ),
        );
        return false;
      }

      // Verify current password using secure comparison
      if (!PasswordHelper.verifyPassword(
        currentPassword,
        currentUser.password!,
      )) {
        emit(
          state.copyWith(
            status: SettingsStatus.error,
            errorMessage: 'Current password is incorrect',
          ),
        );
        return false;
      }

      // Hash new password before storing
      final hashedPassword = PasswordHelper.hashPassword(newPassword);

      // Update password
      final updatedUser = User(
        id: currentUser.id,
        username: currentUser.username,
        email: currentUser.email,
        password: hashedPassword,
        displayName: currentUser.displayName,
        phone: currentUser.phone,
        profileImage: currentUser.profileImage,
        bio: currentUser.bio,
        followersCount: currentUser.followersCount,
        followingCount: currentUser.followingCount,
        points: currentUser.points,
        level: currentUser.level,
      );

      await _profileRepository.updateUser(updatedUser);

      emit(state.copyWith(status: SettingsStatus.saved));
      await Future.delayed(Duration(milliseconds: 100));
      emit(state.copyWith(status: SettingsStatus.loaded));
      return true;
    } catch (e) {
      emit(
        state.copyWith(
          status: SettingsStatus.error,
          errorMessage: e.toString(),
        ),
      );
      return false;
    }
  }

  Future<void> logout() async {
    try {
      emit(state.copyWith(status: SettingsStatus.saving));

      // Clear current user session
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_id'); // Match the key in AuthService if possible, or 'current_user_id' if that's what's used. AuthService uses 'user_id'. ProfileRepository uses 'current_user_id'. There might be inconsistency here.
      // ProfileRepository uses _kCurrentUserIdKey = 'current_user_id'. AuthService uses _keyUserId = 'user_id'.
      // This is a bug in the app structure (two keys?).
      // For now, I'll stick to what was there but change type. 
      // Original SettingsCubit.logout removed 'current_user_id'.
      await prefs.remove('current_user_id');

      emit(state.copyWith(status: SettingsStatus.saved));
    } catch (e) {
      emit(
        state.copyWith(
          status: SettingsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<bool> deleteAccount() async {
    try {
      emit(state.copyWith(status: SettingsStatus.saving));

      // Get current user ID
      final prefs = await SharedPreferences.getInstance();
      final currentUserId = prefs.getString('current_user_id');

      if (currentUserId != null) {
        // Delete user from database
        await _profileRepository.deleteUser(currentUserId);
      }

      // Clear all settings
      await prefs.clear();

      emit(state.copyWith(status: SettingsStatus.saved));
      return true;
    } catch (e) {
      emit(
        state.copyWith(
          status: SettingsStatus.error,
          errorMessage: e.toString(),
        ),
      );
      return false;
    }
  }

  Future<void> clearCache() async {
    try {
      emit(state.copyWith(status: SettingsStatus.saving));

      
      await Future.delayed(Duration(milliseconds: 500));

      emit(state.copyWith(status: SettingsStatus.saved));
      await Future.delayed(Duration(milliseconds: 100));
      emit(state.copyWith(status: SettingsStatus.loaded));
    } catch (e) {
      emit(
        state.copyWith(
          status: SettingsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
