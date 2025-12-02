import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class ProfileHeader extends StatelessWidget {
  final String avatarUrl;
  final String username;
  final int posts;
  final int followers;
  final int following;
  final String rank;
  final int points;

  const ProfileHeader({
    super.key,
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
            backgroundColor: AppColors.backgroundLight,
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
          Text(
            '$posts Posts | $followers Followers | $following Following',
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
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
              Text('$rank - $points Points', style: AppTextStyles.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}
