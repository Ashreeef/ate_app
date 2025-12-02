import 'package:flutter/material.dart';
import '../../utils/constants.dart';

/// Grid layout displaying user's posts with like/comment counts
class ProfilePostsGrid extends StatelessWidget {
  final List<Map<String, dynamic>> posts;

  const ProfilePostsGrid({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          childAspectRatio: 1,
        ),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return _PostThumbnail(
            imageUrl: post['imageUrl'] as String,
            likes: post['likes'] as int,
          );
        },
      ),
    );
  }
}

class _PostThumbnail extends StatelessWidget {
  final String imageUrl;
  final int likes;

  const _PostThumbnail({required this.imageUrl, required this.likes});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Theme.of(context).cardTheme.color,
                  child: Icon(
                    Icons.image_outlined,
                    color: Theme.of(context).iconTheme.color?.withValues(
                      alpha: AppConstants.opacityMedium,
                    ),
                    size: AppSizes.iconXl,
                  ),
                );
              },
            ),

            // Like Count Badge (bottom-right)
            Positioned(
              right: 8,
              bottom: 8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(
                    alpha: AppConstants.opacityHigh,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.favorite, color: AppColors.primary, size: 14),
                    SizedBox(width: 4),
                    Text(
                      likes.toString(),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
