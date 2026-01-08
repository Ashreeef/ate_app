import 'package:equatable/equatable.dart';
import '../../models/challenge.dart';

/// Base class for all challenge events
abstract class ChallengeEvent extends Equatable {
  const ChallengeEvent();

  @override
  List<Object?> get props => [];
}

/// Load all active challenges
class LoadActiveChallenges extends ChallengeEvent {
  final String? userId; // To check participation status

  const LoadActiveChallenges({this.userId});

  @override
  List<Object?> get props => [userId];
}

/// Load challenges joined by a specific user
class LoadUserChallenges extends ChallengeEvent {
  final String userId;

  const LoadUserChallenges({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// Create a new challenge (restaurant owners only)
class CreateChallenge extends ChallengeEvent {
  final String restaurantId;
  final String title;
  final String description;
  final ChallengeType type;
  final int targetCount;
  final DateTime startDate;
  final DateTime endDate;
  final String rewardBadge;
  final String? imageUrl;

  const CreateChallenge({
    required this.restaurantId,
    required this.title,
    required this.description,
    required this.type,
    required this.targetCount,
    required this.startDate,
    required this.endDate,
    required this.rewardBadge,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
        restaurantId,
        title,
        description,
        type,
        targetCount,
        startDate,
        endDate,
        rewardBadge,
        imageUrl,
      ];
}

/// Join a challenge
class JoinChallenge extends ChallengeEvent {
  final String challengeId;
  final String userId;

  const JoinChallenge({
    required this.challengeId,
    required this.userId,
  });

  @override
  List<Object?> get props => [challengeId, userId];
}

/// Leave a challenge
class LeaveChallenge extends ChallengeEvent {
  final String challengeId;
  final String userId;

  const LeaveChallenge({
    required this.challengeId,
    required this.userId,
  });

  @override
  List<Object?> get props => [challengeId, userId];
}

/// Update challenge progress
class UpdateChallengeProgress extends ChallengeEvent {
  final String challengeId;
  final String userId;
  final int progress;

  const UpdateChallengeProgress({
    required this.challengeId,
    required this.userId,
    required this.progress,
  });

  @override
  List<Object?> get props => [challengeId, userId, progress];
}
