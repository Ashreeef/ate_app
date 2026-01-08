import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/constants.dart';
import '../../l10n/app_localizations.dart';

class FeedHeader extends StatelessWidget {
  final bool isMonFeedSelected;
  final VoidCallback onMonFeedTap;
  final VoidCallback onMesAmisTap;

  const FeedHeader({
    super.key,
    required this.isMonFeedSelected,
    required this.onMonFeedTap,
    required this.onMesAmisTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        bottom: AppSpacing.sm,
        top: MediaQuery.of(context).padding.top + AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: isDarkMode ? Colors.white10 : Colors.black12,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Logo
          Text(
            'arslene.',
            style: AppTextStyles.heading2.copyWith(
              color: AppColors.primary,
              fontFamily: 'Outfit',
              letterSpacing: -1,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Expanded(child: SizedBox()),
          
          // Feed Toggle
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusRound),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _FeedToggleButton(
                  text: l10n.myFeed,
                  isSelected: isMonFeedSelected,
                  onTap: onMonFeedTap,
                ),
                _FeedToggleButton(
                  text: l10n.friendsFeed,
                  isSelected: !isMonFeedSelected,
                  onTap: onMesAmisTap,
                ),
              ],
            ),
          ),
          
          const SizedBox(width: AppSpacing.sm),
          
          // Notifications / Activity Icon
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
            icon: Icon(
              Icons.favorite_border,
              color: isDarkMode ? Colors.white : AppColors.textDark,
              size: 26,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

class _FeedToggleButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _FeedToggleButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.shortAnimation,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: isSelected 
              ? (isDarkMode ? Colors.white12 : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusRound),
          boxShadow: isSelected && !isDarkMode
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          text,
          style: AppTextStyles.captionBold.copyWith(
            color: isSelected
                ? (isDarkMode ? Colors.white : AppColors.textDark)
                : (isDarkMode ? Colors.white54 : AppColors.textMedium),
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
