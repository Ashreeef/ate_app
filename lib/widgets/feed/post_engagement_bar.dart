import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class PostEngagementBar extends StatelessWidget {
  final bool isLiked;
  final bool isSaved;
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;
  final VoidCallback onSaveTap;

  const PostEngagementBar({
    super.key,
    required this.isLiked,
    required this.isSaved,
    required this.onLikeTap,
    required this.onCommentTap,
    required this.onSaveTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          IconButton(
            onPressed: onLikeTap,
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? AppColors.error : AppColors.textLight,
              size: AppSizes.icon,
            ),
          ),
          IconButton(
            onPressed: onCommentTap,
            icon: Icon(
              Icons.chat_bubble_outline,
              color: AppColors.textLight,
              size: AppSizes.icon,
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: onSaveTap,
            icon: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: isSaved ? AppColors.textDark : AppColors.textLight,
              size: AppSizes.icon,
            ),
          ),
        ],
      ),
    );
  }
}
