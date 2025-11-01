import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: AppSizes.bottomNavHeight,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Tab 1 - Home
            _NavBarItem(
              icon: Icons.home_outlined,
              iconFilled: Icons.home,
              isSelected: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            // Tab 2 - Search
            _NavBarItem(
              icon: Icons.search,
              iconFilled: Icons.search,
              isSelected: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            // Tab 3 - Post (CENTER - SPECIAL)
            _NavBarItemCenter(
              isSelected: currentIndex == 2,
              onTap: () => onTap(2),
            ),
            // Tab 4 - Challenges (Heart/Favorites)
            _NavBarItem(
              icon: Icons.favorite_border,
              iconFilled: Icons.favorite,
              isSelected: currentIndex == 3,
              onTap: () => onTap(3),
            ),
            // Tab 5 - Profile
            _NavBarItem(
              icon: Icons.person_outline,
              iconFilled: Icons.person,
              isSelected: currentIndex == 4,
              onTap: () => onTap(4),
            ),
          ],
        ),
      ),
    );
  }
}

// Regular navigation item (Home, Search, Challenges, Profile)
class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData iconFilled;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    Key? key,
    required this.icon,
    required this.iconFilled,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.primary.withOpacity(0.1),
        highlightColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Red indicator line above active icon
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                height: 2,
                width: isSelected ? 32 : 0,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              SizedBox(height: 6),
              // Icon - filled when selected, outlined when not
              Icon(
                isSelected ? iconFilled : icon,
                size: 24,
                color: isSelected ? AppColors.primary : AppColors.secondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Center navigation item (Post/Add button) - SPECIAL DESIGN
class _NavBarItemCenter extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItemCenter({
    Key? key,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.primary.withOpacity(0.1),
        highlightColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Red indicator line above active icon
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                height: 2,
                width: isSelected ? 32 : 0,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              SizedBox(height: 6),
              // Special square container with plus icon
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.secondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.add, size: 20, color: AppColors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
