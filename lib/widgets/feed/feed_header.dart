import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/constants.dart';

class FeedHeader extends StatelessWidget {
  final bool isMonFeedSelected;
  final VoidCallback onMonFeedTap;
  final VoidCallback onMesAmisTap;

  const FeedHeader({
    Key? key,
    required this.isMonFeedSelected,
    required this.onMonFeedTap,
    required this.onMesAmisTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.divider, width: 1)),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            SvgPicture.asset('assets/images/logo_black.svg', height: 40),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _FeedToggleButton(
                      text: 'Mon Feed',
                      isSelected: isMonFeedSelected,
                      onTap: onMonFeedTap,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _FeedToggleButton(
                      text: 'Mes Amis',
                      isSelected: !isMonFeedSelected,
                      onTap: onMesAmisTap,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.textDark : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusRound),
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isSelected ? AppColors.white : AppColors.textDark,
              fontWeight: FontWeight.w600,
              fontFamily: 'DM Sans',
            ),
          ),
        ),
      ),
    );
  }
}
