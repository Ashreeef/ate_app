import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/constants.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
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

              _buildHeading(),

              const SizedBox(height: AppSpacing.lg),

              _buildDescription(),

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

  Widget _buildHeading() {
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        style: AppTextStyles.heading2.copyWith(
          fontSize: 28,
          height: 1.4,
          fontWeight: FontWeight.bold,
        ),
        children: [
          const TextSpan(
            text: 'Découvre la vraie ',
            style: TextStyle(color: AppColors.textDark),
          ),
          const TextSpan(
            text: 'saveur',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primary,
              decorationThickness: 2,
            ),
          ),
          const TextSpan(
            text: ' du ',
            style: TextStyle(color: AppColors.textDark),
          ),
          const TextSpan(
            text: 'partage',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primary,
              decorationThickness: 2,
            ),
          ),
          const TextSpan(
            text: ' avec ',
            style: TextStyle(color: AppColors.textDark),
          ),
          // Ate logo inline
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: SvgPicture.asset(
                'assets/images/logo.svg',
                width: 55,
                height: 40,
              ),
            ),
          ),
          const TextSpan(
            text: ' !',
            style: TextStyle(color: AppColors.textDark),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      'Ate est ton compagnon food, pensé pour les amoureux de la bonne bouffe. '
      'Chaque jour, explore de nouveaux plats grâce aux recommandations de tes amis, '
      'partage tes découvertes, relève des défis gourmands et gagne des récompenses.',
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
