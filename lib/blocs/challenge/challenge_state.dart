import 'package:equatable/equatable.dart';
import '../../models/challenge.dart';

/// Base class for all challenge states
abstract class ChallengeState extends Equatable {
  const ChallengeState();

  @override
  List<Object?> get props => [];
}

/// Initial state before challenges are loaded
class ChallengeInitial extends ChallengeState {
  const ChallengeInitial();
}

/// State while challenges are loading
class ChallengeLoading extends ChallengeState {
  const ChallengeLoading();
}

/// State when challenges are successfully loaded
class ChallengesLoaded extends ChallengeState {
  final List<Challenge> challenges;
  final Map<String, Map<String, dynamic>> userParticipations;

  const ChallengesLoaded({
    required this.challenges,
    this.userParticipations = const {},
  });

  @override
  List<Object?> get props => [challenges, userParticipations];
}

/// State when a challenge action succeeds
class ChallengeActionSuccess extends ChallengeState {
  final String message;

  const ChallengeActionSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

/// State when loading or action fails
class ChallengeError extends ChallengeState {
  final String message;

  const ChallengeError({required this.message});

  @override
  List<Object?> get props => [message];
}
