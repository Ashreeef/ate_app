import 'package:flutter/material.dart';

class AppColors {
  // Primary colors from Figma
  static const primary = Color(0xFFFF0036); // Red #FF0036 - Main brand color
  static const secondary = Color(0xFF000000); // Black - Secondary brand color
  static const white = Color(0xFFFFFFFF); // White - Background and text

  // Text colors
  static const textDark = Color(0xFF000000); // Black - Primary text
  static const textMedium = Color(0xFF707070); // Gray #707070 - Secondary text
  static const textLight = Color(0xFF999999); // Light gray - Tertiary text

  // Background colors
  static const background = Color(
    0xFFF5F5F5,
  ); // Light gray - General background
  static const backgroundLight = Color(
    0xFFFAFAFA,
  ); // Very light gray - Card background
  static const backgroundPink = Color(
    0xFFFFC4D6,
  ); // Light pink - Profile header

  // UI Element colors
  static const border = Color(0xFFE0E0E0); // Border color
  static const divider = Color(0xFFEEEEEE); // Divider color
  static const shadow = Color(0x1A000000); // Shadow with 10% opacity

  // Status colors
  static const success = Color(0xFF28A745); // Green for success states
  static const error = Color(0xFFFF0036); // Use primary red for errors
  static const warning = Color(0xFFFFC107); // Yellow for warnings
  static const info = Color(0xFF17A2B8); // Blue for info

  // Star rating color
  static const starActive = Color(0xFFFF0036); // Active star - primary red
  static const starInactive = Color(0xFFE0E0E0); // Inactive star - gray

  // Social button colors
  static const google = Color(0xFFDB4437); // Google red
  static const facebook = Color(0xFF4267B2); // Facebook blue
  static const apple = Color(0xFF000000); // Apple black
}

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
}

class AppSizes {
  // Border radius
  static const double borderRadiusSm = 8.0;
  static const double borderRadius = 12.0;
  static const double borderRadiusLg = 16.0;
  static const double borderRadiusXl = 24.0;
  static const double borderRadiusRound = 100.0; // For circular elements

  // Component heights
  static const double buttonHeight = 50.0;
  static const double inputHeight = 56.0;
  static const double appBarHeight = 56.0;
  static const double bottomNavHeight = 60.0;

  // Icon sizes
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double icon = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;

  // Avatar sizes
  static const double avatarSm = 32.0;
  static const double avatar = 40.0;
  static const double avatarLg = 64.0;
  static const double avatarXl = 100.0;
  static const double avatarXxl = 120.0;

  // Post card sizes
  static const double postImageHeight = 300.0;
  static const double postThumbnailSize = 120.0;

  // Splash screen dot sizes (for animated dots)
  static const double dotSm = 8.0;
  static const double dotMd = 16.0;
  static const double dotLg = 32.0;
}

class AppTextStyles {
  // Headings - colors inherited from theme
  static const heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  static const heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.3,
  );

  static const heading3 = TextStyle(fontSize: 20, fontWeight: FontWeight.w700);

  static const heading4 = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);

  // Body text - colors inherited from theme
  static const body = TextStyle(fontSize: 16, fontWeight: FontWeight.normal);

  static const bodyMedium = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.normal,
  );

  static const bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  // Caption and labels - colors inherited from theme
  static const caption = TextStyle(fontSize: 12, fontWeight: FontWeight.normal);

  static const captionBold = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static const overline = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  // Button text - keep white for buttons
  static const button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    letterSpacing: 0.3,
  );

  static const buttonSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  // Special text styles - inherit from theme except links
  static const username = TextStyle(fontSize: 14, fontWeight: FontWeight.w600);

  static const timestamp = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.normal,
  );

  static const link = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    decoration: TextDecoration.none,
  );

  static const badge = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
    letterSpacing: 0.5,
  );
}

// App-specific constants
class AppConstants {
  // App info
  static const String appName = 'Ate';
  static const String appTagline =
      'Découvre la vraie saveur du partage avec Ate !';

  // Splash screen
  static const int splashDuration = 2000; // milliseconds
  static const int splashDotAnimationDuration = 300; // milliseconds

  // Post limits
  static const int maxPostImages = 3;
  static const int maxCaptionLength = 500;

  // Rating
  static const int maxRating = 5;

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Pagination
  static const int postsPerPage = 10;
  static const int restaurantsPerPage = 20;
}
