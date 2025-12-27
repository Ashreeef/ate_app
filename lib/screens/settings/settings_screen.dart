import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/settings/settings_cubit.dart';
import '../../blocs/settings/settings_state.dart';
import '../profile/edit_profile_screen.dart';
import 'settings_dialogs.dart';
import '../../repositories/restaurant_repository.dart';
import '../../database/seed_data.dart';

/// Settings screen for theme, language, notifications, and password
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return _buildScaffold(context, state);
      },
    );
  }

  Widget _buildScaffold(BuildContext context, SettingsState state) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
          ),
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
            _buildSectionHeader(context, AppLocalizations.of(context)!.account),
            _buildSettingsGroup(context, [
              _buildSettingsTile(
                context: context,
                icon: Icons.edit_outlined,
                title: AppLocalizations.of(context)!.editProfile,
                subtitle: AppLocalizations.of(context)!.updateYourInfo,
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
                context: context,
                icon: Icons.lock_outline,
                title: AppLocalizations.of(context)!.privacySecurity,
                subtitle: AppLocalizations.of(context)!.manageAccountSecurity,
                onTap: () {
                  SettingsDialogs.showPrivacy(context, state);
                },
              ),
              _buildSettingsTile(
                context: context,
                icon: Icons.key_outlined,
                title: AppLocalizations.of(context)!.changePassword,
                subtitle: AppLocalizations.of(context)!.updateYourPassword,
                onTap: () {
                  SettingsDialogs.showChangePassword(context);
                },
              ),
            ]),

            SizedBox(height: AppSpacing.lg),

            // Preferences Section
            _buildSectionHeader(
              context,
              AppLocalizations.of(context)!.preferences,
            ),
            _buildSettingsGroup(context, [
              // Notifications toggle
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: SwitchListTile(
                  value: state.notifications,
                  title: Text(
                    AppLocalizations.of(context)!.notifications,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    AppLocalizations.of(context)!.manageNotifications,
                    style: AppTextStyles.caption.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                  onChanged: (v) =>
                      context.read<SettingsCubit>().setNotifications(v),
                  activeColor: AppColors.primary,
                ),
              ),

              // Language (kept simple for now)
              _buildSettingsTile(
                context: context,
                icon: Icons.language_outlined,
                title: AppLocalizations.of(context)!.language,
                subtitle: SettingsDialogs.getLanguageName(state.language),
                onTap: () {
                  SettingsDialogs.showLanguage(context, state.language);
                },
              ),

              // Theme toggle
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: SwitchListTile(
                  value: state.darkTheme,
                  title: Text(
                    AppLocalizations.of(context)!.theme,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    AppLocalizations.of(context)!.darkMode,
                    style: AppTextStyles.caption.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                  onChanged: (v) =>
                      context.read<SettingsCubit>().setDarkTheme(v),
                  activeColor: AppColors.primary,
                ),
              ),
            ]),

            SizedBox(height: AppSpacing.lg),

            // Support Section
            _buildSectionHeader(context, AppLocalizations.of(context)!.support),
            _buildSettingsGroup(context, [
              _buildSettingsTile(
                context: context,
                icon: Icons.help_outline,
                title: AppLocalizations.of(context)!.helpSupport,
                subtitle: AppLocalizations.of(context)!.getHelpWithApp,
                onTap: () {
                  SettingsDialogs.showHelp(context);
                },
              ),
              _buildSettingsTile(
                context: context,
                icon: Icons.info_outline,
                title: AppLocalizations.of(context)!.about,
                subtitle: AppLocalizations.of(context)!.learnMoreAboutApp,
                onTap: () {
                  SettingsDialogs.showAbout(context);
                },
              ),
              _buildSettingsTile(
                context: context,
                icon: Icons.description_outlined,
                title: AppLocalizations.of(context)!.termsPrivacy,
                subtitle: AppLocalizations.of(context)!.legalInfo,
                onTap: () {
                  SettingsDialogs.showTerms(context);
                },
              ),
              _buildSettingsTile(
                context: context,
                icon: Icons.build_circle_outlined,
                title: 'Repair Data',
                subtitle: 'Fix search keywods & data issues',
                onTap: () {
                  _showRepairDataDialog(context);
                },
              ),
              _buildSettingsTile(
                context: context,
                icon: Icons.cloud_upload_outlined,
                title: 'Seed Data',
                subtitle: 'Populate with test data',
                onTap: () {
                  _showSeedDataDialog(context);
                },
              ),
            ]),

            SizedBox(height: AppSpacing.lg),

            // Danger Zone
            _buildSectionHeader(
              context,
              AppLocalizations.of(context)!.dangerZone,
            ),
            _buildSettingsGroup(context, [
              _buildSettingsTile(
                context: context,
                icon: Icons.logout,
                title: AppLocalizations.of(context)!.logout,
                subtitle: AppLocalizations.of(context)!.logoutFromAccount,
                onTap: () {
                  _showLogoutDialog(context);
                },
                iconColor: AppColors.error,
                showTrailing: false,
              ),
              _buildSettingsTile(
                context: context,
                icon: Icons.delete_outline,
                title: AppLocalizations.of(context)!.deleteAccount,
                subtitle: AppLocalizations.of(
                  context,
                )!.deleteAccountPermanently,
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
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.overline.copyWith(
          color: Theme.of(context).textTheme.bodySmall?.color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(BuildContext context, List<Widget> children) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(
              alpha: AppConstants.opacityLight,
            ),
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
    required BuildContext context,
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
                  color: (iconColor ?? AppColors.primary).withValues(
                    alpha: AppConstants.opacityOverlay,
                  ),
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
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
              if (showTrailing)
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).iconTheme.color,
                  size: AppSizes.icon,
                ),
            ],
          ),
        ),
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
            onPressed: () async {
              Navigator.pop(context);
              await context.read<SettingsCubit>().logout();

              if (context.mounted) {
                // Navigate to login screen and remove all previous routes
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/login', (route) => false);
              }
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
          AppLocalizations.of(context)!.deleteAccountWarning,
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
              final success = await context
                  .read<SettingsCubit>()
                  .deleteAccount();

              if (context.mounted && success) {
                // Navigate to login screen and remove all previous routes
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/login', (route) => false);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(AppLocalizations.of(context)!.submit),
          ),
        ],
      ),
    );
  }

  void _showRepairDataDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Repair Database'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
             CircularProgressIndicator(),
             SizedBox(height: 16),
             Text('Fixing search data... Please wait.'),
          ],
        ),
      ),
    );

    // Run repair in background
    RestaurantRepository().repairSearchData().then((count) {
      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Repair Complete: Updated $count restaurants'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }).catchError((e) {
      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Repair Failed: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });
  }

  void _showSeedDataDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Seed Database'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
             CircularProgressIndicator(),
             SizedBox(height: 16),
             Text('Creating test data... This may take a moment.'),
          ],
        ),
      ),
    );

    // Run seeding in background
    SeedData.seedDatabase().then((_) {
      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Seeding Complete!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }).catchError((e) {
      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Seeding Failed: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });
  }
}
