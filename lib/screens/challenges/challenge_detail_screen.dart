import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/challenge/challenge_bloc.dart';
import '../../blocs/challenge/challenge_event.dart';
import '../../blocs/challenge/challenge_state.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../models/challenge.dart';
import '../../utils/constants.dart';
import '../../l10n/app_localizations.dart';

class ChallengeDetailScreen extends StatefulWidget {
  final Challenge challenge;

  const ChallengeDetailScreen({
    super.key,
    required this.challenge,
  });

  @override
  State<ChallengeDetailScreen> createState() => _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends State<ChallengeDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final challenge = widget.challenge;

    // Calculate progress percentage
    final progress = challenge.targetCount > 0
        ? (challenge.currentCount / challenge.targetCount).clamp(0.0, 1.0)
        : 0.0;

    // Calculate days remaining
    final now = DateTime.now();
    final daysRemaining = challenge.endDate.difference(now).inDays;
    final isActive = now.isBefore(challenge.endDate) &&
        now.isAfter(challenge.startDate) &&
        challenge.isActive;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.challengeDetails ?? 'Challenge Details'),
        centerTitle: true,
      ),
      body: BlocListener<ChallengeBloc, ChallengeState>(
        listener: (context, state) {
          if (state is ChallengeActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Challenge Image
              if (challenge.imageUrl != null)
                Image.network(
                  challenge.imageUrl!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: AppColors.primary.withOpacity(0.1),
                      child: const Icon(
                        Icons.emoji_events,
                        size: 80,
                        color: AppColors.primary,
                      ),
                    );
                  },
                )
              else
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    size: 100,
                    color: Colors.white,
                  ),
                ),

              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      challenge.title,
                      style: AppTextStyles.heading2,
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Challenge Type Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getChallengeTypeLabel(challenge.type),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Status Badge
                    Row(
                      children: [
                        Icon(
                          isActive ? Icons.access_time : Icons.schedule,
                          size: 16,
                          color: isActive ? Colors.green : Colors.grey,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          isActive
                              ? '${l10n.daysRemaining ?? "Days Remaining"}: $daysRemaining'
                              : l10n.challengeEnded ?? 'Challenge Ended',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isActive ? Colors.green : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Description
                    Text(
                      l10n.description ?? 'Description',
                      style: AppTextStyles.heading4,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      challenge.description,
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Progress Section (if joined)
                    if (challenge.isJoined) ...[
                      Text(
                        l10n.yourProgress ?? 'Your Progress',
                        style: AppTextStyles.heading4,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${challenge.currentCount} / ${challenge.targetCount}',
                                  style: AppTextStyles.heading3.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                                Text(
                                  '${(progress * 100).toInt()}%',
                                  style: AppTextStyles.heading4.copyWith(
                                    color: AppColors.textLight,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.grey.withOpacity(0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                              minHeight: 10,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],

                    // Reward Section
                    Text(
                      l10n.reward ?? 'Reward',
                      style: AppTextStyles.heading4,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.amber.shade100,
                            Colors.amber.shade50,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.emoji_events,
                            color: Colors.amber,
                            size: 32,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  challenge.rewardBadge,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '+100 points',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Date Range
                    Text(
                      l10n.dateRange ?? 'Date Range',
                      style: AppTextStyles.heading4,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Expanded(
                          child: _DateCard(
                            label: l10n.startDate ?? 'Start',
                            date: challenge.startDate,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        const Icon(Icons.arrow_forward, size: 20),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: _DateCard(
                            label: l10n.endDate ?? 'End',
                            date: challenge.endDate,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // Action Button
                    if (isActive)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _handleJoinLeave(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: challenge.isJoined
                                ? Colors.red
                                : AppColors.primary,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md,
                            ),
                          ),
                          child: Text(
                            challenge.isJoined
                                ? (l10n.leaveChallenge ?? 'Leave Challenge')
                                : (l10n.joinChallenge ?? 'Join Challenge'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleJoinLeave(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated || authState.user.uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (widget.challenge.isJoined) {
      context.read<ChallengeBloc>().add(
            LeaveChallenge(
              challengeId: widget.challenge.id,
              userId: authState.user.uid!,
            ),
          );
    } else {
      context.read<ChallengeBloc>().add(
            JoinChallenge(
              challengeId: widget.challenge.id,
              userId: authState.user.uid!,
            ),
          );
    }

    Navigator.of(context).pop();
  }

  String _getChallengeTypeLabel(ChallengeType type) {
    switch (type) {
      case ChallengeType.general:
        return 'General';
      case ChallengeType.restaurant:
        return 'Restaurant-Specific';
      case ChallengeType.dish:
        return 'Dish-Specific';
      case ChallengeType.location:
        return 'Location-Based';
    }
  }
}

class _DateCard extends StatelessWidget {
  final String label;
  final DateTime date;

  const _DateCard({
    required this.label,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${date.month}/${date.day}/${date.year}',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
