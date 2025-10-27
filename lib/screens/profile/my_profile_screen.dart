import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: AppSizes.avatarLg / 2,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, size: AppSizes.iconXl, color: AppColors.white),
          ),
          SizedBox(height: AppSpacing.lg),
          Text('Profile - TODO by Amina', style: AppTextStyles.heading2),
          SizedBox(height: AppSpacing.sm),
          Text('@username', style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
