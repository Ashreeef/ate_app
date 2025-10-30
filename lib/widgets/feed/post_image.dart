import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class PostImage extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onDoubleTap;

  const PostImage({Key? key, required this.imageUrl, required this.onDoubleTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onDoubleTap,
      child: Container(
        height: AppSizes.postImageHeight,
        width: double.infinity,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: AppColors.backgroundLight,
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppColors.backgroundLight,
              child: Center(
                child: Icon(
                  Icons.photo,
                  color: AppColors.textLight,
                  size: AppSizes.iconXl,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
