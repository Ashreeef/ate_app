import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../l10n/app_localizations.dart';

/// Enhanced stats bar widget for profile screen with better visual design
class ProfileStatsBar extends StatelessWidget {
  final int posts;
  final int followers;
  final int following;
  final int points;
  final String rank;
  final Function()? onPostsTap;
  final Function()? onFollowersTap;
  final Function()? onFollowingTap;

  const ProfileStatsBar({
    super.key,
    required this.posts,
    required this.followers,
    required this.following,
    required this.points,
    required this.rank,
    this.onPostsTap,
    this.onFollowersTap,
    this.onFollowingTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(color: AppColors.primary.withOpacity(0.1), width: 1),
      ),
      child: Column(
        children: [
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(context, posts.toString(), l10n.posts, onPostsTap),
              _buildDivider(),
              _buildStatItem(
                context,
                followers.toString(),
                l10n.followers,
                onFollowersTap,
              ),
              _buildDivider(),
              _buildStatItem(
                context,
                following.toString(),
                l10n.following,
                onFollowingTap,
              ),
            ],
          ),

          SizedBox(height: AppSpacing.sm),

          // Rank and Points Row
          _buildRankSection(context, l10n),
        ],
      ),
    );
  }

  /// Build individual stat item
  Widget _buildStatItem(
    BuildContext context,
    String count,
    String label,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          color: onTap != null
              ? AppColors.primary.withOpacity(0.05)
              : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              count,
              style: AppTextStyles.heading2.copyWith(
                fontWeight: FontWeight.bold,
                color: onTap != null
                    ? AppColors.primary
                    : Theme.of(context).textTheme.headlineMedium?.color,
              ),
            ),
            SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textMedium,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build stat divider
  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: AppColors.divider.withOpacity(0.3),
    );
  }

  /// Build rank and points section
  Widget _buildRankSection(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.amber.withOpacity(0.1),
            AppColors.primary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        border: Border.all(color: Colors.amber.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.star_rounded, color: Colors.amber, size: 20),
          SizedBox(width: AppSpacing.xs),
          Text(
            rank,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: AppSpacing.xs),
          Text(
            '•',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textMedium,
            ),
          ),
          SizedBox(width: AppSpacing.xs),
          Icon(Icons.emoji_events_rounded, color: AppColors.primary, size: 16),
          SizedBox(width: AppSpacing.xs),
          Text(
            '${l10n.pointsCount(points)}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textMedium,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
