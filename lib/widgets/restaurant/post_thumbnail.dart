import 'package:flutter/material.dart';
import '../../models/post.dart';
import '../../utils/constants.dart';

class PostThumbnail extends StatelessWidget {
  final Post post;
  final VoidCallback? onTap;

  const PostThumbnail({Key? key, required this.post, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusSm),
            color: AppColors.background,
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Post Image
              if (post.firstImageUrl != null)
                Image.network(
                  post.firstImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholder();
                  },
                )
              else
                _buildPlaceholder(),
              // Multiple images indicator
              if (post.imageUrls.length > 1)
                Positioned(
                  top: AppSpacing.xs,
                  right: AppSpacing.xs,
                  child: Container(
                    padding: EdgeInsets.all(AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(
                        AppSizes.borderRadiusSm,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.layers,
                          size: AppSizes.iconXs,
                          color: AppColors.white,
                        ),
                        SizedBox(width: AppSpacing.xs / 2),
                        Text(
                          '${post.imageUrls.length}',
                          style: AppTextStyles.captionBold.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.background,
      child: Center(
        child: Icon(
          Icons.image,
          size: AppSizes.iconLg,
          color: AppColors.textLight,
        ),
      ),
    );
  }
}
