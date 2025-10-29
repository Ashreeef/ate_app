import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  Widget _statItem(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: AppTextStyles.heading4),
        SizedBox(height: AppSpacing.xs),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }

  Widget _postThumbnail(String imageUrl, int likes) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Image fills the box, no rounded corners
        Positioned.fill(
          child: Image.network(imageUrl, fit: BoxFit.cover),
        ),
        // Heart + count badge
        Positioned(
          right: 8,
          bottom: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withOpacity(0.4),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.favorite, color: AppColors.primary, size: 14),
                SizedBox(width: AppSpacing.xs),
                Text(
                  likes.toString(),
                  style: AppTextStyles.captionBold.copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double avatarRadius = AppSizes.avatarXl / 2; // 50
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with pink background and top bar
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 154,
                  color: AppColors.backgroundPink,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Back button
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: AppColors.textDark),
                            onPressed: () => Navigator.of(context).maybePop(),
                          ),
                          // Title
                          Text('Profile', style: AppTextStyles.heading3),
                          // More actions
                          IconButton(
                            icon: Icon(Icons.more_vert, color: AppColors.textDark),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Centered avatar overlapping the header
                Positioned(
                  top: 120,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: avatarRadius,
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=800&auto=format&fit=crop&q=80',
                        ),
                        backgroundColor: AppColors.backgroundLight,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: avatarRadius + AppSpacing.sm),

            // Name, username and stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    SizedBox(height: AppSpacing.xl),
                  Text('User Name', style: AppTextStyles.heading2),
                  SizedBox(height: AppSpacing.xs),
                  Text('@username', style: AppTextStyles.username),
                  SizedBox(height: AppSpacing.md),

                  // Stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _statItem('2', 'Posts'),
                      SizedBox(width: AppSpacing.lg),
                      _statItem('5', 'Followers'),
                      SizedBox(width: AppSpacing.lg),
                      _statItem('10', 'Following'),
                    ],
                  ),

                  SizedBox(height: AppSpacing.md),

                  // Points / small badge row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.emoji_events, color: AppColors.primary, size: AppSizes.iconSm),
                      SizedBox(width: AppSpacing.xs),
                      Text('0r - 322 Points', style: AppTextStyles.bodyMedium),
                    ],
                  ),

                  SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),

            // ✨ Shadow line separator between profile info and posts
            Container(
              height: 8,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withOpacity(0.25),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
                color: AppColors.backgroundLight,
              ),
            ),

            // Posts row with horizontal space
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
              child: SizedBox(
                height: AppSizes.postThumbnailSize * 0.7,
                child: Row(
                  children: [
                    Expanded(
                      child: _postThumbnail(
                        'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&auto=format&fit=crop&q=80',
                        66,
                      ),
                    ),
                    SizedBox(width: AppSpacing.md), // 👈 Horizontal space between posts
                    Expanded(
                      child: _postThumbnail(
                         'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&auto=format&fit=crop&q=80',
                        66,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
