import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../l10n/app_localizations.dart';

import '../../screens/home/follow_list_screen.dart';

/// Profile header displaying avatar, stats, rank, and points
class ProfileHeader extends StatelessWidget {
  final String?
  userId; // User UID for navigation (required for followers/following list)
  final String avatarUrl;
  final String username;
  final int posts;
  final int followers;
  final int following;
  final String rank;
  final int points;

  const ProfileHeader({
    super.key,
    this.userId,
    required this.avatarUrl,
    required this.username,
    required this.posts,
    required this.followers,
    required this.following,
    required this.rank,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      color: Theme.of(context).cardTheme.color,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        children: [
          // Profile Picture with enhanced default avatar
          _buildProfileAvatar(),
          SizedBox(height: AppSpacing.md),

          // Username
          Text(
            username,
            style: AppTextStyles.heading3.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.sm),

          // Enhanced Stats Display
          Container(
            margin: EdgeInsets.symmetric(vertical: AppSpacing.sm),
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color?.withOpacity(0.5),
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildEnhancedStatItem(
                  context,
                  posts.toString(),
                  l10n.posts,
                  null,
                ),
                _buildStatDivider(),
                _buildEnhancedStatItem(
                  context,
                  followers.toString(),
                  l10n.followers,
                  userId != null
                      ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FollowListScreen(
                              userId: userId!,
                              isFollowers: true,
                            ),
                          ),
                        )
                      : null,
                ),
                _buildStatDivider(),
                _buildEnhancedStatItem(
                  context,
                  following.toString(),
                  l10n.following,
                  userId != null
                      ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FollowListScreen(
                              userId: userId!,
                              isFollowers: false,
                            ),
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.sm),

          // Enhanced Points and Rank Indicator
          Container(
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
              border: Border.all(
                color: Colors.amber.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                SizedBox(width: AppSpacing.xs),
                Text(
                  rank,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: AppSpacing.xs),
                Text(
                  '•',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textMedium,
                  ),
                ),
                SizedBox(width: AppSpacing.xs),
                Text(
                  '${l10n.pointsCount(points)}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build enhanced stat item with better styling
  Widget _buildEnhancedStatItem(
    BuildContext context,
    String count,
    String label,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count,
            style: AppTextStyles.heading3.copyWith(
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
    );
  }

  /// Build stat divider with better styling
  Widget _buildStatDivider() {
    return Container(
      height: 40,
      width: 1,
      color: AppColors.divider.withOpacity(0.5),
    );
  }

  /// Build profile avatar with fallback to default avatar
  Widget _buildProfileAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 3),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 50,
        backgroundColor: AppColors.primaryLight.withOpacity(0.1),
        child: avatarUrl.isNotEmpty
            ? ClipOval(
                child: Image.network(
                  avatarUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildDefaultAvatar();
                  },
                ),
              )
            : _buildDefaultAvatar(),
      ),
    );
  }

  /// Build default avatar with user initial
  Widget _buildDefaultAvatar() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryLight],
        ),
      ),
      child: Center(
        child: Text(
          username.isNotEmpty ? username[0].toUpperCase() : '?',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
