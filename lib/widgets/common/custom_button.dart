import 'package:flutter/material.dart';
import '../../utils/constants.dart';

/// Custom button widget with multiple variants and states
/// Usage:
/// - CustomButton(text: 'Se connecter', onPressed: () {})
/// - CustomButton.secondary(text: 'Annuler', onPressed: () {})
/// - CustomButton.text(text: 'Voir tout', onPressed: () {})
/// - CustomButton(text: 'Next', icon: Icons.arrow_forward, onPressed: () {})
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final CustomButtonVariant variant;
  final CustomButtonSize size;
  final IconData? icon;
  final bool iconRight;
  final bool isLoading;
  final double? width;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = CustomButtonVariant.primary,
    this.size = CustomButtonSize.large,
    this.icon,
    this.iconRight = false,
    this.isLoading = false,
    this.width,
  });

  // Named constructors for convenience
  const CustomButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = CustomButtonSize.large,
    this.icon,
    this.iconRight = false,
    this.isLoading = false,
    this.width,
  }) : variant = CustomButtonVariant.secondary;

  const CustomButton.text({
    super.key,
    required this.text,
    this.onPressed,
    this.size = CustomButtonSize.medium,
    this.icon,
    this.iconRight = false,
    this.isLoading = false,
    this.width,
  }) : variant = CustomButtonVariant.text;

  const CustomButton.icon({
    super.key,
    required this.text,
    required this.icon,
    this.onPressed,
    this.size = CustomButtonSize.large,
    this.iconRight = false,
    this.isLoading = false,
    this.width,
  }) : variant = CustomButtonVariant.primary;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null || isLoading;
    final config = _getButtonConfig();

    return SizedBox(
      width: width,
      height: config.height,
      child: variant == CustomButtonVariant.text
          ? TextButton(
              onPressed: isDisabled ? null : onPressed,
              style: _buildTextButtonStyle(config, isDisabled),
              child: _buildContent(config),
            )
          : ElevatedButton(
              onPressed: isDisabled ? null : onPressed,
              style: _buildElevatedButtonStyle(config, isDisabled),
              child: _buildContent(config),
            ),
    );
  }

  _ButtonConfig _getButtonConfig() {
    switch (size) {
      case CustomButtonSize.small:
        return _ButtonConfig(
          height: 40.0,
          fontSize: 14,
          horizontalPadding: AppSpacing.md,
          iconSize: AppSizes.iconSm,
        );
      case CustomButtonSize.medium:
        return _ButtonConfig(
          height: 44.0,
          fontSize: 15,
          horizontalPadding: AppSpacing.lg,
          iconSize: AppSizes.iconSm,
        );
      case CustomButtonSize.large:
        return _ButtonConfig(
          height: AppSizes.buttonHeight,
          fontSize: 16,
          horizontalPadding: AppSpacing.xl,
          iconSize: AppSizes.icon,
        );
    }
  }

  ButtonStyle _buildElevatedButtonStyle(_ButtonConfig config, bool isDisabled) {
    final isPrimary = variant == CustomButtonVariant.primary;

    return ElevatedButton.styleFrom(
      backgroundColor: isPrimary ? AppColors.primary : AppColors.white,
      foregroundColor: isPrimary ? AppColors.white : AppColors.textDark,
      disabledBackgroundColor: AppColors.border,
      disabledForegroundColor: AppColors.textMedium,
      elevation: 0,
      shadowColor: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: config.horizontalPadding),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusRound),
        side: isPrimary
            ? BorderSide.none
            : BorderSide(
                color: isDisabled ? AppColors.border : AppColors.border,
                width: 1,
              ),
      ),
      textStyle: TextStyle(
        fontSize: config.fontSize,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
    );
  }

  ButtonStyle _buildTextButtonStyle(_ButtonConfig config, bool isDisabled) {
    return TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      disabledForegroundColor: AppColors.textMedium,
      padding: EdgeInsets.symmetric(horizontal: config.horizontalPadding),
      textStyle: TextStyle(
        fontSize: config.fontSize,
        fontWeight: FontWeight.w600,
        decoration: TextDecoration.underline,
      ),
    );
  }

  Widget _buildContent(_ButtonConfig config) {
    if (isLoading) {
      return SizedBox(
        width: config.iconSize,
        height: config.iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == CustomButtonVariant.primary
                ? AppColors.white
                : AppColors.primary,
          ),
        ),
      );
    }

    if (icon == null) {
      return Text(text);
    }

    final iconWidget = Icon(icon, size: config.iconSize);
    final textWidget = Text(text);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: iconRight
          ? [textWidget, SizedBox(width: AppSpacing.sm), iconWidget]
          : [iconWidget, SizedBox(width: AppSpacing.sm), textWidget],
    );
  }
}

// Button variant types
enum CustomButtonVariant {
  primary, // Red background, white text
  secondary, // White background, black text, border
  text, // No background, red text, underlined
}

// Button size presets
enum CustomButtonSize {
  small, // 40px height
  medium, // 44px height
  large, // 50px height (default)
}

// Internal config class
class _ButtonConfig {
  final double height;
  final double fontSize;
  final double horizontalPadding;
  final double iconSize;

  _ButtonConfig({
    required this.height,
    required this.fontSize,
    required this.horizontalPadding,
    required this.iconSize,
  });
}
