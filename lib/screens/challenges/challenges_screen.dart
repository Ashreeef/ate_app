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
import 'create_challenge_screen.dart';

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
    final userId = authState is Authenticated ? authState.user.uid : null;
    
    context.read<ChallengeBloc>().add(
      LoadActiveChallenges(userId: userId),
    );
  }

  void _handleJoinChallenge(Challenge challenge) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated || authState.user.uid == null) {
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
    if (authState is! Authenticated || authState.user.uid == null) {
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
    final authState = context.watch<AuthBloc>().state; // Watch auth state for UI updates

    return BlocListener<ChallengeBloc, ChallengeState>(
      listener: (context, state) {
        if (state is ChallengeActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          _loadChallenges(); // Reload challenges after success
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
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.challengesTitle ?? 'Challenges'),
          actions: [
            if (authState is Authenticated &&
                authState.user.isRestaurant) // Check if user is restaurant
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CreateChallengeScreen(
                        restaurantId: authState.user.restaurantId!,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
        body: BlocBuilder<ChallengeBloc, ChallengeState>(
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

            if (state is ChallengesLoaded) {
              final challenges = state.challenges;
              final participations = state.userParticipations;

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
              final availableChallenges = updatedChallenges.where((c) => !c.isJoined).toList();

              return RefreshIndicator(
                onRefresh: () async {
                  _loadChallenges();
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (activeChallenges.isNotEmpty) ...[
                        Text(
                          l10n.activeChallengesLabel ?? 'Active Challenges',
                          style: AppTextStyles.heading3,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        ...activeChallenges.map(
                          (c) => ChallengeCard(
                            challenge: c,
                            onJoinTap: () => _handleLeaveChallenge(c),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                      ],
                      Text(
                        l10n.allChallengesLabel ?? 'All Challenges',
                        style: AppTextStyles.heading3,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      if (availableChallenges.isEmpty && activeChallenges.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.xxl),
                            child: Column(
                              children: [
                                Icon(Icons.emoji_events_outlined,
                                    size: 64, color: AppColors.textLight),
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  l10n.noChallengesAvailable ??
                                      'No Challenges Available',
                                  style: AppTextStyles.heading4,
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  l10n.newChallengesWillAppear ??
                                      'New challenges will appear here',
                                  style: AppTextStyles.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ...availableChallenges.map(
                          (c) => ChallengeCard(
                            challenge: c,
                            onJoinTap: () => _handleJoinChallenge(c),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
