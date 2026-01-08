import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/constants.dart';
import '../../l10n/app_localizations.dart';
import '../../blocs/settings/settings_cubit.dart';
import '../../blocs/settings/settings_state.dart';

class SettingsDialogs {
  // Helper method for FAQ items
  static Widget _buildFaqItem(String question, String answer) {
    return Builder(
      builder: (context) => Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 12, top: 2),
              child: Text(
                answer,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.3,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

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

              if (newPasswordController.text.length <
                  AppConstants.minPasswordLength) {
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
        title: Row(
          children: [
            Icon(
              Icons.help_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(width: 8),
            Text(AppLocalizations.of(context)!.helpSupport),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Contact Section
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.contactUs,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 8),
                      SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.emailSupport,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // FAQ Section
                Text(
                  AppLocalizations.of(context)!.frequentlyAsked,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 8),
                _buildFaqItem(
                  AppLocalizations.of(context)!.howToEditProfile,
                  AppLocalizations.of(context)!.howToEditProfileAnswer,
                ),
                _buildFaqItem(
                  AppLocalizations.of(context)!.howToFollowUsers,
                  AppLocalizations.of(context)!.howToFollowUsersAnswer,
                ),
                _buildFaqItem(
                  AppLocalizations.of(context)!.howToPostPhoto,
                  AppLocalizations.of(context)!.howToPostPhotoAnswer,
                ),
                _buildFaqItem(
                  AppLocalizations.of(context)!.howToReportContent,
                  AppLocalizations.of(context)!.howToReportContentAnswer,
                ),
                _buildFaqItem(
                  AppLocalizations.of(context)!.forgotPasswordHelp,
                  AppLocalizations.of(context)!.forgotPasswordHelpAnswer,
                ),

                SizedBox(height: 16),

                // Features Section
                Text(
                  AppLocalizations.of(context)!.mainFeatures,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.shareculinaryMoments,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.followFriends,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.likeComment,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.savePosts,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.pointsSystem,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.discoverRestaurants,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.darkMode,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),

                SizedBox(height: 16),

                // Troubleshooting Section
                Text(
                  AppLocalizations.of(context)!.troubleshooting,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.restartApp,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.checkInternet,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.updateApp,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.clearCache,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.contactSupport,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.closeDialog),
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
            Icon(
              Icons.restaurant,
              color: Theme.of(context).colorScheme.primary,
              size: 28,
            ),
            SizedBox(width: 8),
            Text(
              'Ate',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Version Info
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.versionInfo,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)!.buildInfo,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // App Description
                Text(
                  AppLocalizations.of(context)!.aboutAte,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.appDescription,
                  style: TextStyle(
                    height: 1.4,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 16),

                // Mission
                Text(
                  AppLocalizations.of(context)!.ourMission,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.missionDescription,
                  style: TextStyle(
                    height: 1.4,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 16),

                // Features
                Text(
                  AppLocalizations.of(context)!.whatWeOffer,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.shareFoodPhotos,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.discoverNewRestaurants,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.personalizedRecommendations,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.activeCommunity,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.intuitiveInterface,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.privacyRespect,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 16),

                // Team
                Text(
                  AppLocalizations.of(context)!.theTeam,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.teamDescription,
                  style: TextStyle(
                    height: 1.4,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 16),

                // Legal
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.allRightsReserved,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        AppLocalizations.of(context)!.madeInAlgeria,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.closeDialog),
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
                  color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                AppLocalizations.of(context)!.termsOfUseDesc,
                style: AppTextStyles.body.copyWith(
                  color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                ),
              ),
              SizedBox(height: AppSpacing.md),
              Text(
                AppLocalizations.of(context)!.privacyPolicy,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                AppLocalizations.of(context)!.privacyPolicyDesc,
                style: AppTextStyles.body.copyWith(
                  color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                ),
              ),
              SizedBox(height: AppSpacing.md),
              Text(
                AppLocalizations.of(context)!.dataCollection,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                AppLocalizations.of(context)!.dataCollectionDesc,
                style: AppTextStyles.body.copyWith(
                  color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.closeButton),
          ),
        ],
      ),
    );
  }
}
