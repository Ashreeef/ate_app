// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Ate';

  @override
  String get loginTitle => 'Welcome Back';

  @override
  String get loginButton => 'Sign In';

  @override
  String get signupButton => 'Sign Up';

  @override
  String get emailLabel => 'Email Address';

  @override
  String get passwordLabel => 'Password';

  @override
  String get usernameLabel => 'Username';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get feedTitle => 'Discover';

  @override
  String get searchPlaceholder => 'Search restaurants, dishes...';

  @override
  String get createPostTitle => 'Share Your Experience';

  @override
  String get profileTitle => 'Profile';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get challengesTitle => 'Challenges';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get logout => 'Logout';

  @override
  String get posts => 'Posts';

  @override
  String get followers => 'Followers';

  @override
  String get following => 'Following';

  @override
  String get points => 'Points';

  @override
  String get saved => 'Saved';

  @override
  String get myPosts => 'My Posts';

  @override
  String get savedPosts => 'Saved Posts';

  @override
  String get like => 'Like';

  @override
  String get comment => 'Comment';

  @override
  String get share => 'Share';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get submit => 'Submit';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'An error occurred';

  @override
  String get comingSoon => 'Coming soon!';

  @override
  String get profileUpdated => 'Profile updated successfully';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get logoutSuccess => 'Logged out successfully';

  @override
  String get shareProfile => 'Share profile';

  @override
  String get changePassword => 'Change Password';

  @override
  String get currentPassword => 'Current password';

  @override
  String get newPassword => 'New password';

  @override
  String get confirmPassword => 'Confirm new password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get passwordChangedSuccess => 'Password changed successfully';

  @override
  String get passwordChangeError => 'Error changing password';

  @override
  String get incorrectPassword => 'Current password is incorrect';

  @override
  String get chooseLanguage => 'Choose Language';

  @override
  String get privacySecurity => 'Privacy & Security';

  @override
  String get privateAccount => 'Private Account';

  @override
  String get privateAccountDesc =>
      'Your profile will only be visible to your followers';

  @override
  String get showOnlineStatus => 'Show Online Status';

  @override
  String get showOnlineStatusDesc => 'Others can see when you are online';

  @override
  String get close => 'Close';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get needHelp => 'Need help?';

  @override
  String get phone => 'Phone';

  @override
  String get frequentlyAsked => 'Frequently Asked Questions';

  @override
  String get howToEditProfile => 'How to edit my profile?';

  @override
  String get howToFollowUsers => 'How to follow other users?';

  @override
  String get howToPostPhoto => 'How to post a photo?';

  @override
  String get howToReportContent => 'How to report content?';

  @override
  String get about => 'About';

  @override
  String get version => 'Version 1.0.0';

  @override
  String get allRightsReserved => '© 2025 Ate. All rights reserved.';

  @override
  String get termsPrivacy => 'Terms & Privacy';

  @override
  String get termsOfUse => 'Terms of Use';

  @override
  String get termsOfUseDesc =>
      'By using Ate, you accept our terms of use and privacy policy.';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicyDesc =>
      'Your personal data is protected and will never be shared with third parties without your consent.';

  @override
  String get dataCollection => 'Data Collection';

  @override
  String get dataCollectionDesc =>
      '• Profile information\n• Photos and posts\n• Interaction data';

  @override
  String get accountDeleted => 'Account deleted successfully';

  @override
  String get logoutConfirm => 'Are you sure you want to log out?';

  @override
  String get deleteAccountConfirm =>
      'This action is irreversible. All your data will be permanently deleted.';

  @override
  String get account => 'Account';

  @override
  String get updateYourInfo => 'Update your information';

  @override
  String get manageAccountSecurity => 'Manage your account security';

  @override
  String get updateYourPassword => 'Update your password';

  @override
  String get preferences => 'Preferences';

  @override
  String get manageNotifications => 'Manage your notification preferences';

  @override
  String get notifications => 'Notifications';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get support => 'Support';

  @override
  String get getHelpWithApp => 'Get help with Ate';

  @override
  String get learnMoreAboutApp => 'Learn more about Ate';

  @override
  String get legalInfo => 'Legal information';

  @override
  String get dangerZone => 'Danger Zone';

  @override
  String get logoutFromAccount => 'Log out from your account';

  @override
  String get deleteAccountPermanently => 'Permanently delete your account';

  @override
  String get pickImages => 'Pick images (max 3)';

  @override
  String get noPosts => 'No posts yet';

  @override
  String get noPostsDescription =>
      'Be the first to share your culinary experience!';

  @override
  String get selectAtLeastOneImage => 'Select at least one image';

  @override
  String imageSelectionFailed(Object error) {
    return 'Failed to select image: $error';
  }

  @override
  String get postPublished => 'Post published successfully!';

  @override
  String postPublishError(Object error) {
    return 'Error publishing post: $error';
  }

  @override
  String get writeCaption => 'Please write a caption';

  @override
  String get enterRestaurant => 'Please enter a restaurant';

  @override
  String get rateExperience => 'Please rate your experience';

  @override
  String get caption => 'Caption';

  @override
  String get captionPlaceholder => 'Share your culinary experience...';

  @override
  String get restaurant => 'Restaurant';

  @override
  String get restaurantPlaceholder => 'Restaurant name...';

  @override
  String get restaurantHint => 'Type the restaurant name';

  @override
  String get dishName => 'Dish Name';

  @override
  String get dishNamePlaceholder => 'e.g., Couscous Royal, Grilled Fish...';

  @override
  String get dishNameOptional => '(Optional)';

  @override
  String get yourRating => 'Your Rating';

  @override
  String get newPost => 'New Post';

  @override
  String get publish => 'Publish';

  @override
  String get disappointing => 'Disappointing';

  @override
  String get fair => 'Fair';

  @override
  String get good => 'Good';

  @override
  String get veryGood => 'Very Good';

  @override
  String get excellent => 'Excellent!';

  @override
  String get myFeed => 'My Feed';

  @override
  String get friendsFeed => 'Friends Feed';

  @override
  String get loadMore => 'Load More';

  @override
  String get search => 'Search';

  @override
  String get searchRestaurants => 'Search restaurants...';

  @override
  String get trendingNearYou => 'Trending near you';

  @override
  String get recentSearches => 'Recent searches';

  @override
  String get seeAll => 'See all';

  @override
  String get allRestaurants => 'All restaurants';

  @override
  String get results => 'Results';

  @override
  String resultsFor(Object query) {
    return 'Results for \"$query\"';
  }

  @override
  String get noRestaurantsAvailable => 'No restaurants available';

  @override
  String get noResultsFound => 'No results found';

  @override
  String get tryOtherKeywords => 'Try with other keywords';

  @override
  String get restaurantNotFound => 'Restaurant not found';

  @override
  String get menu => 'Menu';

  @override
  String get rating => 'Rating';

  @override
  String get dish => 'Dish';

  @override
  String get next => 'Next';

  @override
  String get activeChallenges => 'Active challenges';

  @override
  String get allChallenges => 'All challenges';

  @override
  String get joined => 'Joined!';

  @override
  String get resetEmailSent => 'Reset email sent!';

  @override
  String get gallery => 'Gallery';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get selectPhotos => 'Select photos';

  @override
  String maxImagesMessage(Object maxImages) {
    return 'You can select up to $maxImages images';
  }

  @override
  String imageSelectionError(Object error) {
    return 'Image selection failed: $error';
  }

  @override
  String get selectAtLeastOne => 'Please select at least one image';

  @override
  String get comments => 'Comments';

  @override
  String get sharePost => 'Share Post';

  @override
  String get ok => 'OK';

  @override
  String get report => 'Report';

  @override
  String get copyLink => 'Copy link';

  @override
  String get follow => 'Follow';

  @override
  String shareUserProfile(Object username) {
    return 'Share $username\'s Profile';
  }

  @override
  String get copy => 'Copy';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get errorUpdatingFollowStatus => 'Error updating follow status';

  @override
  String get post => 'Post';

  @override
  String get noPostsAvailable => 'No posts available';

  @override
  String get validationSuccess => '✅ Validation successful!';

  @override
  String get signIn => 'Sign In';

  @override
  String get french => 'French';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get emailSupport => '📧 Email: support@ate-app.com';

  @override
  String get addComment => 'Add a comment...';

  @override
  String get imageLoadFailed => 'Failed to load image';

  @override
  String get sharePostDescription =>
      'You can share this post by taking a screenshot or copying the link. Social sharing features coming soon!';

  @override
  String get reportAction => 'Report';

  @override
  String get linkCopied => 'Link copied to clipboard';

  @override
  String hoursAgo(Object hours) {
    return '${hours}h ago';
  }

  @override
  String get dishDetail => 'Dish Detail';

  @override
  String get reviews => 'Reviews';

  @override
  String get restaurantPosts => 'Restaurant Posts';

  @override
  String get timeToEat => 'Time to eat!';

  @override
  String get loginSubtitle =>
      'Connect to find your friends, discover new dishes and share your delicious moments.';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get loggingIn => 'Logging in...';

  @override
  String get signInButton => 'Sign in';

  @override
  String get forgotPasswordTitle => 'Oops, memory lapse?';

  @override
  String get forgotPasswordSubtitle =>
      'No worries! Enter your email address and we\'ll send you a link to reset your password.';

  @override
  String get resetPassword => 'RESET';

  @override
  String get rememberPasswordQuestion => 'Remember your password? ';

  @override
  String get signInLink => 'Sign in';

  @override
  String get welcomeToCommunity => 'Welcome to the Ate community!';

  @override
  String get signupSubtitle =>
      'Create your profile and start exploring your friends\' favorite dishes — discover, share, and savor every moment.';

  @override
  String get fullName => 'Full name';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgotPasswordQuestion => 'Forgot password?';

  @override
  String get registeringAccount => 'Registering...';

  @override
  String get signUp => 'Sign up';

  @override
  String get continueWith => 'Continue with';

  @override
  String get alreadyHaveAccountQuestion => 'Already have an account? ';

  @override
  String get signInNow => 'Sign in';

  @override
  String get profile => 'Profile';

  @override
  String get moreOptions => 'More options';

  @override
  String nowFollowing(Object username) {
    return 'Now following $username';
  }

  @override
  String unfollowed(Object username) {
    return 'Unfollowed $username';
  }

  @override
  String get errorUpdatingFollow => 'Error updating follow status';

  @override
  String get userNotFound => 'User not found';

  @override
  String get followed => 'Followed';

  @override
  String shareProfileCheck(Object bio, Object username) {
    return 'Check out @$username on Ate!\n\n$bio';
  }

  @override
  String shareUserProfileTitle(Object username) {
    return 'Share $username\'s Profile';
  }

  @override
  String shareMyProfile(Object bio, Object username) {
    return 'Check out my profile on Ate!\n\nUsername: @$username\nBio: $bio';
  }

  @override
  String get shareProfileTitle => 'Share Profile';

  @override
  String get username => 'Username';

  @override
  String get bio => 'Bio';

  @override
  String get appVersion => 'Ate v1.0.0';

  @override
  String get deleteAccountWarning =>
      'This action is irreversible. All your data will be permanently deleted.';

  @override
  String get closeButton => 'Close';

  @override
  String get appName => 'Ate';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get noNotifications => 'No notifications yet';

  @override
  String minutesAgo(Object minutes) {
    return '$minutes min ago';
  }

  @override
  String daysAgo(Object days) {
    return '${days}d ago';
  }

  @override
  String get noSavedPosts => 'No saved posts yet';

  @override
  String get savedPostsHint =>
      'Tap the bookmark icon on posts to save them here';

  @override
  String get postUnsaved => 'Post removed from saved';

  @override
  String get noFollowers => 'No followers yet';

  @override
  String get noFollowing => 'Not following anyone yet';

  @override
  String get continueWithSocial => 'Continue with';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get createAccount => 'Create an account';

  @override
  String get choosePhoto => 'Choose a photo';

  @override
  String get addPhotos => 'Add photos';

  @override
  String get shareYourCulinaryExperience =>
      'Share your culinary experience\nwith beautiful photos';

  @override
  String get add => 'Add';

  @override
  String get trending => 'Trending';

  @override
  String get mentions => 'Mentions';

  @override
  String get locationNotSpecified => 'Location not specified';

  @override
  String get activeChallengesLabel => 'Active challenges';

  @override
  String get allChallengesLabel => 'All challenges';

  @override
  String get noChallengesAvailable => 'No challenges available';

  @override
  String get newChallengesWillAppear => 'New challenges will appear here';
}
