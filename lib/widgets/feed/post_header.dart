import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../screens/profile/other_user_profile_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/profile/profile_cubit.dart';

class PostHeader extends StatelessWidget {
  final int? userId;
  final String userName;
  final String userAvatar;
  final VoidCallback onProfileTap;
  final VoidCallback onMoreTap;

  const PostHeader({
    super.key,
    this.userId,
    required this.userName,
    required this.userAvatar,
    required this.onProfileTap,
    required this.onMoreTap,
  });

  Future<void> _navigateToProfile(BuildContext context) async {
    if (userId == null) {
      // If no userId, just call the onProfileTap callback
      onProfileTap();
      return;
    }

    // Check if this is the current user's profile
    final currentUser = context.read<ProfileCubit>().state.user;
    if (currentUser != null && currentUser.id == userId) {
      // Don't navigate - user is viewing their own post, they're already on their profile
      return;
    }

    // Navigate to other user's profile
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtherUserProfileScreen(userId: userId!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _navigateToProfile(context),
            child: CircleAvatar(
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
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: GestureDetector(
              onTap: () => _navigateToProfile(context),
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
