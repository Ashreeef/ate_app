import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  static const _kNotificationsKey = 'pref_notifications';
  static const _kDarkThemeKey = 'pref_dark_theme';

  SettingsCubit() : super(const SettingsState());

  Future<void> loadSettings() async {
    try {
      emit(state.copyWith(status: SettingsStatus.loading));
      
      final prefs = await SharedPreferences.getInstance();
      final notifications = prefs.getBool(_kNotificationsKey) ?? true;
      final darkTheme = prefs.getBool(_kDarkThemeKey) ?? false;

      emit(state.copyWith(
        status: SettingsStatus.loaded,
        notifications: notifications,
        darkTheme: darkTheme,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> setNotifications(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kNotificationsKey, value);
      emit(state.copyWith(notifications: value));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> setDarkTheme(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kDarkThemeKey, value);
      emit(state.copyWith(darkTheme: value));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
