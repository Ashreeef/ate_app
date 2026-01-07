import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/constants.dart';
import '../../l10n/app_localizations.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/images/onboarding.svg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              _buildHeading(context),

              const SizedBox(height: AppSpacing.lg),

              _buildDescription(context),

              const SizedBox(height: AppSpacing.xl),

              Align(
                alignment: Alignment.centerRight,
                child: _buildNextButton(context),
              ),

              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeading(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : AppColors.textDark;

    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        style: AppTextStyles.heading2.copyWith(
          fontSize: 28,
          height: 1.4,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: l10n.onboardingDiscover,
            style: TextStyle(color: textColor),
          ),
          TextSpan(
            text: l10n.onboardingFlavor,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primary,
              decorationThickness: 2,
            ),
          ),
          TextSpan(
            text: l10n.onboardingOf,
            style: TextStyle(color: textColor),
          ),
          TextSpan(
            text: l10n.onboardingSharing,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primary,
              decorationThickness: 2,
            ),
          ),
          TextSpan(
            text: l10n.onboardingWith,
            style: TextStyle(color: textColor),
          ),
          // Ate logo inline
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: SvgPicture.asset(
                isDarkMode ? 'assets/images/logo_white.svg' : 'assets/images/logo.svg',
                width: 55,
                height: 40,
              ),
            ),
          ),
          TextSpan(
            text: ' !',
            style: TextStyle(color: textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.onboardingDescription,
      textAlign: TextAlign.left,
      style: AppTextStyles.bodySmall.copyWith(
        color: AppColors.textLight,
        height: 1.6,
        fontSize: 14,
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/login');
      },
      borderRadius: BorderRadius.circular(100),
      child: Container(
        width: 64,
        height: 64,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.arrow_forward,
          color: AppColors.white,
          size: 30,
        ),
      ),
    );
  }
}
