import 'package:flutter/material.dart';
import '../../widgets/common/custom_button.dart';
import '../../utils/constants.dart';

/// Preview screen to showcase all CustomButton variants and states
/// Access via: NavigationShell or direct navigation
class ButtonPreviewScreen extends StatelessWidget {
  const ButtonPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Button Showcase'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Primary Buttons Section
            _SectionHeader(title: '1. Primary Buttons'),
            SizedBox(height: AppSpacing.md),

            // Large Primary (Default)
            CustomButton(
              text: 'Se connecter',
              onPressed: () => _showSnackBar(context, 'Primary Large Pressed'),
            ),
            SizedBox(height: AppSpacing.md),

            // Medium Primary
            CustomButton(
              text: 'Medium Button',
              size: CustomButtonSize.medium,
              onPressed: () => _showSnackBar(context, 'Primary Medium Pressed'),
            ),
            SizedBox(height: AppSpacing.md),

            // Small Primary
            CustomButton(
              text: 'Small Button',
              size: CustomButtonSize.small,
              onPressed: () => _showSnackBar(context, 'Primary Small Pressed'),
            ),
            SizedBox(height: AppSpacing.md),

            // Disabled Primary
            CustomButton(text: 'Disabled Button', onPressed: null),
            SizedBox(height: AppSpacing.md),

            // Loading Primary
            CustomButton(text: 'Loading...', isLoading: true, onPressed: () {}),

            SizedBox(height: AppSpacing.xl),

            // Primary with Icons Section
            _SectionHeader(title: '2. Primary with Icons'),
            SizedBox(height: AppSpacing.md),

            CustomButton.icon(
              text: 'Next',
              icon: Icons.arrow_forward,
              iconRight: true,
              onPressed: () => _showSnackBar(context, 'Next Pressed'),
            ),
            SizedBox(height: AppSpacing.md),

            CustomButton(
              text: 'Continuer avec',
              icon: Icons.arrow_forward,
              onPressed: () => _showSnackBar(context, 'Continue Pressed'),
            ),

            SizedBox(height: AppSpacing.xl),

            // Secondary Buttons Section
            _SectionHeader(title: '3. Secondary Buttons'),
            SizedBox(height: AppSpacing.md),

            CustomButton.secondary(
              text: 'Annuler',
              onPressed: () => _showSnackBar(context, 'Cancel Pressed'),
            ),
            SizedBox(height: AppSpacing.md),

            CustomButton.secondary(
              text: 'Secondary Medium',
              size: CustomButtonSize.medium,
              onPressed: () =>
                  _showSnackBar(context, 'Secondary Medium Pressed'),
            ),
            SizedBox(height: AppSpacing.md),

            CustomButton.secondary(
              text: 'Secondary Small',
              size: CustomButtonSize.small,
              onPressed: () =>
                  _showSnackBar(context, 'Secondary Small Pressed'),
            ),
            SizedBox(height: AppSpacing.md),

            CustomButton.secondary(text: 'Disabled Secondary', onPressed: null),

            SizedBox(height: AppSpacing.xl),

            // Text Buttons Section
            _SectionHeader(title: '4. Text Buttons'),
            SizedBox(height: AppSpacing.md),

            CustomButton.text(
              text: 'Voir tout',
              onPressed: () => _showSnackBar(context, 'See All Pressed'),
            ),
            SizedBox(height: AppSpacing.md),

            CustomButton.text(
              text: 'Mentions',
              size: CustomButtonSize.small,
              onPressed: () => _showSnackBar(context, 'Mentions Pressed'),
            ),
            SizedBox(height: AppSpacing.md),

            CustomButton.text(
              text: 'Mot de passe oublié ?',
              onPressed: () =>
                  _showSnackBar(context, 'Forgot Password Pressed'),
            ),
            SizedBox(height: AppSpacing.md),

            CustomButton.text(text: 'Disabled Text Button', onPressed: null),

            SizedBox(height: AppSpacing.xl),

            // Width Variants Section
            _SectionHeader(title: '5. Custom Widths'),
            SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: '50%',
                    size: CustomButtonSize.medium,
                    onPressed: () => _showSnackBar(context, '50% Width'),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: CustomButton.secondary(
                    text: '50%',
                    size: CustomButtonSize.medium,
                    onPressed: () => _showSnackBar(context, '50% Width'),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md),

            Center(
              child: CustomButton(
                text: 'Fixed 200px',
                width: 200,
                size: CustomButtonSize.medium,
                onPressed: () => _showSnackBar(context, 'Fixed Width'),
              ),
            ),

            SizedBox(height: AppSpacing.xl),

            // Real Use Cases Section
            _SectionHeader(title: '6. Real Use Cases'),
            SizedBox(height: AppSpacing.md),

            CustomButton(
              text: 'S\'inscrire',
              onPressed: () => _showSnackBar(context, 'Sign Up'),
            ),
            SizedBox(height: AppSpacing.md),

            CustomButton.text(
              text: 'Vous avez déjà un compte ? Se connecter',
              size: CustomButtonSize.small,
              onPressed: () => _showSnackBar(context, 'Login Link'),
            ),
            SizedBox(height: AppSpacing.md),

            CustomButton.secondary(
              text: 'Continuer avec Google',
              icon: Icons.g_mobiledata,
              onPressed: () => _showSnackBar(context, 'Google Login'),
            ),

            SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 1)),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.heading4.copyWith(color: AppColors.primary),
    );
  }
}
