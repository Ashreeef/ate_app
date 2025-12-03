import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class PostCaption extends StatelessWidget {
  final String userName;
  final String caption;

  const PostCaption({super.key, required this.userName, required this.caption});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$userName ',
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            TextSpan(text: caption, style: AppTextStyles.body),
          ],
        ),
      ),
    );
  }
}
