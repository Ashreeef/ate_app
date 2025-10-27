import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu, size: 64, color: AppColors.primary),
          SizedBox(height: AppSpacing.lg),
          Text('Feed - TODO by Sondes', style: AppTextStyles.heading2),
          SizedBox(height: AppSpacing.sm),
          Text('Posts will appear here', style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
