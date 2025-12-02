import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../screens/profile/other_user_profile_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/profile/profile_cubit.dart';

/// Post header showing user info with clickable profile navigation
class PostHeader extends StatelessWidget {
  final int? userId; // User ID for profile navigation
  final String userName;
  final String userAvatar;
  final VoidCallback onProfileTap; // Legacy callback, kept for compatibility
  final VoidCallback onMoreTap;

  const PostHeader({
    super.key,
    this.userId,
    required this.userName,
    required this.userAvatar,
    required this.onProfileTap,
    required this.onMoreTap,
  });

  /// Navigate to user profile when tapping avatar or username
  Future<void> _navigateToProfile(BuildContext context) async {
    // Fallback to legacy callback if no userId provided
    if (userId == null) {
      onProfileTap();
      return;
    }

    // Don't navigate if viewing own post (already on own profile)
    final currentUser = context.read<ProfileCubit>().state.user;
    if (currentUser != null && currentUser.id == userId) {
      return;
    }

    // Open other user's profile with full info and features
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
          // Clickable avatar - navigates to user profile
          GestureDetector(
            onTap: () => _navigateToProfile(context),
            child: CircleAvatar(
              backgroundColor: AppColors.primary.withValues(
                alpha: AppConstants.opacityOverlay,
              ),
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
          // Clickable username - navigates to user profile
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
