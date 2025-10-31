import 'package:flutter/material.dart';
import '../../models/challenge.dart';
import '../../utils/constants.dart';

class ChallengeCard extends StatelessWidget {
  final Challenge challenge;
  final VoidCallback? onJoinTap;
  final VoidCallback? onTap;

  const ChallengeCard({
    Key? key,
    required this.challenge,
    this.onJoinTap,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Challenge Image (if available)
            if (challenge.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.borderRadius),
                  topRight: Radius.circular(AppSizes.borderRadius),
                ),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  color: AppColors.background,
                  child: Image.network(
                    challenge.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildPlaceholderImage();
                    },
                  ),
                ),
              ),
            // Challenge Content
            Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              challenge.title,
                              style: AppTextStyles.heading4,
                            ),
                            SizedBox(height: AppSpacing.xs),
                            Text(
                              challenge.description,
                              style: AppTextStyles.bodySmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Reward Badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(
                            AppSizes.borderRadiusSm,
                          ),
                        ),
                        child: Text(
                          challenge.rewardBadge,
                          style: AppTextStyles.badge,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.md),
                  // Progress Bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progrès',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${challenge.currentCount}/${challenge.targetCount}',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.xs),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AppSizes.borderRadiusSm,
                        ),
                        child: LinearProgressIndicator(
                          value: challenge.progress.clamp(0.0, 1.0),
                          minHeight: 8,
                          backgroundColor: AppColors.background,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        '${(challenge.progress * 100).toStringAsFixed(0)}% complété',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.md),
                  // Join Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: challenge.isJoined ? null : onJoinTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: challenge.isJoined
                            ? AppColors.background
                            : AppColors.primary,
                        foregroundColor: challenge.isJoined
                            ? AppColors.textMedium
                            : AppColors.white,
                      ),
                      child: Text(
                        challenge.isJoined ? 'Rejoint!' : 'Rejoindre',
                        style: AppTextStyles.buttonSmall,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: AppColors.background,
      child: Center(
        child: Icon(
          Icons.emoji_events,
          size: AppSizes.iconXl,
          color: AppColors.textLight,
        ),
      ),
    );
  }
}
