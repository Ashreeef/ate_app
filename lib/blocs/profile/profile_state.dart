import 'package:equatable/equatable.dart';
import '../../models/user.dart';

enum ProfileStatus { initial, loading, loaded, saving, error }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final User? user;
  final String? message;

  const ProfileState({this.status = ProfileStatus.initial, this.user, this.message});

  ProfileState copyWith({ProfileStatus? status, User? user, String? message}) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, user, message];
}
