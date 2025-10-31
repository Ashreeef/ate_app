import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../data/fake_data.dart';
import '../../widgets/profile/profile_header.dart';
import '../../widgets/profile/profile_posts_grid.dart';
import 'edit_profile_screen.dart';
import '../settings/settings_screen.dart';
import '../post/post_creation_step1_screen.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          '@${FakeUserData.username}',
          style: AppTextStyles.heading4.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_box_outlined, color: AppColors.textDark),
            tooltip: 'Add Post',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostCreationStep1Screen(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: AppColors.textDark),
            tooltip: 'More options',
            onPressed: () {
              _showOptionsMenu(context);
            },
          ),
        ],
      ),

      body: Column(
        children: [
          // Subtle divider under app bar
          Container(height: 1, color: AppColors.divider.withOpacity(0.5)),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Header Component
                  ProfileHeader(
                    avatarUrl: FakeUserData.avatarUrl,
                    username: FakeUserData.username,
                    posts: FakeUserData.postsCount,
                    followers: FakeUserData.followersCount,
                    following: FakeUserData.followingCount,
                    rank: FakeUserData.rank,
                    points: FakeUserData.points,
                  ),

                  // Divider Line
                  Container(height: 1, color: AppColors.divider),

                  // Posts Grid Component
                  ProfilePostsGrid(posts: FakeUserData.userPosts),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.borderRadiusLg),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.settings_outlined),
                title: Text('Settings', style: AppTextStyles.bodyMedium),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.edit_outlined),
                title: Text('Edit Profile', style: AppTextStyles.bodyMedium),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.share_outlined),
                title: Text('Share Profile', style: AppTextStyles.bodyMedium),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Share feature coming soon!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
