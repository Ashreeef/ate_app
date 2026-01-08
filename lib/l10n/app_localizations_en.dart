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
  String viewAllComments(Object count) {
    return 'View all $count comments';
  }

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
  String get profile => 'Profile';

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
  String get error => 'Error';

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
  String shareProfileMessage(Object url, Object username) {
    return 'Check out @$username on Ate! Discover their culinary journey here: $url';
  }

  @override
  String get linkCopied => 'Link copied to clipboard!';

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
  String get helpSupport => 'Help & Support';

  @override
  String get contactUs => '📞 Contact Us';

  @override
  String get emailSupport => ' Email: Contact.ate.app@gmail.com';

  @override
  String get phoneSupport => '';

  @override
  String get liveChat => '';

  @override
  String get supportHours => ' Response time: Usually within 24h';

  @override
  String get frequentlyAsked => ' Frequently Asked Questions';

  @override
  String get howToEditProfile => 'How to edit my profile?';

  @override
  String get howToEditProfileAnswer =>
      'Go to Profile > Edit Profile to update your personal information.';

  @override
  String get howToFollowUsers => 'How to follow other users?';

  @override
  String get howToFollowUsersAnswer =>
      'Visit their profile and tap the \'Follow\' button.';

  @override
  String get howToPostPhoto => 'How to share a culinary moment?';

  @override
  String get howToPostPhotoAnswer =>
      'Tap the \'+\' button at the bottom of the screen to share your experience.';

  @override
  String get howToReportContent => 'How to report content?';

  @override
  String get howToReportContentAnswer =>
      'Tap the three dots on any post and select \'Report\'.';

  @override
  String get forgotPasswordHelp => 'Lost your password?';

  @override
  String get forgotPasswordHelpAnswer =>
      'Use the \'Forgot Password\' link on the login screen to reset it.';

  @override
  String get mainFeatures => '✨ Main Features';

  @override
  String get shareculinaryMoments => '• Share your culinary moments';

  @override
  String get followFriends => '• Follow friends and discover new profiles';

  @override
  String get likeComment => '• Like and comment on posts';

  @override
  String get savePosts => '• Save your favorite posts';

  @override
  String get pointsSystem => '• Points and levels system';

  @override
  String get discoverRestaurants => '• Discover new restaurants';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get troubleshooting => ' Troubleshooting';

  @override
  String get restartApp => '• Restart the app if you encounter issues';

  @override
  String get checkInternet => '• Ensure you have an active internet connection';

  @override
  String get updateApp => '• Update to the latest version via Store';

  @override
  String get clearCache => '• Clear app cache if needed';

  @override
  String get contactSupport => '• Contact support via email if issues persist';

  @override
  String get closeDialog => 'Close';

  @override
  String get aboutAte => '🍽️ About Ate';

  @override
  String get appDescription =>
      'Ate is your ultimate culinary companion! Share your gastronomic experiences, discover new restaurants and connect with other food enthusiasts.';

  @override
  String get ourMission => ' Our Mission';

  @override
  String get missionDescription =>
      'Connecting food lovers and making every meal memorable by creating a vibrant community.';

  @override
  String get whatWeOffer => ' What We Offer';

  @override
  String get shareFoodPhotos => '• Share photos of your favorite dishes';

  @override
  String get discoverNewRestaurants => '• Discover hidden gems';

  @override
  String get personalizedRecommendations => '• Personalized recommendations';

  @override
  String get activeCommunity => '• Active community';

  @override
  String get intuitiveInterface => '• Modern and intuitive interface';

  @override
  String get privacyRespect => '• Respect for your privacy';

  @override
  String get theTeam => ' The Team';

  @override
  String get teamDescription => 'Developed with ❤️ by the Ate team.';

  @override
  String get versionInfo => 'Version 1.0.0';

  @override
  String get buildInfo => 'Build 2026.01.08';

  @override
  String get allRightsReserved => '© 2026 Ate App. All rights reserved.';

  @override
  String get madeInAlgeria => 'Made in Algeria 🇩🇿';

  @override
  String get privacySecurity => 'Privacy & Security';

  @override
  String get privateAccount => 'Private Account';

  @override
  String get privateAccountDesc => 'Only followers can see your profile';

  @override
  String get showOnlineStatus => 'Show Online Status';

  @override
  String get showOnlineStatusDesc => 'Let others see when you are active';

  @override
  String get close => 'Close';

  @override
  String get needHelp => 'Need help?';

  @override
  String get phone => 'Phone';

  @override
  String get about => 'About';

  @override
  String get version => 'Version 1.0.0';

  @override
  String get termsPrivacy => 'Terms & Privacy';

  @override
  String get termsOfUse => 'Terms of Use';

  @override
  String get termsOfUseDesc => 'By using Ate, you accept our terms of use.';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicyDesc => 'Your data is safe and protected with us.';

  @override
  String get dataCollection => 'Data Collection';

  @override
  String get dataCollectionDesc =>
      '• Profile info\\n• Photos and posts\\n• Interaction data';

  @override
  String get accountDeleted => 'Account deleted successfully';

  @override
  String get logoutConfirm => 'Are you sure you want to log out?';

  @override
  String get deleteAccountConfirm =>
      'This action is irreversible. All data will be deleted.';

  @override
  String get account => 'Account';

  @override
  String get updateYourInfo => 'Update your information';

  @override
  String get manageAccountSecurity => 'Manage security';

  @override
  String get updateYourPassword => 'Update password';

  @override
  String get preferences => 'Preferences';

  @override
  String get manageNotifications => 'Manage notifications';

  @override
  String get notifications => 'Notifications';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get support => 'Support';

  @override
  String get getHelpWithApp => 'Get help';

  @override
  String get learnMoreAboutApp => 'Learn more about Ate';

  @override
  String get legalInfo => 'Legal info';

  @override
  String get dangerZone => 'Danger Zone';

  @override
  String get logoutFromAccount => 'Log out';

  @override
  String get deleteAccountPermanently => 'Delete permanently';

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
  String get retry => 'Retry';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(Object count) {
    return '${count}m ago';
  }

  @override
  String hoursAgo(Object count) {
    return '${count}h ago';
  }

  @override
  String daysAgo(Object count) {
    return '${count}d ago';
  }

  @override
  String get copyLink => 'Copy link';

  @override
  String get report => 'Report';

  @override
  String get convertToRestaurant => 'Convert to Restaurant';

  @override
  String get viewRestaurant => 'View My Restaurant';

  @override
  String get createChallenge => 'Create Challenge';

  @override
  String get challengeTitle => 'Challenge Title';

  @override
  String get challengeDescription => 'Challenge Description';

  @override
  String get targetCount => 'Target Count';

  @override
  String get rewardBadge => 'Reward Badge';

  @override
  String get joinChallenge => 'Join Challenge';

  @override
  String get leaveChallenge => 'Leave Challenge';

  @override
  String get yourProgress => 'Your Progress';

  @override
  String get daysRemaining => 'Days Remaining';

  @override
  String get challengeEnded => 'Challenge Ended';

  @override
  String get reward => 'Reward';

  @override
  String get dateRange => 'Date Range';

  @override
  String get startDate => 'Start Date';

  @override
  String get endDate => 'End Date';

  @override
  String get conversionWarning => 'This action cannot be undone.';

  @override
  String get confirmConversion => 'Confirm Conversion';

  @override
  String get conversionSuccessful => 'Successfully converted to restaurant!';

  @override
  String get becomeARestaurant => 'Become a Restaurant';

  @override
  String get fillInRestaurantDetails => 'Fill details below';

  @override
  String get restaurantName => 'Restaurant Name';

  @override
  String get cuisineType => 'Cuisine Type';

  @override
  String get location => 'Location';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get website => 'Website';

  @override
  String get openingHours => 'Opening Hours';

  @override
  String get description => 'Description';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get restaurantCreated => 'Restaurant profile created';

  @override
  String get myFeed => 'My Feed';

  @override
  String get friendsFeed => 'Friends';

  @override
  String get noFollowing => 'No following yet';

  @override
  String get search => 'Search';

  @override
  String get postDeleted => 'Post deleted';

  @override
  String failedToDeletePost(Object error) {
    return 'Failed to delete: $error';
  }

  @override
  String failedToAddComment(Object error) {
    return 'Failed to add comment: $error';
  }

  @override
  String get failedToUpdateLike => 'Failed to update like';

  @override
  String get failedToUpdateSave => 'Failed to update save';

  @override
  String get cannotAddComment => 'Cannot add comment';

  @override
  String get noCommentsYet => 'No comments yet';

  @override
  String likesCountText(Object count) {
    return '$count likes';
  }

  @override
  String get imageNotFound => 'Image not found';

  @override
  String get user => 'User';

  @override
  String get deleteAction => 'Delete';

  @override
  String get unknown => 'Unknown';

  @override
  String postsCount(Object count) {
    return '$count Posts';
  }

  @override
  String followersCount(Object count) {
    return '$count Followers';
  }

  @override
  String followingCount(Object count) {
    return '$count Following';
  }

  @override
  String pointsCount(Object count) {
    return '$count Points';
  }

  @override
  String get likes => 'Likes';

  @override
  String get noDishes => 'No dishes found';

  @override
  String get noPostsYet => 'No posts yet';

  @override
  String get newFollowerTitle => 'New Follower';

  @override
  String startedFollowingYou(Object username) {
    return '$username followed you';
  }

  @override
  String get newLikeTitle => 'New Like';

  @override
  String likedYourPost(Object username) {
    return '$username liked your post';
  }

  @override
  String get newCommentTitle => 'New Comment';

  @override
  String commentedOnYourPost(Object username) {
    return '$username commented on your post';
  }

  @override
  String get allCaughtUp => 'All caught up';

  @override
  String get challengeTypeGeneral => 'General';

  @override
  String get challengeTypeRestaurant => 'Restaurant';

  @override
  String get challengeTypeDish => 'Dish';

  @override
  String get challengeTypeLocation => 'Location';

  @override
  String get pleaseLoginFirst => 'Please login first';

  @override
  String get selectStartEndDates => 'Select dates';

  @override
  String get selectChallenge => 'Select a challenge';

  @override
  String get none => 'None';

  @override
  String get pleaseLoginToJoinChallenges => 'Login to join';

  @override
  String get writeReview => 'Write Review';

  @override
  String get fieldRequired => 'Field required';

  @override
  String get reviews => 'Reviews';

  @override
  String get restaurantNotFound => 'Restaurant not found';

  @override
  String get restaurantHint => 'Search restaurants...';

  @override
  String get reviewSuccess => 'Review submitted!';

  @override
  String get rateExperience => 'Rate your experience';

  @override
  String get yourReview => 'Your Review';

  @override
  String get writeReviewHint => 'Share details...';

  @override
  String get noReviewsRow => 'No reviews yet';

  @override
  String get failedToLoadReviews => 'Failed to load reviews';

  @override
  String get onboardingDiscover => 'Discover ';

  @override
  String get onboardingFlavor => 'flavor';

  @override
  String get onboardingOf => ' of ';

  @override
  String get onboardingSharing => 'sharing';

  @override
  String get onboardingWith => ' with ';

  @override
  String get onboardingDescription => 'Ate is your food companion.';

  @override
  String get closeButton => 'Close';

  @override
  String memberLevel(Object level) {
    return '$level Member ⭐';
  }

  @override
  String get rank => 'Rank';

  @override
  String get userPoints => 'User points';

  @override
  String followedUser(Object username) {
    return 'Followed $username';
  }

  @override
  String unfollowedUser(Object username) {
    return 'Unfollowed $username';
  }

  @override
  String get conversionWarningCompact => 'Cannot be undone!';

  @override
  String get followed => 'Followed!';

  @override
  String get manageMenu => 'Manage Menu';

  @override
  String get editRestaurant => 'Edit Restaurant';

  @override
  String get menu => 'Menu';

  @override
  String get restaurant => 'Restaurant';

  @override
  String get rating => 'Rating';

  @override
  String get deleteAccountWarning => 'Danger! This will delete everything.';

  @override
  String get writeCaption => 'Please write a caption';

  @override
  String get enterRestaurant => 'Please enter restaurant name';

  @override
  String get newPost => 'New Post';

  @override
  String get caption => 'Caption';

  @override
  String get captionPlaceholder => 'Share your culinary experience...';

  @override
  String get dishName => 'Dish Name';

  @override
  String get dishNameOptional => 'Dish Name (Optional)';

  @override
  String get dishNamePlaceholder => 'e.g. Royal Couscous, Grilled Fish...';

  @override
  String get yourRating => 'Your Rating';

  @override
  String get disappointing => 'Disappointing';

  @override
  String get fair => 'Fair';

  @override
  String get good => 'Good';

  @override
  String get veryGood => 'Very Good';

  @override
  String get excellent => 'Excellent';

  @override
  String get createNewChallenge => 'Create New Challenge';

  @override
  String get enterChallengeTitle => 'e.g. \"Try 5 Dishes\"';

  @override
  String get titleRequired => 'Title is required';

  @override
  String get titleTooShort => 'Title too short';

  @override
  String get enterDescription => 'Describe the challenge...';

  @override
  String get descriptionRequired => 'Description is required';

  @override
  String get challengeType => 'Challenge Type';

  @override
  String get enterTargetCount => 'e.g. 5';

  @override
  String get targetCountRequired => 'Target count is required';

  @override
  String get invalidTargetCount => 'Invalid count';

  @override
  String get targetCountTooHigh => 'Max 100';

  @override
  String get enterRewardBadge => 'e.g. \"Foodie Explorer 🍕\"';

  @override
  String get rewardBadgeRequired => 'Reward badge is required';

  @override
  String get challengeInfo =>
      'Users earn points by posting about your restaurant';

  @override
  String get challengeDetails => 'Challenge Details';

  @override
  String get fullName => 'Full Name';

  @override
  String get username => 'Username';

  @override
  String get email => 'Email';

  @override
  String get bio => 'Bio';

  @override
  String get confirm => 'Confirm';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get enterRestaurantName => 'Enter restaurant name';

  @override
  String get restaurantNameRequired => 'Restaurant name required';

  @override
  String get restaurantNameTooShort => 'Name too short';

  @override
  String get enterCuisineType => 'e.g. Italian, Chinese';

  @override
  String get cuisineTypeRequired => 'Cuisine type required';

  @override
  String get enterLocation => 'Enter location';

  @override
  String get locationRequired => 'Location required';

  @override
  String get hours => 'Hours';

  @override
  String get enterHours => 'e.g. Mon-Fri 9am-10pm';

  @override
  String get convertNow => 'Convert Now';

  @override
  String get mentions => 'Mentions';

  @override
  String get locationNotSpecified => 'Location not specified';

  @override
  String get restaurantUpdatedSuccess => 'Restaurant updated successfully';

  @override
  String get addCoverPhoto => 'Add Cover Photo';

  @override
  String get deleteDish => 'Delete Dish?';

  @override
  String deleteDishConfirm(Object name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get delete => 'Delete';

  @override
  String get menuEmpty => 'Menu is empty';

  @override
  String get addFirstDish => 'Add First Dish';

  @override
  String get couldNotLoadMenu => 'Could not load menu';

  @override
  String uploadImageFail(Object error) {
    return 'Upload failed: $error';
  }

  @override
  String get editDish => 'Edit Dish';

  @override
  String get addDish => 'Add Dish';

  @override
  String get addDishPhoto => 'Add Dish Photo';

  @override
  String get price => 'Price';

  @override
  String get category => 'Category';

  @override
  String get dishDescription => 'Description';

  @override
  String get doYouWantToContinue => 'Do you want to continue?';

  @override
  String get trending => 'Trending';

  @override
  String get allRestaurants => 'All Restaurants';

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
  String get tryOtherKeywords => 'Try other keywords';

  @override
  String get noFollowers => 'No followers yet';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get forgotPasswordTitle => 'Forgot Password?';

  @override
  String get forgotPasswordSubtitle =>
      'Don\'t worry! Enter your email address below and we will send you a link to reset your password.';

  @override
  String get rememberPasswordQuestion => 'Remember your password? ';

  @override
  String get signInLink => 'Sign In';

  @override
  String get loggingIn => 'Logging In...';

  @override
  String get signInButton => 'Sign In';

  @override
  String get timeToEat => 'It\'s time to eat!';

  @override
  String get loginSubtitle =>
      'Sign in to find your friends, discover new dishes, and share your delicious moments.';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get continueWithSocial => 'Or continue with';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get createAccount => 'Create Account';

  @override
  String get registeringAccount => 'Registering...';

  @override
  String get signUp => 'Sign Up';

  @override
  String get welcomeToCommunity => 'Welcome to the Ate Community!';

  @override
  String get signupSubtitle =>
      'Create your profile and start exploring your friends\' favorite dishes — discover, share, and savor every moment.';

  @override
  String get password => 'Password';

  @override
  String get forgotPasswordQuestion => 'Forgot Password?';

  @override
  String get continueWith => 'Continue With';

  @override
  String get alreadyHaveAccountQuestion => 'Already have an account? ';

  @override
  String get signInNow => 'Sign In';

  @override
  String get next => 'Next';

  @override
  String get markAllAsRead => 'Mark all as read';

  @override
  String get noNotifications => 'No notifications yet';

  @override
  String get searchRestaurants => 'Search restaurants...';

  @override
  String get trendingNearYou => 'Trending Near You';

  @override
  String get seeAll => 'See All';

  @override
  String get recentSearches => 'Recent Searches';

  @override
  String maxImagesMessage(Object maxImages) {
    return 'You can only select $maxImages images';
  }

  @override
  String imageSelectionError(Object error) {
    return 'Failed to pick image: $error';
  }

  @override
  String get selectAtLeastOne => 'Select at least one image';

  @override
  String get choosePhoto => 'Choose Photo';

  @override
  String get gallery => 'Gallery';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get addPhotos => 'Add Photos';

  @override
  String get shareYourCulinaryExperience =>
      'Share your culinary experience\nwith beautiful photos';

  @override
  String get selectPhotos => 'Select Photos';

  @override
  String get add => 'Add';

  @override
  String get activeChallengesLabel => 'Active Challenges';

  @override
  String get allChallengesLabel => 'All Challenges';

  @override
  String get noChallengesAvailable => 'No challenges available';

  @override
  String get newChallengesWillAppear => 'New challenges will appear here';

  @override
  String get post => 'Post';

  @override
  String get imageLoadFailed => 'Failed to load image';

  @override
  String get comments => 'Comments';

  @override
  String get addComment => 'Add a comment...';

  @override
  String get deletePost => 'Delete Post?';

  @override
  String get deletePostConfirm => 'This action cannot be undone.';

  @override
  String get publish => 'Publish';

  @override
  String get postPublished => 'Post published successfully!';

  @override
  String get follow => 'Follow';
}
