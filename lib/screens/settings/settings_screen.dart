import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/navigation/bottom_nav_bar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textDark),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Modifier Profile',
          style: AppTextStyles.heading3.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.textDark),
            onPressed: () {},
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
           
            Padding(
              padding: const EdgeInsets.only(
                top: AppSpacing.xl,
                bottom: AppSpacing.lg,
              ),
              child: Column(
                children: [
                  _buildProfileAvatar(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuB7essqcwpQDWaa2S6u3cMjM6b_AxUXrPcy0xS2AWcqax8wV9l2CvOIgQOaG0BH8ufn-vQgNGIHK9vj3WhKnhUK1so16NdMAEyCRcNvQuP_TS9xNsRjw7_YkCObTqMfxAFYysxBKLTXSR4gCuzMZgAbkqUXJpe65ziUHaab_Zdc6uR0Zte7ol9dJcd3GuDBQauVmBsFpM6HKVgt8b_Gz72LW1m7YVsyZmpLnzBe92LsB7ry0kvUgcbnhnLxs0fi7gRFlVs0-1khdM8f',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '@Arslenee',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),

            // --- Menu Items Section ---
            _buildMenuItem(
              icon: Icons.badge_outlined,
              title: 'Informations',
              onTap: () {},
            ),
            const SizedBox(height: AppSpacing.sm), 
            _buildMenuItem(
              icon: Icons.key_outlined,
              title: 'Réinitialiser mot de passe',
              onTap: () {},
            ),
            const SizedBox(height: AppSpacing.sm), 
            _buildMenuItem(
              icon: Icons.logout,
              title: 'Se déconnecter',
              onTap: () {},
            ),
            const SizedBox(height: AppSpacing.sm), 
            _buildMenuItem(
              icon: Icons.person_remove_outlined,
              title: 'Supprimer compte',
              onTap: () {},
              
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),

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
    );
  }

  Widget _buildProfileAvatar(String imageUrl) {
    return Container(
      width: AppSizes.avatarXl,
      height: AppSizes.avatarXl,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary,
          width: 2.0,
        ),
      ),
      child: ClipOval(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: AppSizes.avatarXl,
          height: AppSizes.avatarXl,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.person, size: 80, color: AppColors.textMedium),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool hasBorder = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: hasBorder
            ? const Border(
                bottom: BorderSide(
                  color: Color.fromARGB(97, 0, 0, 0),
                  width: 2,
                ),
              )
            : null,
        
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(15, 0, 0, 0),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.lg,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: AppColors.textDark,
                      size: AppSizes.icon,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      title,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textDark,
                  size: AppSizes.icon,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
