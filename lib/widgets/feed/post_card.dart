import 'package:flutter/material.dart';
import 'package:ate_app/utils/constants.dart';

class PostCard extends StatelessWidget {
  final Map<String, dynamic> post;
  final VoidCallback onTap;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onSave;

  const PostCard({
    Key? key,
    required this.post,
    required this.onTap,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onSave,
  }) : super(key: key);

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
        ),
        title: Text(
          'Report Post',
          style: AppTextStyles.heading3,
        ),
        content: Text(
          'Why are you reporting this post?',
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTextStyles.link,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showReportSuccess(context);
            },
            child: Text(
              'Report',
              style: AppTextStyles.buttonSmall,
            ),
          ),
        ],
      ),
    );
  }

  void _showReportSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Post reported successfully',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.textDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
      ),
    );
  }

  void _showHideConfirmation(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Post hidden from your feed',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.white,
          ),
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
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.white,
          ),
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
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.white,
          ),
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
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.white,
          ),
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
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
      color: AppColors.white,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with user info
            _buildHeader(context),
            
            // Post image
            _buildImage(),
            
            // Actions (like, comment, share, save)
            _buildActions(),
            
            // Likes count
            _buildLikesCount(),
            
            // Caption
            _buildCaption(),
            
            // Restaurant and dish info
            _buildRestaurantInfo(),
            
            // Comments preview
            _buildCommentsPreview(),
            
            // Timestamp (placeholder)
            _buildTimestamp(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          CircleAvatar(
            radius: AppSizes.avatar / 2,
            backgroundColor: AppColors.background,
            child: post['userAvatar'] != null && post['userAvatar'].isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      post['userAvatar'],
                      fit: BoxFit.cover,
                      width: AppSizes.avatar,
                      height: AppSizes.avatar,
                    ),
                  )
                : Icon(
                    Icons.person,
                    color: AppColors.textMedium,
                    size: AppSizes.icon,
                  ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post['userName'] ?? 'Unknown User',
                  style: AppTextStyles.username,
                ),
                if (post['restaurantName'] != null)
                  Text(
                    post['restaurantName'],
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMedium,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert,
              size: AppSizes.icon,
              color: AppColors.textDark,
            ),
            onPressed: () => _showOptionsMenu(context),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: double.infinity,
      height: AppSizes.postImageHeight,
      child: Image.network(
        post['imageUrl'],
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: AppSizes.postImageHeight,
            color: AppColors.background,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                color: AppColors.primary,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: AppSizes.postImageHeight,
            color: AppColors.background,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: AppColors.textMedium,
                  size: AppSizes.iconXl,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Failed to load image',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              post['isLiked'] == true ? Icons.favorite : Icons.favorite_border,
              color: post['isLiked'] == true ? AppColors.primary : AppColors.textDark,
              size: AppSizes.icon,
            ),
            onPressed: onLike,
          ),
          IconButton(
            icon: Icon(
              Icons.comment_outlined,
              color: AppColors.textDark,
              size: AppSizes.icon,
            ),
            onPressed: onComment,
          ),
          IconButton(
            icon: Icon(
              Icons.share_outlined,
              color: AppColors.textDark,
              size: AppSizes.icon,
            ),
            onPressed: onShare,
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              post['isSaved'] == true ? Icons.bookmark : Icons.bookmark_border,
              color: post['isSaved'] == true ? AppColors.primary : AppColors.textDark,
              size: AppSizes.icon,
            ),
            onPressed: onSave,
          ),
        ],
      ),
    );
  }

  Widget _buildLikesCount() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Text(
        '${post['likes'] ?? 0} likes',
        style: AppTextStyles.captionBold,
      ),
    );
  }

  Widget _buildCaption() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: RichText(
        text: TextSpan(
          style: AppTextStyles.bodySmall,
          children: [
            TextSpan(
              text: '${post['userName']} ',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            TextSpan(text: post['caption'] ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          if (post['dishName'] != null)
            Expanded(
              child: Text(
                post['dishName'],
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          const SizedBox(width: AppSpacing.sm),
          if (post['rating'] != null)
            Row(
              children: [
                Icon(
                  Icons.star,
                  color: AppColors.starActive,
                  size: AppSizes.iconSm,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '${post['rating']}.0',
                  style: AppTextStyles.captionBold,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildCommentsPreview() {
    final comments = post['comments'] as List<dynamic>? ?? [];
    if (comments.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: GestureDetector(
        onTap: onComment,
        child: Text(
          'View all ${comments.length} comments',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textMedium,
          ),
        ),
      ),
    );
  }

  Widget _buildTimestamp() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: Text(
        '2 hours ago', // Placeholder - you can add timestamp to your data later
        style: AppTextStyles.timestamp,
      ),
    );
  }
}