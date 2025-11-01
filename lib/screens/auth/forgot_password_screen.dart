import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleResetPassword() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement password reset logic
      print('Reset password for: ${_emailController.text}');
    }
  }

  void _handleBackToLogin() {
    Navigator.pop(context);
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
                          const Spacer(flex: 3),

                          _buildHeader(),

                          const SizedBox(height: AppSpacing.xxxl),

                          _buildEmailForm(),

                          const SizedBox(height: AppSpacing.lg),

                          CustomButton(
                            text: 'RÉINITIALISER',
                            onPressed: _handleResetPassword,
                          ),

                          const SizedBox(height: AppSpacing.xxl),

                          _buildLoginLink(),

                          const Spacer(flex: 4),
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
          'Oups, un petit trou de mémoire ?',
          style: AppTextStyles.heading1.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Pas de panique ! Entre ton adresse e-mail et on t\'enverra un lien pour réinitialiser ton mot de passe.',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textLight,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmailForm() {
    return CustomTextField(
      controller: _emailController,
      hint: 'Email',
      type: CustomTextFieldType.email,
      textInputAction: TextInputAction.done,
      onEditingComplete: _handleResetPassword,
      prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primary),
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: GestureDetector(
        onTap: _handleBackToLogin,
        child: RichText(
          text: TextSpan(
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textMedium,
              fontFamily: 'DM Sans',
            ),
            children: [
              const TextSpan(text: 'Tu te souviens de ton mot de passe ? '),
              TextSpan(
                text: 'Se connecter',
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
