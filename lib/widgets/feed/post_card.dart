import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import 'post_header.dart';
import 'post_image.dart';
import 'post_engagement_bar.dart';
import 'post_caption.dart';
import 'post_restaurant_info.dart';

class PostCard extends StatelessWidget {
  final Map<String, dynamic> post;
  final int postIndex;
  final VoidCallback onLike;
  final VoidCallback onSave;
  final VoidCallback onComment;
  final VoidCallback onMoreOptions;
  final VoidCallback onProfileTap;

  const PostCard({
    Key? key,
    required this.post,
    required this.postIndex,
    required this.onLike,
    required this.onSave,
    required this.onComment,
    required this.onMoreOptions,
    required this.onProfileTap,
  }) : super(key: key);

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
          PostHeader(
            userName: post['userName'],
            userAvatar: post['userAvatar'],
            onProfileTap: onProfileTap,
            onMoreTap: onMoreOptions,
          ),
          PostImage(imageUrl: post['imageUrl'], onDoubleTap: onLike),
          PostEngagementBar(
            isLiked: post['isLiked'],
            isSaved: post['isSaved'],
            onLikeTap: onLike,
            onCommentTap: onComment,
            onSaveTap: onSave,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(
              '${post['likes']} likes',
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
