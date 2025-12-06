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
}
