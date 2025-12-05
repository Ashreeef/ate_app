import 'package:flutter/material.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../utils/constants.dart';

class TextFieldPreviewScreen extends StatefulWidget {
  const TextFieldPreviewScreen({super.key});

  @override
  State<TextFieldPreviewScreen> createState() => _TextFieldPreviewScreenState();
}

class _TextFieldPreviewScreenState extends State<TextFieldPreviewScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _searchController = TextEditingController();
  String _emailError = '';
  String _passwordError = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('TextField Showcase'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // Section 1: Email Fields
          _SectionHeader(
            title: '1. Email Fields',
            subtitle: 'With icon, validation, and states',
          ),
          const SizedBox(height: AppSpacing.md),
          CustomTextField.email(
            label: 'Email',
            hint: 'exemple@email.com',
            controller: _emailController,
            onChanged: (value) {
              setState(() {
                _emailError = '';
              });
            },
            error: _emailError.isNotEmpty ? _emailError : null,
          ),
          const SizedBox(height: AppSpacing.md),
          CustomTextField.email(
            label: 'Email (Disabled)',
            initialValue: 'user@example.com',
            enabled: false,
          ),
          const SizedBox(height: AppSpacing.md),
          CustomTextField.email(
            label: 'Email (With Error)',
            controller: _emailController,
            error: 'Format d\'email invalide',
          ),
          const SizedBox(height: AppSpacing.xl),

          // Section 2: Password Fields
          _SectionHeader(
            title: '2. Password Fields',
            subtitle: 'With visibility toggle',
          ),
          const SizedBox(height: AppSpacing.md),
          CustomTextField.password(
            label: 'Mot de passe',
            hint: 'Entrez votre mot de passe',
            controller: _passwordController,
            onChanged: (value) {
              setState(() {
                _passwordError = '';
              });
            },
            error: _passwordError.isNotEmpty ? _passwordError : null,
          ),
          const SizedBox(height: AppSpacing.md),
          CustomTextField.password(
            label: 'Confirmer le mot de passe',
            hint: 'Confirmez votre mot de passe',
          ),
          const SizedBox(height: AppSpacing.md),
          CustomTextField.password(
            label: 'Mot de passe (With Error)',
            error: 'Le mot de passe doit contenir au moins 8 caractères',
          ),
          const SizedBox(height: AppSpacing.xl),

          // Section 3: Search Fields
          _SectionHeader(
            title: '3. Search Fields',
            subtitle: 'With clear button',
          ),
          const SizedBox(height: AppSpacing.md),
          CustomTextField.search(
            hint: 'Rechercher un restaurant...',
            controller: _searchController,
            onChanged: (value) {
              print('Search: $value');
            },
          ),
          const SizedBox(height: AppSpacing.md),
          CustomTextField.search(hint: 'Rechercher un plat...'),
          const SizedBox(height: AppSpacing.xl),

          // Section 4: Text Fields (Regular)
          _SectionHeader(
            title: '4. Text Fields',
            subtitle: 'Standard text input',
          ),
          const SizedBox(height: AppSpacing.md),
          const CustomTextField(
            label: 'Nom complet',
            hint: 'Entrez votre nom',
            prefixIcon: Icon(Icons.person_outline),
          ),
          const SizedBox(height: AppSpacing.md),
          const CustomTextField(
            label: 'Numéro de téléphone',
            hint: '+216 XX XXX XXX',
            prefixIcon: Icon(Icons.phone_outlined),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Section 5: Multiline Fields
          _SectionHeader(
            title: '5. Multiline Fields',
            subtitle: 'For longer text input',
          ),
          const SizedBox(height: AppSpacing.md),
          const CustomTextField.multiline(
            label: 'Description',
            hint: 'Parlez-nous de votre expérience culinaire...',
            maxLines: 5,
            minLines: 3,
          ),
          const SizedBox(height: AppSpacing.md),
          const CustomTextField.multiline(
            label: 'Commentaire',
            hint: 'Ajoutez un commentaire...',
          ),
          const SizedBox(height: AppSpacing.xl),

          // Section 6: Real Use Case
          _SectionHeader(
            title: '6. Real Use Case',
            subtitle: 'Login form example',
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Connexion',
                  style: AppTextStyles.heading3,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                CustomTextField.email(
                  label: 'Email',
                  hint: 'votre@email.com',
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppSpacing.md),
                CustomTextField.password(
                  label: 'Mot de passe',
                  hint: '••••••••',
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: AppSpacing.lg),
                ElevatedButton(
                  onPressed: () {
                    // Validate
                    bool hasError = false;
                    if (_emailController.text.isEmpty ||
                        !_emailController.text.contains('@')) {
                      setState(() {
                        _emailError = 'Veuillez entrer un email valide';
                      });
                      hasError = true;
                    }
                    if (_passwordController.text.isEmpty ||
                        _passwordController.text.length < 8) {
                      setState(() {
                        _passwordError =
                            'Le mot de passe doit contenir au moins 8 caractères';
                      });
                      hasError = true;
                    }
                    if (!hasError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('✅ Validation réussie!'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Se connecter'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.heading4.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          subtitle,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMedium),
        ),
      ],
    );
  }
}
