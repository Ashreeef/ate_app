import 'package:flutter/material.dart';
import '../../utils/constants.dart';

/// Type of text field based on usage
enum CustomTextFieldType { email, password, text, search, multiline }

/// Custom reusable text field widget
///
/// Usage:
/// ```dart
/// CustomTextField(
///   label: 'Email',
///   type: CustomTextFieldType.email,
///   onChanged: (value) => print(value),
/// )
///
/// CustomTextField.password(
///   label: 'Mot de passe',
///   onChanged: (value) => print(value),
/// )
///
/// CustomTextField.search(
///   hint: 'Rechercher...',
///   onChanged: (value) => print(value),
/// )
/// ```
class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? error;
  final String? initialValue;
  final CustomTextFieldType type;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.error,
    this.initialValue,
    this.type = CustomTextFieldType.text,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onEditingComplete,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines,
    this.minLines,
    this.textInputAction,
    this.focusNode,
    this.prefixIcon,
    this.suffixIcon,
  });

  // Named constructor for email input
  const CustomTextField.email({
    Key? key,
    String? label = 'Email',
    String? hint,
    String? error,
    String? initialValue,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    VoidCallback? onEditingComplete,
    bool enabled = true,
    TextInputAction? textInputAction,
    FocusNode? focusNode,
  }) : this(
         key: key,
         label: label,
         hint: hint,
         error: error,
         initialValue: initialValue,
         type: CustomTextFieldType.email,
         controller: controller,
         onChanged: onChanged,
         onEditingComplete: onEditingComplete,
         enabled: enabled,
         textInputAction: textInputAction,
         focusNode: focusNode,
         prefixIcon: const Icon(Icons.email_outlined),
       );

  // Named constructor for password input
  const CustomTextField.password({
    Key? key,
    String? label = 'Mot de passe',
    String? hint,
    String? error,
    String? initialValue,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    VoidCallback? onEditingComplete,
    bool enabled = true,
    TextInputAction? textInputAction,
    FocusNode? focusNode,
  }) : this(
         key: key,
         label: label,
         hint: hint,
         error: error,
         initialValue: initialValue,
         type: CustomTextFieldType.password,
         controller: controller,
         onChanged: onChanged,
         onEditingComplete: onEditingComplete,
         enabled: enabled,
         textInputAction: textInputAction,
         focusNode: focusNode,
         prefixIcon: const Icon(Icons.lock_outline),
       );

  // Named constructor for search input
  const CustomTextField.search({
    Key? key,
    String? hint = 'Rechercher...',
    String? error,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    VoidCallback? onTap,
    bool enabled = true,
    FocusNode? focusNode,
  }) : this(
         key: key,
         hint: hint,
         error: error,
         type: CustomTextFieldType.search,
         controller: controller,
         onChanged: onChanged,
         onSubmitted: onSubmitted,
         onTap: onTap,
         enabled: enabled,
         focusNode: focusNode,
         prefixIcon: const Icon(Icons.search),
       );

  // Named constructor for multiline text
  const CustomTextField.multiline({
    Key? key,
    String? label,
    String? hint,
    String? error,
    String? initialValue,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    bool enabled = true,
    int maxLines = 4,
    int minLines = 3,
    TextInputAction? textInputAction,
    FocusNode? focusNode,
  }) : this(
         key: key,
         label: label,
         hint: hint,
         error: error,
         initialValue: initialValue,
         type: CustomTextFieldType.multiline,
         controller: controller,
         onChanged: onChanged,
         enabled: enabled,
         maxLines: maxLines,
         minLines: minLines,
         textInputAction: textInputAction,
         focusNode: focusNode,
       );

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = _getFieldConfig();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        TextFormField(
          controller: _controller,
          focusNode: widget.focusNode,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          obscureText:
              widget.type == CustomTextFieldType.password && _obscurePassword,
          keyboardType: config.keyboardType,
          textInputAction: widget.textInputAction ?? config.textInputAction,
          maxLines: widget.type == CustomTextFieldType.password
              ? 1
              : (widget.maxLines ?? config.maxLines),
          minLines: widget.minLines ?? config.minLines,
          style: AppTextStyles.bodyMedium.copyWith(
            color:
                widget.type == CustomTextFieldType.search &&
                    Theme.of(context).brightness == Brightness.dark
                ? AppColors.white
                : null,
          ),
          decoration: InputDecoration(
            hintText: widget.hint ?? config.hint,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color:
                  widget.type == CustomTextFieldType.search &&
                      Theme.of(context).brightness == Brightness.dark
                  ? AppColors.textLight
                  : AppColors.textLight,
            ),
            prefixIcon: widget.prefixIcon != null
                ? IconTheme(
                    data: IconThemeData(
                      color:
                          widget.type == CustomTextFieldType.search &&
                              Theme.of(context).brightness == Brightness.dark
                          ? AppColors.white
                          : null,
                    ),
                    child: widget.prefixIcon!,
                  )
                : config.prefixIcon,
            suffixIcon: _buildSuffixIcon(),
            filled: true,
            fillColor:
                widget.type == CustomTextFieldType.search &&
                    Theme.of(context).brightness == Brightness.dark
                ? AppColors.secondary.withValues(alpha: 0.15)
                : (widget.enabled
                      ? AppColors.white
                      : AppColors.backgroundLight),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: widget.type == CustomTextFieldType.multiline
                  ? AppSpacing.md
                  : AppSpacing.sm,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusRound),
              borderSide: BorderSide(
                color: widget.error != null
                    ? AppColors.error
                    : (widget.type == CustomTextFieldType.search &&
                              Theme.of(context).brightness == Brightness.dark
                          ? AppColors.white
                          : AppColors.border),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusRound),
              borderSide: BorderSide(
                color: widget.error != null
                    ? AppColors.error
                    : (widget.type == CustomTextFieldType.search &&
                              Theme.of(context).brightness == Brightness.dark
                          ? AppColors.white
                          : AppColors.border),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusRound),
              borderSide: BorderSide(
                color: widget.error != null
                    ? AppColors.error
                    : (widget.type == CustomTextFieldType.search &&
                              Theme.of(context).brightness == Brightness.dark
                          ? AppColors.white
                          : AppColors.primary),
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusRound),
              borderSide: BorderSide(
                color:
                    widget.type == CustomTextFieldType.search &&
                        Theme.of(context).brightness == Brightness.dark
                    ? AppColors.white.withValues(
                        alpha: AppConstants.opacityMedium,
                      )
                    : AppColors.border.withValues(
                        alpha: AppConstants.opacityMedium,
                      ),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusRound),
              borderSide: const BorderSide(color: AppColors.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusRound),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
          ),
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          onEditingComplete: widget.onEditingComplete,
        ),
        if (widget.error != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Icon(
                Icons.error_outline,
                size: AppSizes.iconXs,
                color: AppColors.error,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  widget.error!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.suffixIcon != null) return widget.suffixIcon;

    // Password visibility toggle
    if (widget.type == CustomTextFieldType.password) {
      return IconButton(
        icon: Icon(
          _obscurePassword
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: AppColors.textMedium,
        ),
        onPressed: () {
          setState(() => _obscurePassword = !_obscurePassword);
        },
      );
    }

    // Clear button for search when text is entered
    if (widget.type == CustomTextFieldType.search &&
        _controller.text.isNotEmpty) {
      return IconButton(
        icon: Icon(
          Icons.close,
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.white
              : AppColors.textMedium,
        ),
        onPressed: () {
          _controller.clear();
          widget.onChanged?.call('');
        },
      );
    }

    return null;
  }

  _FieldConfig _getFieldConfig() {
    switch (widget.type) {
      case CustomTextFieldType.email:
        return _FieldConfig(
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          prefixIcon: widget.prefixIcon,
        );
      case CustomTextFieldType.password:
        return _FieldConfig(
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          prefixIcon: widget.prefixIcon,
        );
      case CustomTextFieldType.search:
        return _FieldConfig(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          prefixIcon: widget.prefixIcon,
        );
      case CustomTextFieldType.multiline:
        return _FieldConfig(
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          maxLines: widget.maxLines ?? 4,
          minLines: widget.minLines ?? 3,
        );
      case CustomTextFieldType.text:
        return _FieldConfig(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
        );
    }
  }
}

class _FieldConfig {
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Widget? prefixIcon;
  final int? maxLines;
  final int? minLines;

  _FieldConfig({
    required this.keyboardType,
    required this.textInputAction,
    this.prefixIcon,
    this.maxLines = 1,
    this.minLines = 1,
  });

  String? get hint => null;
}
