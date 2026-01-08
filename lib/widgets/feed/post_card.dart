import 'package:flutter/material.dart';
import 'package:ate_app/utils/constants.dart';
import '../../models/post.dart';
import 'post_header.dart';
import 'post_image_carousel.dart';
import 'post_engagement_bar.dart';
import 'post_caption.dart';
import 'post_restaurant_info.dart';
import 'post_options_sheet.dart';
import 'package:ate_app/l10n/app_localizations.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final String currentUserId;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onSave;
  final VoidCallback onProfileTap;

  const PostCard({
    super.key,
    required this.post,
    required this.currentUserId,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onSave,
    required this.onProfileTap,
  });

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PostOptionsSheet(
        post: post,
        isOwnPost: post.userUid == currentUserId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isLiked = post.likedByUids.contains(currentUserId);
    final isSaved = post.savedByUids.contains(currentUserId);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header
          PostHeader(
            userId: post.userUid,
            userName: post.username,
            userAvatar: post.userAvatarUrl ?? '',
            createdAt: post.createdAt,
            onProfileTap: onProfileTap,
            onMoreTap: () => _showOptionsMenu(context),
          ),

          // Post Media (Carousel if multiple, single image if one)
          if (post.images.isNotEmpty)
            PostImageCarousel(
              images: post.images,
              onDoubleTap: onLike,
            ),

          // Post Engagement Bar
          PostEngagementBar(
            isLiked: isLiked,
            isSaved: isSaved,
            onLikeTap: onLike,
            onCommentTap: onComment,
            onSaveTap: onSave,
            onShareTap: onShare,
          ),

          // Likes Count
          if (post.likesCount > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text(
                l10n.likesCountText(post.likesCount),
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),

          const SizedBox(height: AppSpacing.xs),

          // Post Caption
          if (post.caption.isNotEmpty)
            PostCaption(
              userName: post.username,
              caption: post.caption,
            ),

          const SizedBox(height: AppSpacing.sm),

          // Restaurant Info
          if (post.restaurantName != null)
            PostRestaurantInfo(
              restaurantId: post.restaurantUid,
              restaurantName: post.restaurantName!,
              dishName: post.dishName ?? '',
              rating: post.rating ?? 0.0,
            ),

          // View Comments
          if (post.commentsCount > 0)
            Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.md,
                top: AppSpacing.xs,
              ),
              child: GestureDetector(
                onTap: onComment,
                child: Text(
                  l10n.viewAllComments(post.commentsCount),
                  style: AppTextStyles.caption.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),

          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}
