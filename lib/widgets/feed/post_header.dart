import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class PostHeader extends StatelessWidget {
  final String userName;
  final String userAvatar;
  final VoidCallback onProfileTap;
  final VoidCallback onMoreTap;

  const PostHeader({
    super.key,
    required this.userName,
    required this.userAvatar,
    required this.onProfileTap,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withOpacity(0.1),
            radius: AppSizes.avatarSm / 2,
            backgroundImage:
                (userAvatar.isNotEmpty &&
                    (userAvatar.startsWith('http') ||
                        userAvatar.startsWith('https')))
                ? NetworkImage(userAvatar)
                : null,
            child:
                (userAvatar.isEmpty ||
                    (!userAvatar.startsWith('http') &&
                        !userAvatar.startsWith('https')))
                ? Icon(
                    Icons.person,
                    color: AppColors.primary,
                    size: AppSizes.avatarSm / 2,
                  )
                : null,
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
