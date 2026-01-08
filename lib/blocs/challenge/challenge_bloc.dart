import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/challenge_repository.dart';
import 'challenge_event.dart';
import 'challenge_state.dart';

/// BLoC for handling challenge operations
class ChallengeBloc extends Bloc<ChallengeEvent, ChallengeState> {
  final ChallengeRepository _challengeRepository;

  ChallengeBloc({
    required ChallengeRepository challengeRepository,
  })  : _challengeRepository = challengeRepository,
        super(const ChallengeInitial()) {
    on<LoadActiveChallenges>(_onLoadActiveChallenges);
    on<LoadUserChallenges>(_onLoadUserChallenges);
    on<CreateChallenge>(_onCreateChallenge);
    on<JoinChallenge>(_onJoinChallenge);
    on<LeaveChallenge>(_onLeaveChallenge);
    on<UpdateChallengeProgress>(_onUpdateChallengeProgress);
  }

  /// Load all active challenges
  Future<void> _onLoadActiveChallenges(
    LoadActiveChallenges event,
    Emitter<ChallengeState> emit,
  ) async {
    emit(const ChallengeLoading());

    try {
      final challenges = await _challengeRepository.getActiveChallenges();

      // If userId is provided, load their participation data
      final participations = <String, Map<String, dynamic>>{};
      if (event.userId != null) {
        for (final challenge in challenges) {
          final participation = await _challengeRepository
              .getChallengeParticipation(challenge.id, event.userId!);
          if (participation != null) {
            participations[challenge.id] = participation;
          }
        }
      }

      emit(ChallengesLoaded(
        challenges: challenges,
        userParticipations: participations,
      ));
    } catch (e) {
      print('Error loading challenges: $e');
      emit(ChallengeError(
        message: 'Failed to load challenges: ${e.toString()}',
      ));
    }
  }

  /// Load challenges joined by user
  Future<void> _onLoadUserChallenges(
    LoadUserChallenges event,
    Emitter<ChallengeState> emit,
  ) async {
    emit(const ChallengeLoading());

    try {
      final challenges =
          await _challengeRepository.getUserActiveChallenges(event.userId);

      emit(ChallengesLoaded(challenges: challenges));
    } catch (e) {
      print('Error loading user challenges: $e');
      emit(ChallengeError(
        message: 'Failed to load your challenges: ${e.toString()}',
      ));
    }
  }

  /// Create a new challenge
  Future<void> _onCreateChallenge(
    CreateChallenge event,
    Emitter<ChallengeState> emit,
  ) async {
    emit(const ChallengeLoading());

    try {
      await _challengeRepository.createChallenge(
        restaurantId: event.restaurantId,
        title: event.title,
        description: event.description,
        type: event.type,
        targetCount: event.targetCount,
        startDate: event.startDate,
        endDate: event.endDate,
        rewardBadge: event.rewardBadge,
        imageUrl: event.imageUrl,
      );

      emit(const ChallengeActionSuccess(
        message: 'Challenge created successfully!',
      ));

      // Reload challenges
      add(const LoadActiveChallenges());
    } catch (e) {
      print('Error creating challenge: $e');
      emit(ChallengeError(
        message: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  /// Join a challenge
  Future<void> _onJoinChallenge(
    JoinChallenge event,
    Emitter<ChallengeState> emit,
  ) async {
    try {
      await _challengeRepository.joinChallenge(
        event.challengeId,
        event.userId,
      );

      emit(const ChallengeActionSuccess(
        message: 'Successfully joined challenge!',
      ));

      // Reload challenges with user data
      add(LoadActiveChallenges(userId: event.userId));
    } catch (e) {
      print('Error joining challenge: $e');
      emit(ChallengeError(
        message: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  /// Leave a challenge
  Future<void> _onLeaveChallenge(
    LeaveChallenge event,
    Emitter<ChallengeState> emit,
  ) async {
    try {
      await _challengeRepository.leaveChallenge(
        event.challengeId,
        event.userId,
      );

      emit(const ChallengeActionSuccess(
        message: 'Left challenge successfully',
      ));

      // Reload challenges
      add(LoadActiveChallenges(userId: event.userId));
    } catch (e) {
      print('Error leaving challenge: $e');
      emit(ChallengeError(
        message: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  /// Update challenge progress
  Future<void> _onUpdateChallengeProgress(
    UpdateChallengeProgress event,
    Emitter<ChallengeState> emit,
  ) async {
    try {
      await _challengeRepository.updateProgress(
        challengeId: event.challengeId,
        userId: event.userId,
        progress: event.progress,
      );

      // Check if challenge is completed
      final isCompleted = await _challengeRepository.isChallengeCompleted(
        event.challengeId,
        event.userId,
      );

      if (isCompleted) {
        emit(const ChallengeActionSuccess(
          message: '🎉 Challenge completed! You earned a badge!',
        ));
      }

      // Reload challenges
      add(LoadActiveChallenges(userId: event.userId));
    } catch (e) {
      print('Error updating progress: $e');
      emit(ChallengeError(
        message: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }
}
