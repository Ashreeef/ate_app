import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.white,
      fontFamily: 'DM Sans',

      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.white,
        background: AppColors.background,
        error: AppColors.error,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.textDark,
        onBackground: AppColors.textDark,
        onError: AppColors.white,
      ),

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.textDark),
        titleTextStyle: AppTextStyles.heading3.copyWith(
          fontFamily: 'DM Sans',
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),

      // Bottom Navigation Bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textDark,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedIconTheme: IconThemeData(size: AppSizes.icon),
        unselectedIconTheme: IconThemeData(size: AppSizes.icon),
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          minimumSize: Size(double.infinity, AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusRound),
          ),
          textStyle: AppTextStyles.button.copyWith(
            fontFamily: 'DM Sans',
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textDark,
          minimumSize: Size(double.infinity, AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusRound),
          ),
          side: BorderSide(color: AppColors.border, width: 1),
          textStyle: AppTextStyles.button.copyWith(
            fontFamily: 'DM Sans',
            color: AppColors.textDark,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.link.copyWith(
            fontFamily: 'DM Sans',
          ),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          borderSide: BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        hintStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textMedium,
          fontFamily: 'DM Sans',
        ),
        labelStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textMedium,
          fontFamily: 'DM Sans',
        ),
        errorStyle: AppTextStyles.caption.copyWith(
          color: AppColors.error,
          fontFamily: 'DM Sans',
        ),
        prefixIconColor: AppColors.textMedium,
        suffixIconColor: AppColors.textMedium,
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
        margin: EdgeInsets.zero,
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 0,
      ),

      // Icon theme
      iconTheme: IconThemeData(
        color: AppColors.textDark,
        size: AppSizes.icon,
      ),

      // Checkbox theme
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primary;
          }
          return AppColors.border;
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),

      // Text theme
      textTheme: TextTheme(
        displayLarge: AppTextStyles.heading1.copyWith(fontFamily: 'DM Sans'),
        displayMedium: AppTextStyles.heading2.copyWith(fontFamily: 'DM Sans'),
        displaySmall: AppTextStyles.heading3.copyWith(fontFamily: 'DM Sans'),
        headlineMedium: AppTextStyles.heading4.copyWith(fontFamily: 'DM Sans'),
        bodyLarge: AppTextStyles.body.copyWith(fontFamily: 'DM Sans'),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(fontFamily: 'DM Sans'),
        bodySmall: AppTextStyles.bodySmall.copyWith(fontFamily: 'DM Sans'),
        labelLarge: AppTextStyles.button.copyWith(fontFamily: 'DM Sans'),
        labelMedium: AppTextStyles.captionBold.copyWith(fontFamily: 'DM Sans'),
        labelSmall: AppTextStyles.caption.copyWith(fontFamily: 'DM Sans'),
      ),

      // Floating Action Button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusRound),
        ),
      ),

      // Tab Bar theme
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textMedium,
        indicatorColor: AppColors.primary,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: AppTextStyles.heading4.copyWith(fontFamily: 'DM Sans'),
        unselectedLabelStyle: AppTextStyles.heading4.copyWith(fontFamily: 'DM Sans'),
      ),

      // Snackbar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textDark,
        contentTextStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.white,
          fontFamily: 'DM Sans',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Dialog theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
        ),
        titleTextStyle: AppTextStyles.heading3.copyWith(fontFamily: 'DM Sans'),
        contentTextStyle: AppTextStyles.body.copyWith(fontFamily: 'DM Sans'),
      ),
    );
  }
}
