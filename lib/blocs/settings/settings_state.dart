import 'package:equatable/equatable.dart';

enum SettingsStatus { initial, loading, loaded, error }

class SettingsState extends Equatable {
  final SettingsStatus status;
  final bool notifications;
  final bool darkTheme;
  final String? errorMessage;

  const SettingsState({
    this.status = SettingsStatus.initial,
    this.notifications = true,
    this.darkTheme = false,
    this.errorMessage,
  });

  SettingsState copyWith({
    SettingsStatus? status,
    bool? notifications,
    bool? darkTheme,
    String? errorMessage,
  }) {
    return SettingsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      darkTheme: darkTheme ?? this.darkTheme,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, notifications, darkTheme, errorMessage];
}
