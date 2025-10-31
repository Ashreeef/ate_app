import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/navigation/bottom_nav_bar.dart'; 

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
        Positioned.fill(
          child: Image.network(imageUrl, fit: BoxFit.cover),
        ),
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
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.favorite, color: AppColors.primary, size: 14),
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
    final double avatarRadius = AppSizes.avatarXl / 2;

    return Scaffold(
      backgroundColor: AppColors.background,

      
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1, 
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/profile');
          }
        },
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            //HEADER
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
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
                            onPressed: () => Navigator.of(context).maybePop(),
                          ),
                          Text('Profile', style: AppTextStyles.heading3),
                          IconButton(
                            icon: const Icon(Icons.more_vert, color: AppColors.textDark),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: avatarRadius,
                        backgroundImage: const NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuB7essqcwpQDWaa2S6u3cMjM6b_AxUXrPcy0xS2AWcqax8wV9l2CvOIgQOaG0BH8ufn-vQgNGIHK9vj3WhKnhUK1so16NdMAEyCRcNvQuP_TS9xNsRjw7_YkCObTqMfxAFYysxBKLTXSR4gCuzMZgAbkqUXJpe65ziUHaab_Zdc6uR0Zte7ol9dJcd3GuDBQauVmBsFpM6HKVgt8b_Gz72LW1m7YVsyZmpLnzBe92LsB7ry0kvUgcbnhnLxs0fi7gRFlVs0-1khdM8f',
                        ),
                        backgroundColor: AppColors.backgroundLight,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: avatarRadius + AppSpacing.sm),

            //USER iNFO
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.emoji_events,
                          color: Color.fromARGB(255, 255, 221, 0), size: AppSizes.iconSm),
                      SizedBox(width: AppSpacing.xs),
                      Text('0r - 322 Points', style: AppTextStyles.bodyMedium),
                    ],
                  ),

                  SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),

            //SEPARATOR
            Container(
              height: 1,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
                color: const Color.fromARGB(46, 108, 108, 108),
              ),
            ),

            //POSTS SECTION
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.md),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final postSize = (constraints.maxWidth - AppSpacing.md) / 2;
                  return Row(
                    children: [
                      SizedBox(
                        width: postSize,
                        height: postSize,
                        child: _postThumbnail(
                          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&auto=format&fit=crop&q=80',
                          66,
                        ),
                      ),
                      SizedBox(width: AppSpacing.md),
                      SizedBox(
                        width: postSize,
                        height: postSize,
                        child: _postThumbnail(
                          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&auto=format&fit=crop&q=80',
                          66,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
