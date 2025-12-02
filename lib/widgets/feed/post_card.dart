import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import 'post_header.dart';
import 'post_image.dart';
import 'post_engagement_bar.dart';
import 'post_caption.dart';
import 'post_restaurant_info.dart';

class PostCard extends StatelessWidget {
  final Map<String, dynamic> post;
  final VoidCallback onTap;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onSave;

  const PostCard({
    super.key,
    required this.post,
    required this.onTap,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onSave,
  });

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardTheme.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSizes.borderRadiusLg),
          topRight: Radius.circular(AppSizes.borderRadiusLg),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Report option
              _buildMenuOption(
                context,
                icon: Icons.flag_outlined,
                title: 'Report Post',
                color: AppColors.error,
                onTap: () {
                  Navigator.pop(context);
                  _showReportDialog(context);
                },
              ),

              // Hide option
              _buildMenuOption(
                context,
                icon: Icons.visibility_off_outlined,
                title: 'Hide Post',
                onTap: () {
                  Navigator.pop(context);
                  _showHideConfirmation(context);
                },
              ),

              // Not interested option
              _buildMenuOption(
                context,
                icon: Icons.do_not_disturb_on_outlined,
                title: 'Not Interested',
                onTap: () {
                  Navigator.pop(context);
                  _showNotInterestedConfirmation(context);
                },
              ),

              // Unfollow user option
              _buildMenuOption(
                context,
                icon: Icons.person_remove_outlined,
                title: 'Unfollow ${post['userName']}',
                onTap: () {
                  Navigator.pop(context);
                  _showUnfollowConfirmation(context);
                },
              ),

              // Copy link option
              _buildMenuOption(
                context,
                icon: Icons.link_outlined,
                title: 'Copy Link',
                onTap: () {
                  Navigator.pop(context);
                  _copyPostLink(context);
                },
              ),

              // Share to option
              _buildMenuOption(
                context,
                icon: Icons.share_outlined,
                title: 'Share to...',
                onTap: () {
                  Navigator.pop(context);
                  onShare();
                },
              ),

              const Divider(height: 1),

              // Cancel option
              _buildMenuOption(
                context,
                icon: Icons.close,
                title: 'Cancel',
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: color ?? AppColors.textDark,
        size: AppSizes.icon,
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: color ?? AppColors.textDark,
        ),
      ),
      onTap: onTap,
    );
  }

  void _showReportDialog(BuildContext context) {
    String? selectedReason;
    final reasons = [
      'Spam or misleading',
      'Harassment or hate speech',
      'Violence or dangerous content',
      'Nudity or sexual content',
      'False information',
      'Intellectual property violation',
      'Something else',
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
          ),
          title: Row(
            children: [
              Icon(Icons.flag_outlined, color: AppColors.error),
              SizedBox(width: AppSpacing.sm),
              Text('Report Post', style: AppTextStyles.heading3),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Why are you reporting this post?',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textMedium,
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                ...reasons.map((reason) {
                  return RadioListTile<String>(
                    value: reason,
                    groupValue: selectedReason,
                    onChanged: (value) {
                      setState(() {
                        selectedReason = value;
                      });
                    },
                    title: Text(reason, style: AppTextStyles.bodyMedium),
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  );
                }),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textMedium,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: selectedReason == null
                  ? null
                  : () {
                      Navigator.pop(context);
                      _showReportSuccess(context, selectedReason!);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                disabledBackgroundColor: AppColors.error.withValues(
                  alpha: AppConstants.opacityDisabled,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                ),
              ),
              child: Text(
                'Report',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReportSuccess(BuildContext context, String reason) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.white),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Thanks for reporting',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'We\'ll review this post and take appropriate action',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.white.withValues(
                        alpha: AppConstants.opacityStrong,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
        duration: Duration(seconds: 4),
      ),
    );
  }

  void _showHideConfirmation(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Post hidden from your feed',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.textDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
        action: SnackBarAction(
          label: 'Undo',
          textColor: AppColors.primary,
          onPressed: () {
            // Undo hide action
          },
        ),
      ),
    );
  }

  void _showNotInterestedConfirmation(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'We\'ll show less content like this',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.textDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
      ),
    );
  }

  void _showUnfollowConfirmation(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Unfollowed ${post['userName']}',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.textDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
        action: SnackBarAction(
          label: 'Undo',
          textColor: AppColors.primary,
          onPressed: () {
            // Undo unfollow action
          },
        ),
      ),
    );
  }

  void _copyPostLink(BuildContext context) {
    // In a real app, you would copy the actual post link
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Link copied to clipboard',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.textDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: AppSpacing.lg),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post header with profile navigation enabled
          PostHeader(
            userId: post['userId'] as int?, // Pass userId for profile lookup
            userName: post['userName'],
            userAvatar: post['userAvatar'],
            onProfileTap: onTap,
            onMoreTap: () => _showOptionsMenu(context),
          ),
          PostImage(imageUrl: post['imageUrl'], onDoubleTap: onLike),
          PostEngagementBar(
            isLiked: post['isLiked'] ?? false,
            isSaved: post['isSaved'] ?? false,
            onLikeTap: onLike,
            onCommentTap: onComment,
            onSaveTap: onSave,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(
              '${post['likes'] ?? 0} likes',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          PostCaption(userName: post['userName'], caption: post['caption']),
          SizedBox(height: AppSpacing.sm),
          PostRestaurantInfo(
            restaurantName: post['restaurantName'],
            dishName: post['dishName'],
            rating: post['rating'],
          ),
          SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}
