import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class PostEngagementBar extends StatelessWidget {
  final bool isLiked;
  final bool isSaved;
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;
  final VoidCallback onSaveTap;
  final VoidCallback onShareTap;

  const PostEngagementBar({
    super.key,
    required this.isLiked,
    required this.isSaved,
    required this.onLikeTap,
    required this.onCommentTap,
    required this.onSaveTap,
    required this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Row(
        children: [
          IconButton(
            onPressed: onLikeTap,
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Theme.of(context).colorScheme.onSurface,
              size: 26,
            ),
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
          ),
          IconButton(
            onPressed: onCommentTap,
            icon: Icon(
              Icons.mode_comment_outlined,
              color: Theme.of(context).colorScheme.onSurface,
              size: 24,
            ),
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
          ),
          IconButton(
            onPressed: onShareTap,
            icon: Icon(
              Icons.send_outlined,
              color: Theme.of(context).colorScheme.onSurface,
              size: 24,
            ),
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
          ),
          const Spacer(),
          IconButton(
            onPressed: onSaveTap,
            icon: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: Theme.of(context).colorScheme.onSurface,
              size: 26,
            ),
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
