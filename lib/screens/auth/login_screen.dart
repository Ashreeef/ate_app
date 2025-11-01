import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement login logic
      // For Now, Navigate to home screen (temporary until authentication is implemented)
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _handleForgotPassword() {
    Navigator.pushNamed(context, '/forgot-password');
  }

  void _handleSocialLogin(String provider) {
    // TODO: Implement social login
    // For Now, Navigate to home screen (temporary until social auth is implemented)
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _handleSignUp() {
    Navigator.pushNamed(context, '/signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: AppSpacing.xl),

                          _buildHeader(),

                          const Spacer(flex: 2),

                          _buildLoginForm(),

                          const SizedBox(height: AppSpacing.lg),

                          // Remember me & Forgot password
                          _buildOptionsRow(),

                          const SizedBox(height: AppSpacing.xl),

                          CustomButton(
                            text: 'Se connecter',
                            onPressed: _handleLogin,
                          ),

                          const Spacer(flex: 2),

                          _buildSocialLogin(),

                          const Spacer(flex: 3),

                          _buildSignUpLink(),

                          const SizedBox(height: AppSpacing.xl),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Heure de passer à table !',
          style: AppTextStyles.heading1.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Connecte-toi pour retrouver tes amis, découvrir de nouveaux plats et partager tes moments gourmands.',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textLight,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        CustomTextField(
          controller: _emailController,
          hint: 'Email',
          type: CustomTextFieldType.email,
          textInputAction: TextInputAction.next,
          prefixIcon: const Icon(
            Icons.email_outlined,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        CustomTextField(
          controller: _passwordController,
          hint: 'Mot de passe',
          type: CustomTextFieldType.password,
          textInputAction: TextInputAction.done,
          onEditingComplete: _handleLogin,
          prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildOptionsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Remember me checkbox
        Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                side: const BorderSide(color: AppColors.primary, width: 2),
                fillColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.selected)) {
                    return AppColors.primary;
                  }
                  return AppColors.white;
                }),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Se souvenir de moi',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textDark,
              ),
            ),
          ],
        ),

        GestureDetector(
          onTap: _handleForgotPassword,
          child: Text(
            'Mot de passe oublié ?',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLogin() {
    return Column(
      children: [
        Text(
          'Continuer avec',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialIconButton(
              iconData: Icons.g_mobiledata_rounded,
              onTap: () => _handleSocialLogin('Google'),
            ),
            const SizedBox(width: AppSpacing.md),
            _buildSocialIconButton(
              iconData: Icons.facebook_rounded,
              onTap: () => _handleSocialLogin('Facebook'),
            ),
            const SizedBox(width: AppSpacing.md),
            _buildSocialIconButton(
              iconData: Icons.apple_rounded,
              onTap: () => _handleSocialLogin('Apple'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIconButton({
    required IconData iconData,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
        child: Center(
          child: Icon(iconData, size: 32, color: AppColors.textDark),
        ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Center(
      child: GestureDetector(
        onTap: _handleSignUp,
        child: RichText(
          text: TextSpan(
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textMedium,
              fontFamily: 'DM Sans',
            ),
            children: [
              const TextSpan(text: 'Vous n\'avez pas de compte ? '),
              TextSpan(
                text: 'Créer un compte',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'DM Sans',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
