import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../preview/button_preview_screen.dart';
import '../preview/text_field_preview_screen.dart';

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
          Text(
            'Food challenges will appear here',
            style: AppTextStyles.bodySmall,
          ),
          SizedBox(height: AppSpacing.xl),

          // Button to preview CustomButton widget
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ButtonPreviewScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.md,
              ),
            ),
            child: Text('View Button Showcase'),
          ),
          SizedBox(height: AppSpacing.md),

          // Button to preview CustomTextField widget
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TextFieldPreviewScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.md,
              ),
            ),
            child: Text('View TextField Showcase'),
          ),
        ],
      ),
    );
  }
}
