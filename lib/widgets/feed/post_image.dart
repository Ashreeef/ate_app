import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../utils/constants.dart';

class PostImage extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onDoubleTap;

  const PostImage({
    super.key,
    required this.imageUrl,
    required this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onDoubleTap,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: AppColors.backgroundLight,
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: AppColors.backgroundLight,
            child: const Center(
              child: Icon(
                Icons.photo_outlined,
                color: AppColors.textLight,
                size: AppSizes.iconXl,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
