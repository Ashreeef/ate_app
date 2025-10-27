import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class PostCreationStep1Screen extends StatelessWidget {
  const PostCreationStep1Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_photo_alternate_outlined, size: 64, color: AppColors.primary),
          SizedBox(height: AppSpacing.lg),
          Text('Post Creation - TODO by Sondes', style: AppTextStyles.heading2),
          SizedBox(height: AppSpacing.sm),
          Text('Select images for your post', style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
