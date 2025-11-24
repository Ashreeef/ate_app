import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../database/database_helper.dart';
import '../../blocs/profile/profile_cubit.dart';
import '../../blocs/settings/settings_cubit.dart';
import '../../blocs/settings/settings_state.dart';
import '../profile/edit_profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit()..loadSettings(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return _buildScaffold(context, state);
        },
      ),
    );
  }

  Widget _buildScaffold(BuildContext context, SettingsState state) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.settingsTitle,
          style: AppTextStyles.heading3.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSpacing.md),

            // Account Section
            _buildSectionHeader('Compte'),
            _buildSettingsGroup([
              _buildSettingsTile(
                icon: Icons.edit_outlined,
                title: AppLocalizations.of(context)!.editProfile,
                subtitle: 'Mettre à jour vos informations',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                },
              ),
              _buildSettingsTile(
                icon: Icons.lock_outline,
                title: 'Confidentialité et sécurité',
                subtitle: 'Gérer la sécurité de votre compte',
                onTap: () {
                  _showComingSoon(context);
                },
              ),
              _buildSettingsTile(
                icon: Icons.key_outlined,
                title: 'Changer le mot de passe',
                subtitle: 'Mettre à jour votre mot de passe',
                onTap: () {
                  _showChangePasswordDialog(context);
                },
              ),
            ]),

            SizedBox(height: AppSpacing.lg),

            // Preferences Section
            _buildSectionHeader('Préférences'),
            _buildSettingsGroup([
              // Notifications toggle
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: SwitchListTile(
                  value: state.notifications,
                  title: Text(
                    'Notifications',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'Gérer vos préférences de notification',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMedium,
                    ),
                  ),
                  onChanged: (v) => context.read<SettingsCubit>().setNotifications(v),
                  activeColor: AppColors.primary,
                ),
              ),

              // Language (kept simple for now)
              _buildSettingsTile(
                icon: Icons.language_outlined,
                title: 'Langue',
                subtitle: 'Français',
                onTap: () {
                  _showComingSoon(context);
                },
              ),

              // Theme toggle
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: SwitchListTile(
                  value: state.darkTheme,
                  title: Text(
                    'Thème',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'Mode sombre',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMedium,
                    ),
                  ),
                  onChanged: (v) => context.read<SettingsCubit>().setDarkTheme(v),
                  activeColor: AppColors.primary,
                ),
              ),
            ]),

            SizedBox(height: AppSpacing.lg),

            // Support Section
            _buildSectionHeader('Support'),
            _buildSettingsGroup([
              _buildSettingsTile(
                icon: Icons.help_outline,
                title: 'Aide et support',
                subtitle: 'Obtenir de l\'aide avec Ate',
                onTap: () {
                  _showComingSoon(context);
                },
              ),
              _buildSettingsTile(
                icon: Icons.info_outline,
                title: 'À propos',
                subtitle: 'En savoir plus sur Ate',
                onTap: () {
                  _showAboutDialog(context);
                },
              ),
              _buildSettingsTile(
                icon: Icons.description_outlined,
                title: 'Conditions et confidentialité',
                subtitle: 'Informations légales',
                onTap: () {
                  _showComingSoon(context);
                },
              ),
            ]),

            SizedBox(height: AppSpacing.lg),

            // Danger Zone
            _buildSectionHeader('Zone de danger'),
            _buildSettingsGroup([
              _buildSettingsTile(
                icon: Icons.logout,
                title: 'Déconnexion',
                subtitle: 'Se déconnecter de votre compte',
                onTap: () {
                  _showLogoutDialog(context);
                },
                iconColor: AppColors.error,
                showTrailing: false,
              ),
              _buildSettingsTile(
                icon: Icons.delete_outline,
                title: AppLocalizations.of(context)!.deleteAccount,
                subtitle: 'Supprimer définitivement votre compte',
                onTap: () {
                  _showDeleteAccountDialog(context);
                },
                iconColor: AppColors.error,
                showTrailing: false,
              ),
            ]),

            SizedBox(height: AppSpacing.xl),

            // App Version
            Center(
              child: Text(
                'Ate v1.0.0',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMedium,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.overline.copyWith(
          color: AppColors.textMedium,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    bool showTrailing = true,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColors.primary).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusSm),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? AppColors.primary,
                  size: AppSizes.icon,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMedium,
                      ),
                    ),
                  ],
                ),
              ),
              if (showTrailing)
                Icon(
                  Icons.chevron_right,
                  color: AppColors.textMedium,
                  size: AppSizes.icon,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.comingSoon),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(
              'Ate',
              style: AppTextStyles.heading2.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version 1.0.0',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textMedium,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Text(AppConstants.appTagline, style: AppTextStyles.body),
            SizedBox(height: AppSpacing.md),
            Text(
              '© 2025 Ate. Tous droits réservés.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textMedium,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.logout),
        content: Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement logout
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.logoutSuccess),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(AppLocalizations.of(context)!.logout),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.error),
            SizedBox(width: AppSpacing.sm),
            Text(AppLocalizations.of(context)!.deleteAccount),
          ],
        ),
        content: Text(
          'Cette action est irréversible. Toutes vos données seront définitivement supprimées.',
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              // Perform local deletion (clears local DB)
              await DatabaseHelper.instance.clearAllData();
              // If a ProfileCubit is provided, reload to reflect deletion
              try {
                final cubit = context.read<ProfileCubit>();
                await cubit.loadProfile();
              } catch (_) {}
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(AppLocalizations.of(context)!.submit),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Changer le mot de passe'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Mot de passe actuel',
                prefixIcon: Icon(Icons.lock_outline),
              ),
              obscureText: true,
            ),
            SizedBox(height: AppSpacing.md),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nouveau mot de passe',
                prefixIcon: Icon(Icons.lock_outline),
              ),
              obscureText: true,
            ),
            SizedBox(height: AppSpacing.md),
            TextField(
              decoration: InputDecoration(
                labelText: 'Confirmer le nouveau mot de passe',
                prefixIcon: Icon(Icons.lock_outline),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Mot de passe modifié avec succès')),
              );
            },
            child: Text(AppLocalizations.of(context)!.submit),
          ),
        ],
      ),
    );
  }
}
