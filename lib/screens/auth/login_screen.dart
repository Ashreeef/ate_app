import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../utils/constants.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

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
      context.read<AuthBloc>().add(
        LoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  void _handleForgotPassword() {
    Navigator.pushNamed(context, '/forgot-password');
  }

  void _handleSocialLogin(String provider) {
    // Social login not yet implemented - show coming soon message
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$provider ${l10n.comingSoon}'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleSignUp() {
    Navigator.pushNamed(context, '/signup');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          // Navigate to home screen on successful login
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        } else if (state is AuthError) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final l10n = AppLocalizations.of(context)!;
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
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
                                  text: isLoading
                                      ? l10n.loggingIn
                                      : l10n.signInButton,
                                  onPressed: isLoading ? () {} : _handleLogin,
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
        },
      ),
    );
  }

  Widget _buildHeader() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          l10n.timeToEat,
          style: AppTextStyles.heading1.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.loginSubtitle,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textLight,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        CustomTextField(
          controller: _emailController,
          hint: l10n.emailLabel,
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
          hint: l10n.passwordLabel,
          type: CustomTextFieldType.password,
          textInputAction: TextInputAction.done,
          onEditingComplete: _handleLogin,
          prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildOptionsRow() {
    final l10n = AppLocalizations.of(context)!;
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
                fillColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.primary;
                  }
                  return Colors.transparent;
                }),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              l10n.rememberMe,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textDark,
              ),
            ),
          ],
        ),

        GestureDetector(
          onTap: _handleForgotPassword,
          child: Text(
            l10n.forgotPassword,
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
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Text(
          l10n.continueWithSocial,
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
    final l10n = AppLocalizations.of(context)!;
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
              TextSpan(text: '${l10n.noAccount} '),
              TextSpan(
                text: l10n.createAccount,
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
