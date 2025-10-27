import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emoji_events_outlined, size: 64, color: AppColors.primary),
          SizedBox(height: AppSpacing.lg),
          Text('Challenges - TODO by Arslene', style: AppTextStyles.heading2),
          SizedBox(height: AppSpacing.sm),
          Text('Food challenges will appear here', style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
