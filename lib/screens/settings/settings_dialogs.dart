import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/constants.dart';
import '../../l10n/app_localizations.dart';
import '../../blocs/settings/settings_cubit.dart';
import '../../blocs/settings/settings_state.dart';

class SettingsDialogs {
  static void showChangePassword(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.changePassword),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.currentPassword,
                prefixIcon: Icon(Icons.lock_outline),
              ),
              obscureText: true,
            ),
            SizedBox(height: AppSpacing.md),
            TextField(
              controller: newPasswordController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.newPassword,
                prefixIcon: Icon(Icons.lock_outline),
              ),
              obscureText: true,
            ),
            SizedBox(height: AppSpacing.md),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.confirmPassword,
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
            onPressed: () async {
              if (newPasswordController.text !=
                  confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)!.passwordsDoNotMatch,
                    ),
                  ),
                );
                return;
              }

              if (newPasswordController.text.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)!.passwordTooShort,
                    ),
                  ),
                );
                return;
              }

              final cubit = context.read<SettingsCubit>();
              Navigator.pop(context);

              final success = await cubit.changePassword(
                currentPasswordController.text,
                newPasswordController.text,
              );

              if (context.mounted) {
                final state = cubit.state;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? AppLocalizations.of(context)!.passwordChangedSuccess
                          : state.errorMessage ??
                                AppLocalizations.of(
                                  context,
                                )!.passwordChangeError,
                    ),
                  ),
                );
              }
            },
            child: Text(AppLocalizations.of(context)!.submit),
          ),
        ],
      ),
    );
  }

  static String getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      case 'fr':
      default:
        return 'Français';
    }
  }

  static void showLanguage(BuildContext context, String currentLanguage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.chooseLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text('Français'),
              value: 'fr',
              groupValue: currentLanguage,
              onChanged: (value) {
                if (value != null) {
                  context.read<SettingsCubit>().setLanguage(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: Text('English'),
              value: 'en',
              groupValue: currentLanguage,
              onChanged: (value) {
                if (value != null) {
                  context.read<SettingsCubit>().setLanguage(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: Text('العربية'),
              value: 'ar',
              groupValue: currentLanguage,
              onChanged: (value) {
                if (value != null) {
                  context.read<SettingsCubit>().setLanguage(value);
                  Navigator.pop(context);
                }
              },
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

  static void showPrivacy(BuildContext context, SettingsState state) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.privacySecurity),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, state) => Column(
                  children: [
                    SwitchListTile(
                      title: Text(AppLocalizations.of(context)!.privateAccount),
                      subtitle: Text(
                        AppLocalizations.of(context)!.privateAccountDesc,
                      ),
                      value: state.privateAccount,
                      onChanged: (value) {
                        context.read<SettingsCubit>().setPrivateAccount(value);
                      },
                    ),
                    SwitchListTile(
                      title: Text(
                        AppLocalizations.of(context)!.showOnlineStatus,
                      ),
                      subtitle: Text(
                        AppLocalizations.of(context)!.showOnlineStatusDesc,
                      ),
                      value: state.showOnlineStatus,
                      onChanged: (value) {
                        context.read<SettingsCubit>().setShowOnlineStatus(
                          value,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.close),
            ),
          ],
        ),
      ),
    );
  }

  static void showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.helpSupport),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.needHelp,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: AppSpacing.md),
              Text('📧 Email: support@ate-app.com'),
              SizedBox(height: AppSpacing.sm),
              Text(
                '📱 ${AppLocalizations.of(context)!.phone}: +33 1 23 45 67 89',
              ),
              SizedBox(height: AppSpacing.md),
              Divider(),
              SizedBox(height: AppSpacing.md),
              Text(
                AppLocalizations.of(context)!.frequentlyAsked,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text('• ${AppLocalizations.of(context)!.howToEditProfile}'),
              Text('• ${AppLocalizations.of(context)!.howToFollowUsers}'),
              Text('• ${AppLocalizations.of(context)!.howToPostPhoto}'),
              Text('• ${AppLocalizations.of(context)!.howToReportContent}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }

  static void showAbout(BuildContext context) {
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
              AppLocalizations.of(context)!.version,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textMedium,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Text(AppConstants.appTagline, style: AppTextStyles.body),
            SizedBox(height: AppSpacing.md),
            Text(
              AppLocalizations.of(context)!.allRightsReserved,
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

  static void showTerms(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.termsPrivacy),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.termsOfUse,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                AppLocalizations.of(context)!.termsOfUseDesc,
                style: AppTextStyles.body,
              ),
              SizedBox(height: AppSpacing.md),
              Text(
                AppLocalizations.of(context)!.privacyPolicy,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                AppLocalizations.of(context)!.privacyPolicyDesc,
                style: AppTextStyles.body,
              ),
              SizedBox(height: AppSpacing.md),
              Text(
                AppLocalizations.of(context)!.dataCollection,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                AppLocalizations.of(context)!.dataCollectionDesc,
                style: AppTextStyles.body,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }
}
