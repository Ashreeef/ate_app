import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../l10n/app_localizations.dart';

import '../../screens/home/follow_list_screen.dart';

/// Profile header displaying avatar, stats, rank, and points
class ProfileHeader extends StatelessWidget {
  final String? userId; // User UID for navigation (required for followers/following list)
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
          // Profile Picture
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(avatarUrl),
            backgroundColor: Theme.of(context).cardTheme.color?.withOpacity(0.3) ?? Colors.grey[700],
          ),
          SizedBox(height: AppSpacing.md),

          // Username
          Text(
            username,
            style: AppTextStyles.heading3.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.sm),

          // Stats Line (Posts | Followers | Following)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatItem(context, l10n.postsCount(posts), null),
              _buildDivider(),
              _buildStatItem(
                context,
                l10n.followersCount(followers),
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
              _buildDivider(),
              _buildStatItem(
                context,
                l10n.followingCount(following),
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
          SizedBox(height: AppSpacing.sm),

          // Points Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: AppSpacing.xs),
              Text('$rank - ${l10n.pointsCount(points)}', style: AppTextStyles.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: onTap != null ? AppColors.primary : AppColors.textMedium,
            fontWeight: onTap != null ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Text(
      '|',
      style: AppTextStyles.bodySmall.copyWith(color: AppColors.divider),
    );
  }
}
