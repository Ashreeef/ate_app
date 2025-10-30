import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class PostHeader extends StatelessWidget {
  final String userName;
  final String userAvatar;
  final VoidCallback onProfileTap;
  final VoidCallback onMoreTap;

  const PostHeader({
    Key? key,
    required this.userName,
    required this.userAvatar,
    required this.onProfileTap,
    required this.onMoreTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withOpacity(0.1),
            radius: AppSizes.avatarSm / 2,
            child: Text(
              userAvatar,
              style: AppTextStyles.bodyMedium.copyWith(fontFamily: 'DM Sans'),
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: GestureDetector(
              onTap: onProfileTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Text(
                      userName,
                      style: AppTextStyles.heading4.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text('2 hours ago', style: AppTextStyles.timestamp),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: onMoreTap,
            icon: Icon(
              Icons.more_vert,
              color: AppColors.textLight,
              size: AppSizes.icon,
            ),
          ),
        ],
      ),
    );
  }
}
