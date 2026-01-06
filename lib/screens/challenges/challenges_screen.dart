import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/constants.dart';
import '../../widgets/challenges/challenge_card.dart';
import '../../models/challenge.dart';
import '../../l10n/app_localizations.dart';
import '../../blocs/challenge/challenge_bloc.dart';
import '../../blocs/challenge/challenge_event.dart';
import '../../blocs/challenge/challenge_state.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  @override
  void initState() {
    super.initState();
    _loadChallenges();
  }

  void _loadChallenges() {
    // Get current user ID for participation status
    final authState = context.read<AuthBloc>().state;
    final userId = authState is AuthAuthenticated ? authState.user.uid : null;
    
    context.read<ChallengeBloc>().add(
      LoadActiveChallenges(userId: userId),
    );
  }

  void _handleJoinChallenge(Challenge challenge) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated || authState.user.uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in to join challenges'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<ChallengeBloc>().add(
      JoinChallenge(
        challengeId: challenge.id,
        userId: authState.user.uid!,
      ),
    );
  }

  void _handleLeaveChallenge(Challenge challenge) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated || authState.user.uid == null) {
      return;
    }

    context.read<ChallengeBloc>().add(
      LeaveChallenge(
        challengeId: challenge.id,
        userId: authState.user.uid!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: SafeArea(
        child: BlocListener<ChallengeBloc, ChallengeState>(
          listener: (context, state) {
            if (state is ChallengeActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
            } else if (state is ChallengeError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
          child: BlocBuilder<ChallengeBloc, ChallengeState>(
            builder: (context, state) {
              if (state is ChallengeLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ChallengeError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          l10n.errorOccurred ?? 'Error',
                          style: AppTextStyles.heading3,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          state.message,
                          style: AppTextStyles.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        ElevatedButton(
                          onPressed: _loadChallenges,
                          child: Text(l10n.retry ?? 'Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final challenges = state is ChallengesLoaded ? state.challenges : <Challenge>[];
              final participations = state is ChallengesLoaded ? state.userParticipations : <String, Map<String, dynamic>>{};

              // Update challenges with participation data
              final updatedChallenges = challenges.map((challenge) {
                final participation = participations[challenge.id];
                if (participation != null) {
                  return challenge.copyWith(
                    isJoined: true,
                    currentCount: participation['currentProgress'] as int? ?? 0,
                  );
                }
                return challenge;
              }).toList();

              // Separate active (joined) and all challenges
              final activeChallenges = updatedChallenges.where((c) => c.isJoined).toList();

              return RefreshIndicator(
                onRefresh: () async {
                  _loadChallenges();
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Active Challenges Section (at top)
                      if (activeChallenges.isNotEmpty) ...[
                        Text(l10n.activeChallengesLabel, style: AppTextStyles.heading3),
                        const SizedBox(height: AppSpacing.md),
                        ...activeChallenges.map((challenge) {
                          return ChallengeCard(
                            challenge: challenge,
                            onJoinTap: () => _handleLeaveChallenge(challenge),
                          );
                        }),
                        const SizedBox(height: AppSpacing.xl),
                      ],

                      // All Challenges Section
                      Text(l10n.allChallengesLabel, style: AppTextStyles.heading3),
                      const SizedBox(height: AppSpacing.md),
                      if (updatedChallenges.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.xxl),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.emoji_events_outlined,
                                  size: 64,
                                  color: AppColors.textLight,
                                ),
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  l10n.noChallengesAvailable,
                                  style: AppTextStyles.heading4,
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  l10n.newChallengesWillAppear,
                                  style: AppTextStyles.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ...updatedChallenges.map((challenge) {
                          return ChallengeCard(
                            challenge: challenge,
                            onJoinTap: challenge.isJoined
                                ? null
                                : () => _handleJoinChallenge(challenge),
                          );
                        }),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
