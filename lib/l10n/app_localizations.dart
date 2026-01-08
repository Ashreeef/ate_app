import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Ate'**
  String get appTitle;

  /// No description provided for @viewAllComments.
  ///
  /// In en, this message translates to:
  /// **'View all {count} comments'**
  String viewAllComments(Object count);

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get loginTitle;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginButton;

  /// No description provided for @signupButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signupButton;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @feedTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get feedTitle;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search restaurants, dishes...'**
  String get searchPlaceholder;

  /// No description provided for @createPostTitle.
  ///
  /// In en, this message translates to:
  /// **'Share Your Experience'**
  String get createPostTitle;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @challengesTitle.
  ///
  /// In en, this message translates to:
  /// **'Challenges'**
  String get challengesTitle;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @posts.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get posts;

  /// No description provided for @followers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get followers;

  /// No description provided for @following.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get following;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get points;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @myPosts.
  ///
  /// In en, this message translates to:
  /// **'My Posts'**
  String get myPosts;

  /// No description provided for @savedPosts.
  ///
  /// In en, this message translates to:
  /// **'Saved Posts'**
  String get savedPosts;

  /// No description provided for @like.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get like;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon!'**
  String get comingSoon;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdated;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @logoutSuccess.
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully'**
  String get logoutSuccess;

  /// No description provided for @shareProfile.
  ///
  /// In en, this message translates to:
  /// **'Share profile'**
  String get shareProfile;

  /// No description provided for @shareProfileMessage.
  ///
  /// In en, this message translates to:
  /// **'Check out @{username} on Ate! Discover their culinary journey here: {url}'**
  String shareProfileMessage(Object url, Object username);

  /// No description provided for @linkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied to clipboard!'**
  String get linkCopied;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordChangedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChangedSuccess;

  /// No description provided for @passwordChangeError.
  ///
  /// In en, this message translates to:
  /// **'Error changing password'**
  String get passwordChangeError;

  /// No description provided for @incorrectPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password is incorrect'**
  String get incorrectPassword;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguage;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'📞 Contact Us'**
  String get contactUs;

  /// No description provided for @emailSupport.
  ///
  /// In en, this message translates to:
  /// **' Email: Contact.ate.app@gmail.com'**
  String get emailSupport;

  /// No description provided for @phoneSupport.
  ///
  /// In en, this message translates to:
  /// **''**
  String get phoneSupport;

  /// No description provided for @liveChat.
  ///
  /// In en, this message translates to:
  /// **''**
  String get liveChat;

  /// No description provided for @supportHours.
  ///
  /// In en, this message translates to:
  /// **' Response time: Usually within 24h'**
  String get supportHours;

  /// No description provided for @frequentlyAsked.
  ///
  /// In en, this message translates to:
  /// **' Frequently Asked Questions'**
  String get frequentlyAsked;

  /// No description provided for @howToEditProfile.
  ///
  /// In en, this message translates to:
  /// **'How to edit my profile?'**
  String get howToEditProfile;

  /// No description provided for @howToEditProfileAnswer.
  ///
  /// In en, this message translates to:
  /// **'Go to Profile > Edit Profile to update your personal information.'**
  String get howToEditProfileAnswer;

  /// No description provided for @howToFollowUsers.
  ///
  /// In en, this message translates to:
  /// **'How to follow other users?'**
  String get howToFollowUsers;

  /// No description provided for @howToFollowUsersAnswer.
  ///
  /// In en, this message translates to:
  /// **'Visit their profile and tap the \'Follow\' button.'**
  String get howToFollowUsersAnswer;

  /// No description provided for @howToPostPhoto.
  ///
  /// In en, this message translates to:
  /// **'How to share a culinary moment?'**
  String get howToPostPhoto;

  /// No description provided for @howToPostPhotoAnswer.
  ///
  /// In en, this message translates to:
  /// **'Tap the \'+\' button at the bottom of the screen to share your experience.'**
  String get howToPostPhotoAnswer;

  /// No description provided for @howToReportContent.
  ///
  /// In en, this message translates to:
  /// **'How to report content?'**
  String get howToReportContent;

  /// No description provided for @howToReportContentAnswer.
  ///
  /// In en, this message translates to:
  /// **'Tap the three dots on any post and select \'Report\'.'**
  String get howToReportContentAnswer;

  /// No description provided for @forgotPasswordHelp.
  ///
  /// In en, this message translates to:
  /// **'Lost your password?'**
  String get forgotPasswordHelp;

  /// No description provided for @forgotPasswordHelpAnswer.
  ///
  /// In en, this message translates to:
  /// **'Use the \'Forgot Password\' link on the login screen to reset it.'**
  String get forgotPasswordHelpAnswer;

  /// No description provided for @mainFeatures.
  ///
  /// In en, this message translates to:
  /// **'✨ Main Features'**
  String get mainFeatures;

  /// No description provided for @shareculinaryMoments.
  ///
  /// In en, this message translates to:
  /// **'• Share your culinary moments'**
  String get shareculinaryMoments;

  /// No description provided for @followFriends.
  ///
  /// In en, this message translates to:
  /// **'• Follow friends and discover new profiles'**
  String get followFriends;

  /// No description provided for @likeComment.
  ///
  /// In en, this message translates to:
  /// **'• Like and comment on posts'**
  String get likeComment;

  /// No description provided for @savePosts.
  ///
  /// In en, this message translates to:
  /// **'• Save your favorite posts'**
  String get savePosts;

  /// No description provided for @pointsSystem.
  ///
  /// In en, this message translates to:
  /// **'• Points and levels system'**
  String get pointsSystem;

  /// No description provided for @discoverRestaurants.
  ///
  /// In en, this message translates to:
  /// **'• Discover new restaurants'**
  String get discoverRestaurants;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @troubleshooting.
  ///
  /// In en, this message translates to:
  /// **' Troubleshooting'**
  String get troubleshooting;

  /// No description provided for @restartApp.
  ///
  /// In en, this message translates to:
  /// **'• Restart the app if you encounter issues'**
  String get restartApp;

  /// No description provided for @checkInternet.
  ///
  /// In en, this message translates to:
  /// **'• Ensure you have an active internet connection'**
  String get checkInternet;

  /// No description provided for @updateApp.
  ///
  /// In en, this message translates to:
  /// **'• Update to the latest version via Store'**
  String get updateApp;

  /// No description provided for @clearCache.
  ///
  /// In en, this message translates to:
  /// **'• Clear app cache if needed'**
  String get clearCache;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'• Contact support via email if issues persist'**
  String get contactSupport;

  /// No description provided for @closeDialog.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeDialog;

  /// No description provided for @aboutAte.
  ///
  /// In en, this message translates to:
  /// **'🍽️ About Ate'**
  String get aboutAte;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'Ate is your ultimate culinary companion! Share your gastronomic experiences, discover new restaurants and connect with other food enthusiasts.'**
  String get appDescription;

  /// No description provided for @ourMission.
  ///
  /// In en, this message translates to:
  /// **' Our Mission'**
  String get ourMission;

  /// No description provided for @missionDescription.
  ///
  /// In en, this message translates to:
  /// **'Connecting food lovers and making every meal memorable by creating a vibrant community.'**
  String get missionDescription;

  /// No description provided for @whatWeOffer.
  ///
  /// In en, this message translates to:
  /// **' What We Offer'**
  String get whatWeOffer;

  /// No description provided for @shareFoodPhotos.
  ///
  /// In en, this message translates to:
  /// **'• Share photos of your favorite dishes'**
  String get shareFoodPhotos;

  /// No description provided for @discoverNewRestaurants.
  ///
  /// In en, this message translates to:
  /// **'• Discover hidden gems'**
  String get discoverNewRestaurants;

  /// No description provided for @personalizedRecommendations.
  ///
  /// In en, this message translates to:
  /// **'• Personalized recommendations'**
  String get personalizedRecommendations;

  /// No description provided for @activeCommunity.
  ///
  /// In en, this message translates to:
  /// **'• Active community'**
  String get activeCommunity;

  /// No description provided for @intuitiveInterface.
  ///
  /// In en, this message translates to:
  /// **'• Modern and intuitive interface'**
  String get intuitiveInterface;

  /// No description provided for @privacyRespect.
  ///
  /// In en, this message translates to:
  /// **'• Respect for your privacy'**
  String get privacyRespect;

  /// No description provided for @theTeam.
  ///
  /// In en, this message translates to:
  /// **' The Team'**
  String get theTeam;

  /// No description provided for @teamDescription.
  ///
  /// In en, this message translates to:
  /// **'Developed with ❤️ by the Ate team.'**
  String get teamDescription;

  /// No description provided for @versionInfo.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get versionInfo;

  /// No description provided for @buildInfo.
  ///
  /// In en, this message translates to:
  /// **'Build 2026.01.08'**
  String get buildInfo;

  /// No description provided for @allRightsReserved.
  ///
  /// In en, this message translates to:
  /// **'© 2026 Ate App. All rights reserved.'**
  String get allRightsReserved;

  /// No description provided for @madeInAlgeria.
  ///
  /// In en, this message translates to:
  /// **'Made in Algeria 🇩🇿'**
  String get madeInAlgeria;

  /// No description provided for @privacySecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacySecurity;

  /// No description provided for @privateAccount.
  ///
  /// In en, this message translates to:
  /// **'Private Account'**
  String get privateAccount;

  /// No description provided for @privateAccountDesc.
  ///
  /// In en, this message translates to:
  /// **'Only followers can see your profile'**
  String get privateAccountDesc;

  /// No description provided for @showOnlineStatus.
  ///
  /// In en, this message translates to:
  /// **'Show Online Status'**
  String get showOnlineStatus;

  /// No description provided for @showOnlineStatusDesc.
  ///
  /// In en, this message translates to:
  /// **'Let others see when you are active'**
  String get showOnlineStatusDesc;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @needHelp.
  ///
  /// In en, this message translates to:
  /// **'Need help?'**
  String get needHelp;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get version;

  /// No description provided for @termsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Terms & Privacy'**
  String get termsPrivacy;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsOfUse;

  /// No description provided for @termsOfUseDesc.
  ///
  /// In en, this message translates to:
  /// **'By using Ate, you accept our terms of use.'**
  String get termsOfUseDesc;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicyDesc.
  ///
  /// In en, this message translates to:
  /// **'Your data is safe and protected with us.'**
  String get privacyPolicyDesc;

  /// No description provided for @dataCollection.
  ///
  /// In en, this message translates to:
  /// **'Data Collection'**
  String get dataCollection;

  /// No description provided for @dataCollectionDesc.
  ///
  /// In en, this message translates to:
  /// **'• Profile info\\n• Photos and posts\\n• Interaction data'**
  String get dataCollectionDesc;

  /// No description provided for @accountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get accountDeleted;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirm;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'This action is irreversible. All data will be deleted.'**
  String get deleteAccountConfirm;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @updateYourInfo.
  ///
  /// In en, this message translates to:
  /// **'Update your information'**
  String get updateYourInfo;

  /// No description provided for @manageAccountSecurity.
  ///
  /// In en, this message translates to:
  /// **'Manage security'**
  String get manageAccountSecurity;

  /// No description provided for @updateYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get updateYourPassword;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @manageNotifications.
  ///
  /// In en, this message translates to:
  /// **'Manage notifications'**
  String get manageNotifications;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @getHelpWithApp.
  ///
  /// In en, this message translates to:
  /// **'Get help'**
  String get getHelpWithApp;

  /// No description provided for @learnMoreAboutApp.
  ///
  /// In en, this message translates to:
  /// **'Learn more about Ate'**
  String get learnMoreAboutApp;

  /// No description provided for @legalInfo.
  ///
  /// In en, this message translates to:
  /// **'Legal info'**
  String get legalInfo;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get dangerZone;

  /// No description provided for @logoutFromAccount.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logoutFromAccount;

  /// No description provided for @deleteAccountPermanently.
  ///
  /// In en, this message translates to:
  /// **'Delete permanently'**
  String get deleteAccountPermanently;

  /// No description provided for @pickImages.
  ///
  /// In en, this message translates to:
  /// **'Pick images (max 3)'**
  String get pickImages;

  /// No description provided for @noPosts.
  ///
  /// In en, this message translates to:
  /// **'No posts yet'**
  String get noPosts;

  /// No description provided for @noPostsDescription.
  ///
  /// In en, this message translates to:
  /// **'Be the first to share your culinary experience!'**
  String get noPostsDescription;

  /// No description provided for @selectAtLeastOneImage.
  ///
  /// In en, this message translates to:
  /// **'Select at least one image'**
  String get selectAtLeastOneImage;

  /// No description provided for @imageSelectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to select image: {error}'**
  String imageSelectionFailed(Object error);

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String minutesAgo(Object count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String hoursAgo(Object count);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String daysAgo(Object count);

  /// No description provided for @copyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get copyLink;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @convertToRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Convert to Restaurant'**
  String get convertToRestaurant;

  /// No description provided for @viewRestaurant.
  ///
  /// In en, this message translates to:
  /// **'View My Restaurant'**
  String get viewRestaurant;

  /// No description provided for @createChallenge.
  ///
  /// In en, this message translates to:
  /// **'Create Challenge'**
  String get createChallenge;

  /// No description provided for @challengeTitle.
  ///
  /// In en, this message translates to:
  /// **'Challenge Title'**
  String get challengeTitle;

  /// No description provided for @challengeDescription.
  ///
  /// In en, this message translates to:
  /// **'Challenge Description'**
  String get challengeDescription;

  /// No description provided for @targetCount.
  ///
  /// In en, this message translates to:
  /// **'Target Count'**
  String get targetCount;

  /// No description provided for @rewardBadge.
  ///
  /// In en, this message translates to:
  /// **'Reward Badge'**
  String get rewardBadge;

  /// No description provided for @joinChallenge.
  ///
  /// In en, this message translates to:
  /// **'Join Challenge'**
  String get joinChallenge;

  /// No description provided for @leaveChallenge.
  ///
  /// In en, this message translates to:
  /// **'Leave Challenge'**
  String get leaveChallenge;

  /// No description provided for @yourProgress.
  ///
  /// In en, this message translates to:
  /// **'Your Progress'**
  String get yourProgress;

  /// No description provided for @daysRemaining.
  ///
  /// In en, this message translates to:
  /// **'Days Remaining'**
  String get daysRemaining;

  /// No description provided for @challengeEnded.
  ///
  /// In en, this message translates to:
  /// **'Challenge Ended'**
  String get challengeEnded;

  /// No description provided for @reward.
  ///
  /// In en, this message translates to:
  /// **'Reward'**
  String get reward;

  /// No description provided for @dateRange.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get dateRange;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @conversionWarning.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get conversionWarning;

  /// No description provided for @confirmConversion.
  ///
  /// In en, this message translates to:
  /// **'Confirm Conversion'**
  String get confirmConversion;

  /// No description provided for @conversionSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Successfully converted to restaurant!'**
  String get conversionSuccessful;

  /// No description provided for @becomeARestaurant.
  ///
  /// In en, this message translates to:
  /// **'Become a Restaurant'**
  String get becomeARestaurant;

  /// No description provided for @fillInRestaurantDetails.
  ///
  /// In en, this message translates to:
  /// **'Fill details below'**
  String get fillInRestaurantDetails;

  /// No description provided for @restaurantName.
  ///
  /// In en, this message translates to:
  /// **'Restaurant Name'**
  String get restaurantName;

  /// No description provided for @cuisineType.
  ///
  /// In en, this message translates to:
  /// **'Cuisine Type'**
  String get cuisineType;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @openingHours.
  ///
  /// In en, this message translates to:
  /// **'Opening Hours'**
  String get openingHours;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @restaurantCreated.
  ///
  /// In en, this message translates to:
  /// **'Restaurant profile created'**
  String get restaurantCreated;

  /// No description provided for @myFeed.
  ///
  /// In en, this message translates to:
  /// **'My Feed'**
  String get myFeed;

  /// No description provided for @friendsFeed.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friendsFeed;

  /// No description provided for @noFollowing.
  ///
  /// In en, this message translates to:
  /// **'No following yet'**
  String get noFollowing;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @postDeleted.
  ///
  /// In en, this message translates to:
  /// **'Post deleted'**
  String get postDeleted;

  /// No description provided for @failedToDeletePost.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete: {error}'**
  String failedToDeletePost(Object error);

  /// No description provided for @failedToAddComment.
  ///
  /// In en, this message translates to:
  /// **'Failed to add comment: {error}'**
  String failedToAddComment(Object error);

  /// No description provided for @failedToUpdateLike.
  ///
  /// In en, this message translates to:
  /// **'Failed to update like'**
  String get failedToUpdateLike;

  /// No description provided for @failedToUpdateSave.
  ///
  /// In en, this message translates to:
  /// **'Failed to update save'**
  String get failedToUpdateSave;

  /// No description provided for @cannotAddComment.
  ///
  /// In en, this message translates to:
  /// **'Cannot add comment'**
  String get cannotAddComment;

  /// No description provided for @noCommentsYet.
  ///
  /// In en, this message translates to:
  /// **'No comments yet'**
  String get noCommentsYet;

  /// No description provided for @likesCountText.
  ///
  /// In en, this message translates to:
  /// **'{count} likes'**
  String likesCountText(Object count);

  /// No description provided for @imageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Image not found'**
  String get imageNotFound;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @deleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAction;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @postsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Posts'**
  String postsCount(Object count);

  /// No description provided for @followersCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Followers'**
  String followersCount(Object count);

  /// No description provided for @followingCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Following'**
  String followingCount(Object count);

  /// No description provided for @pointsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Points'**
  String pointsCount(Object count);

  /// No description provided for @likes.
  ///
  /// In en, this message translates to:
  /// **'Likes'**
  String get likes;

  /// No description provided for @noDishes.
  ///
  /// In en, this message translates to:
  /// **'No dishes found'**
  String get noDishes;

  /// No description provided for @noPostsYet.
  ///
  /// In en, this message translates to:
  /// **'No posts yet'**
  String get noPostsYet;

  /// No description provided for @newFollowerTitle.
  ///
  /// In en, this message translates to:
  /// **'New Follower'**
  String get newFollowerTitle;

  /// No description provided for @startedFollowingYou.
  ///
  /// In en, this message translates to:
  /// **'{username} followed you'**
  String startedFollowingYou(Object username);

  /// No description provided for @newLikeTitle.
  ///
  /// In en, this message translates to:
  /// **'New Like'**
  String get newLikeTitle;

  /// No description provided for @likedYourPost.
  ///
  /// In en, this message translates to:
  /// **'{username} liked your post'**
  String likedYourPost(Object username);

  /// No description provided for @newCommentTitle.
  ///
  /// In en, this message translates to:
  /// **'New Comment'**
  String get newCommentTitle;

  /// No description provided for @commentedOnYourPost.
  ///
  /// In en, this message translates to:
  /// **'{username} commented on your post'**
  String commentedOnYourPost(Object username);

  /// No description provided for @allCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'All caught up'**
  String get allCaughtUp;

  /// No description provided for @challengeTypeGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get challengeTypeGeneral;

  /// No description provided for @challengeTypeRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get challengeTypeRestaurant;

  /// No description provided for @challengeTypeDish.
  ///
  /// In en, this message translates to:
  /// **'Dish'**
  String get challengeTypeDish;

  /// No description provided for @challengeTypeLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get challengeTypeLocation;

  /// No description provided for @pleaseLoginFirst.
  ///
  /// In en, this message translates to:
  /// **'Please login first'**
  String get pleaseLoginFirst;

  /// No description provided for @selectStartEndDates.
  ///
  /// In en, this message translates to:
  /// **'Select dates'**
  String get selectStartEndDates;

  /// No description provided for @selectChallenge.
  ///
  /// In en, this message translates to:
  /// **'Select a challenge'**
  String get selectChallenge;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @pleaseLoginToJoinChallenges.
  ///
  /// In en, this message translates to:
  /// **'Login to join'**
  String get pleaseLoginToJoinChallenges;

  /// No description provided for @writeReview.
  ///
  /// In en, this message translates to:
  /// **'Write Review'**
  String get writeReview;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Field required'**
  String get fieldRequired;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @restaurantNotFound.
  ///
  /// In en, this message translates to:
  /// **'Restaurant not found'**
  String get restaurantNotFound;

  /// No description provided for @restaurantHint.
  ///
  /// In en, this message translates to:
  /// **'Search restaurants...'**
  String get restaurantHint;

  /// No description provided for @reviewSuccess.
  ///
  /// In en, this message translates to:
  /// **'Review submitted!'**
  String get reviewSuccess;

  /// No description provided for @rateExperience.
  ///
  /// In en, this message translates to:
  /// **'Rate your experience'**
  String get rateExperience;

  /// No description provided for @yourReview.
  ///
  /// In en, this message translates to:
  /// **'Your Review'**
  String get yourReview;

  /// No description provided for @writeReviewHint.
  ///
  /// In en, this message translates to:
  /// **'Share details...'**
  String get writeReviewHint;

  /// No description provided for @noReviewsRow.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get noReviewsRow;

  /// No description provided for @failedToLoadReviews.
  ///
  /// In en, this message translates to:
  /// **'Failed to load reviews'**
  String get failedToLoadReviews;

  /// No description provided for @onboardingDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover '**
  String get onboardingDiscover;

  /// No description provided for @onboardingFlavor.
  ///
  /// In en, this message translates to:
  /// **'flavor'**
  String get onboardingFlavor;

  /// No description provided for @onboardingOf.
  ///
  /// In en, this message translates to:
  /// **' of '**
  String get onboardingOf;

  /// No description provided for @onboardingSharing.
  ///
  /// In en, this message translates to:
  /// **'sharing'**
  String get onboardingSharing;

  /// No description provided for @onboardingWith.
  ///
  /// In en, this message translates to:
  /// **' with '**
  String get onboardingWith;

  /// No description provided for @onboardingDescription.
  ///
  /// In en, this message translates to:
  /// **'Ate is your food companion.'**
  String get onboardingDescription;

  /// No description provided for @closeButton.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButton;

  /// No description provided for @memberLevel.
  ///
  /// In en, this message translates to:
  /// **'{level} Member ⭐'**
  String memberLevel(Object level);

  /// No description provided for @rank.
  ///
  /// In en, this message translates to:
  /// **'Rank'**
  String get rank;

  /// No description provided for @userPoints.
  ///
  /// In en, this message translates to:
  /// **'User points'**
  String get userPoints;

  /// No description provided for @followedUser.
  ///
  /// In en, this message translates to:
  /// **'Followed {username}'**
  String followedUser(Object username);

  /// No description provided for @unfollowedUser.
  ///
  /// In en, this message translates to:
  /// **'Unfollowed {username}'**
  String unfollowedUser(Object username);

  /// No description provided for @conversionWarningCompact.
  ///
  /// In en, this message translates to:
  /// **'Cannot be undone!'**
  String get conversionWarningCompact;

  /// No description provided for @followed.
  ///
  /// In en, this message translates to:
  /// **'Followed!'**
  String get followed;

  /// No description provided for @manageMenu.
  ///
  /// In en, this message translates to:
  /// **'Manage Menu'**
  String get manageMenu;

  /// No description provided for @editRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Edit Restaurant'**
  String get editRestaurant;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @restaurant.
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get restaurant;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In en, this message translates to:
  /// **'Danger! This will delete everything.'**
  String get deleteAccountWarning;

  /// No description provided for @writeCaption.
  ///
  /// In en, this message translates to:
  /// **'Please write a caption'**
  String get writeCaption;

  /// No description provided for @enterRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Please enter restaurant name'**
  String get enterRestaurant;

  /// No description provided for @newPost.
  ///
  /// In en, this message translates to:
  /// **'New Post'**
  String get newPost;

  /// No description provided for @caption.
  ///
  /// In en, this message translates to:
  /// **'Caption'**
  String get caption;

  /// No description provided for @captionPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Share your culinary experience...'**
  String get captionPlaceholder;

  /// No description provided for @dishName.
  ///
  /// In en, this message translates to:
  /// **'Dish Name'**
  String get dishName;

  /// No description provided for @dishNameOptional.
  ///
  /// In en, this message translates to:
  /// **'Dish Name (Optional)'**
  String get dishNameOptional;

  /// No description provided for @dishNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g. Royal Couscous, Grilled Fish...'**
  String get dishNamePlaceholder;

  /// No description provided for @yourRating.
  ///
  /// In en, this message translates to:
  /// **'Your Rating'**
  String get yourRating;

  /// No description provided for @disappointing.
  ///
  /// In en, this message translates to:
  /// **'Disappointing'**
  String get disappointing;

  /// No description provided for @fair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get fair;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @veryGood.
  ///
  /// In en, this message translates to:
  /// **'Very Good'**
  String get veryGood;

  /// No description provided for @excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get excellent;

  /// No description provided for @createNewChallenge.
  ///
  /// In en, this message translates to:
  /// **'Create New Challenge'**
  String get createNewChallenge;

  /// No description provided for @enterChallengeTitle.
  ///
  /// In en, this message translates to:
  /// **'e.g. \"Try 5 Dishes\"'**
  String get enterChallengeTitle;

  /// No description provided for @titleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get titleRequired;

  /// No description provided for @titleTooShort.
  ///
  /// In en, this message translates to:
  /// **'Title too short'**
  String get titleTooShort;

  /// No description provided for @enterDescription.
  ///
  /// In en, this message translates to:
  /// **'Describe the challenge...'**
  String get enterDescription;

  /// No description provided for @descriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get descriptionRequired;

  /// No description provided for @challengeType.
  ///
  /// In en, this message translates to:
  /// **'Challenge Type'**
  String get challengeType;

  /// No description provided for @enterTargetCount.
  ///
  /// In en, this message translates to:
  /// **'e.g. 5'**
  String get enterTargetCount;

  /// No description provided for @targetCountRequired.
  ///
  /// In en, this message translates to:
  /// **'Target count is required'**
  String get targetCountRequired;

  /// No description provided for @invalidTargetCount.
  ///
  /// In en, this message translates to:
  /// **'Invalid count'**
  String get invalidTargetCount;

  /// No description provided for @targetCountTooHigh.
  ///
  /// In en, this message translates to:
  /// **'Max 100'**
  String get targetCountTooHigh;

  /// No description provided for @enterRewardBadge.
  ///
  /// In en, this message translates to:
  /// **'e.g. \"Foodie Explorer 🍕\"'**
  String get enterRewardBadge;

  /// No description provided for @rewardBadgeRequired.
  ///
  /// In en, this message translates to:
  /// **'Reward badge is required'**
  String get rewardBadgeRequired;

  /// No description provided for @challengeInfo.
  ///
  /// In en, this message translates to:
  /// **'Users earn points by posting about your restaurant'**
  String get challengeInfo;

  /// No description provided for @challengeDetails.
  ///
  /// In en, this message translates to:
  /// **'Challenge Details'**
  String get challengeDetails;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @enterRestaurantName.
  ///
  /// In en, this message translates to:
  /// **'Enter restaurant name'**
  String get enterRestaurantName;

  /// No description provided for @restaurantNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Restaurant name required'**
  String get restaurantNameRequired;

  /// No description provided for @restaurantNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name too short'**
  String get restaurantNameTooShort;

  /// No description provided for @enterCuisineType.
  ///
  /// In en, this message translates to:
  /// **'e.g. Italian, Chinese'**
  String get enterCuisineType;

  /// No description provided for @cuisineTypeRequired.
  ///
  /// In en, this message translates to:
  /// **'Cuisine type required'**
  String get cuisineTypeRequired;

  /// No description provided for @enterLocation.
  ///
  /// In en, this message translates to:
  /// **'Enter location'**
  String get enterLocation;

  /// No description provided for @locationRequired.
  ///
  /// In en, this message translates to:
  /// **'Location required'**
  String get locationRequired;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// No description provided for @enterHours.
  ///
  /// In en, this message translates to:
  /// **'e.g. Mon-Fri 9am-10pm'**
  String get enterHours;

  /// No description provided for @convertNow.
  ///
  /// In en, this message translates to:
  /// **'Convert Now'**
  String get convertNow;

  /// No description provided for @mentions.
  ///
  /// In en, this message translates to:
  /// **'Mentions'**
  String get mentions;

  /// No description provided for @locationNotSpecified.
  ///
  /// In en, this message translates to:
  /// **'Location not specified'**
  String get locationNotSpecified;

  /// No description provided for @restaurantUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Restaurant updated successfully'**
  String get restaurantUpdatedSuccess;

  /// No description provided for @addCoverPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Cover Photo'**
  String get addCoverPhoto;

  /// No description provided for @deleteDish.
  ///
  /// In en, this message translates to:
  /// **'Delete Dish?'**
  String get deleteDish;

  /// No description provided for @deleteDishConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String deleteDishConfirm(Object name);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @menuEmpty.
  ///
  /// In en, this message translates to:
  /// **'Menu is empty'**
  String get menuEmpty;

  /// No description provided for @addFirstDish.
  ///
  /// In en, this message translates to:
  /// **'Add First Dish'**
  String get addFirstDish;

  /// No description provided for @couldNotLoadMenu.
  ///
  /// In en, this message translates to:
  /// **'Could not load menu'**
  String get couldNotLoadMenu;

  /// No description provided for @uploadImageFail.
  ///
  /// In en, this message translates to:
  /// **'Upload failed: {error}'**
  String uploadImageFail(Object error);

  /// No description provided for @editDish.
  ///
  /// In en, this message translates to:
  /// **'Edit Dish'**
  String get editDish;

  /// No description provided for @addDish.
  ///
  /// In en, this message translates to:
  /// **'Add Dish'**
  String get addDish;

  /// No description provided for @addDishPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Dish Photo'**
  String get addDishPhoto;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @dishDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get dishDescription;

  /// No description provided for @doYouWantToContinue.
  ///
  /// In en, this message translates to:
  /// **'Do you want to continue?'**
  String get doYouWantToContinue;

  /// No description provided for @trending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get trending;

  /// No description provided for @allRestaurants.
  ///
  /// In en, this message translates to:
  /// **'All Restaurants'**
  String get allRestaurants;

  /// No description provided for @results.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get results;

  /// No description provided for @resultsFor.
  ///
  /// In en, this message translates to:
  /// **'Results for \"{query}\"'**
  String resultsFor(Object query);

  /// No description provided for @noRestaurantsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No restaurants available'**
  String get noRestaurantsAvailable;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @tryOtherKeywords.
  ///
  /// In en, this message translates to:
  /// **'Try other keywords'**
  String get tryOtherKeywords;

  /// No description provided for @noFollowers.
  ///
  /// In en, this message translates to:
  /// **'No followers yet'**
  String get noFollowers;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Don\'t worry! Enter your email address below and we will send you a link to reset your password.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @rememberPasswordQuestion.
  ///
  /// In en, this message translates to:
  /// **'Remember your password? '**
  String get rememberPasswordQuestion;

  /// No description provided for @signInLink.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInLink;

  /// No description provided for @loggingIn.
  ///
  /// In en, this message translates to:
  /// **'Logging In...'**
  String get loggingIn;

  /// No description provided for @signInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInButton;

  /// No description provided for @timeToEat.
  ///
  /// In en, this message translates to:
  /// **'It\'s time to eat!'**
  String get timeToEat;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to find your friends, discover new dishes, and share your delicious moments.'**
  String get loginSubtitle;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @continueWithSocial.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get continueWithSocial;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @registeringAccount.
  ///
  /// In en, this message translates to:
  /// **'Registering...'**
  String get registeringAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @welcomeToCommunity.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the Ate Community!'**
  String get welcomeToCommunity;

  /// No description provided for @signupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your profile and start exploring your friends\' favorite dishes — discover, share, and savor every moment.'**
  String get signupSubtitle;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPasswordQuestion.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPasswordQuestion;

  /// No description provided for @continueWith.
  ///
  /// In en, this message translates to:
  /// **'Continue With'**
  String get continueWith;

  /// No description provided for @alreadyHaveAccountQuestion.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccountQuestion;

  /// No description provided for @signInNow.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInNow;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @markAllAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllAsRead;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotifications;

  /// No description provided for @searchRestaurants.
  ///
  /// In en, this message translates to:
  /// **'Search restaurants...'**
  String get searchRestaurants;

  /// No description provided for @trendingNearYou.
  ///
  /// In en, this message translates to:
  /// **'Trending Near You'**
  String get trendingNearYou;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @recentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent Searches'**
  String get recentSearches;

  /// No description provided for @maxImagesMessage.
  ///
  /// In en, this message translates to:
  /// **'You can only select {maxImages} images'**
  String maxImagesMessage(Object maxImages);

  /// No description provided for @imageSelectionError.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image: {error}'**
  String imageSelectionError(Object error);

  /// No description provided for @selectAtLeastOne.
  ///
  /// In en, this message translates to:
  /// **'Select at least one image'**
  String get selectAtLeastOne;

  /// No description provided for @choosePhoto.
  ///
  /// In en, this message translates to:
  /// **'Choose Photo'**
  String get choosePhoto;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @addPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add Photos'**
  String get addPhotos;

  /// No description provided for @shareYourCulinaryExperience.
  ///
  /// In en, this message translates to:
  /// **'Share your culinary experience\nwith beautiful photos'**
  String get shareYourCulinaryExperience;

  /// No description provided for @selectPhotos.
  ///
  /// In en, this message translates to:
  /// **'Select Photos'**
  String get selectPhotos;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @activeChallengesLabel.
  ///
  /// In en, this message translates to:
  /// **'Active Challenges'**
  String get activeChallengesLabel;

  /// No description provided for @allChallengesLabel.
  ///
  /// In en, this message translates to:
  /// **'All Challenges'**
  String get allChallengesLabel;

  /// No description provided for @noChallengesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No challenges available'**
  String get noChallengesAvailable;

  /// No description provided for @newChallengesWillAppear.
  ///
  /// In en, this message translates to:
  /// **'New challenges will appear here'**
  String get newChallengesWillAppear;

  /// No description provided for @post.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get post;

  /// No description provided for @imageLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load image'**
  String get imageLoadFailed;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @addComment.
  ///
  /// In en, this message translates to:
  /// **'Add a comment...'**
  String get addComment;

  /// No description provided for @deletePost.
  ///
  /// In en, this message translates to:
  /// **'Delete Post?'**
  String get deletePost;

  /// No description provided for @deletePostConfirm.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deletePostConfirm;

  /// No description provided for @publish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publish;

  /// No description provided for @postPublished.
  ///
  /// In en, this message translates to:
  /// **'Post published successfully!'**
  String get postPublished;

  /// No description provided for @follow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get follow;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
