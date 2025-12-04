import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/challenges/challenge_card.dart';
import '../../data/fake_restaurants.dart';
import '../../models/challenge.dart';
import '../../l10n/app_localizations.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  List<Challenge> _allChallenges = [];
  List<Challenge> _activeChallenges = [];

  @override
  void initState() {
    super.initState();
    _loadChallenges();
  }

  void _loadChallenges() {
    try {
      _allChallenges = FakeData.getChallenges();
      _activeChallenges = FakeData.getActiveChallenges();
    } catch (e) {
      _allChallenges = [];
      _activeChallenges = [];
    }
  }

  void _handleJoinChallenge(Challenge challenge) {
    setState(() {
      // Update in all challenges
      final index = _allChallenges.indexWhere((c) => c.id == challenge.id);
      if (index != -1) {
        _allChallenges[index] = challenge.copyWith(isJoined: true);
      }
      // Update in active challenges if present
      final activeIndex = _activeChallenges.indexWhere(
        (c) => c.id == challenge.id,
      );
      if (activeIndex != -1) {
        _activeChallenges[activeIndex] = challenge.copyWith(isJoined: true);
      }
    });

    // Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.joined),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Active Challenges Section (at top)
              if (_activeChallenges.isNotEmpty) ...[
                Text(l10n.activeChallengesLabel, style: AppTextStyles.heading3),
                SizedBox(height: AppSpacing.md),
                ..._activeChallenges.map((challenge) {
                  return ChallengeCard(
                    challenge: challenge,
                    onJoinTap: challenge.isJoined
                        ? null
                        : () => _handleJoinChallenge(challenge),
                  );
                }),
                SizedBox(height: AppSpacing.xl),
              ],

              // All Challenges Section
              Text(l10n.allChallengesLabel, style: AppTextStyles.heading3),
              SizedBox(height: AppSpacing.md),
              if (_allChallenges.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.xxl),
                    child: Column(
                      children: [
                        Icon(
                          Icons.emoji_events_outlined,
                          size: 64,
                          color: AppColors.textLight,
                        ),
                        SizedBox(height: AppSpacing.md),
                        Text(
                          l10n.noChallengesAvailable,
                          style: AppTextStyles.heading4,
                        ),
                        SizedBox(height: AppSpacing.xs),
                        Text(
                          l10n.newChallengesWillAppear,
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                )
              else
                ..._allChallenges.map((challenge) {
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
      ),
    );
  }
}
