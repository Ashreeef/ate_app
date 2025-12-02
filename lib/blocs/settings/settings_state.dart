import 'package:equatable/equatable.dart';

enum SettingsStatus { initial, loading, loaded, error, saving, saved }

class SettingsState extends Equatable {
  final SettingsStatus status;
  final bool notifications;
  final bool darkTheme;
  final String language; // 'en', 'fr', 'ar'
  final bool privateAccount;
  final bool showOnlineStatus;
  final String? errorMessage;

  const SettingsState({
    this.status = SettingsStatus.initial,
    this.notifications = true,
    this.darkTheme = false,
    this.language = 'fr',
    this.privateAccount = false,
    this.showOnlineStatus = true,
    this.errorMessage,
  });

  SettingsState copyWith({
    SettingsStatus? status,
    bool? notifications,
    bool? darkTheme,
    String? language,
    bool? privateAccount,
    bool? showOnlineStatus,
    String? errorMessage,
  }) {
    return SettingsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      darkTheme: darkTheme ?? this.darkTheme,
      language: language ?? this.language,
      privateAccount: privateAccount ?? this.privateAccount,
      showOnlineStatus: showOnlineStatus ?? this.showOnlineStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    notifications,
    darkTheme,
    language,
    privateAccount,
    showOnlineStatus,
    errorMessage,
  ];
}
