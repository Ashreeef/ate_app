import 'constants.dart';

/// Input validation utilities
class Validators {
  /// Validate email format
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    return email.contains('@') && email.contains('.');
  }

  /// Validate username
  static String? validateUsername(String? username) {
    if (username == null || username.trim().isEmpty) {
      return 'Username is required';
    }
    if (username.trim().length < AppConstants.minUsernameLength) {
      return 'Username must be at least ${AppConstants.minUsernameLength} characters';
    }
    if (username.trim().length > AppConstants.maxUsernameLength) {
      return 'Username must be less than ${AppConstants.maxUsernameLength} characters';
    }
    return null;
  }

  /// Validate email
  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Email is required';
    }
    if (!isValidEmail(email.trim())) {
      return 'Please enter a valid email';
    }
    return null;
  }

  /// Validate password
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }
    if (password.length > AppConstants.maxPasswordLength) {
      return 'Password must be less than ${AppConstants.maxPasswordLength} characters';
    }
    return null;
  }

  /// Validate password confirmation
  static String? validatePasswordConfirmation(
    String? password,
    String? confirmation,
  ) {
    if (confirmation == null || confirmation.isEmpty) {
      return 'Please confirm your password';
    }
    if (password != confirmation) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validate bio
  static String? validateBio(String? bio) {
    if (bio != null && bio.trim().length > AppConstants.maxBioLength) {
      return 'Bio must be less than ${AppConstants.maxBioLength} characters';
    }
    return null;
  }

  /// Validate phone number
  static String? validatePhone(String? phone) {
    if (phone != null &&
        phone.trim().isNotEmpty &&
        phone.trim().length > AppConstants.maxPhoneLength) {
      return 'Phone must be less than ${AppConstants.maxPhoneLength} characters';
    }
    return null;
  }

  /// Validate caption
  static String? validateCaption(String? caption) {
    if (caption == null || caption.trim().isEmpty) {
      return 'Caption is required';
    }
    if (caption.trim().length > AppConstants.maxCaptionLength) {
      return 'Caption must be less than ${AppConstants.maxCaptionLength} characters';
    }
    return null;
  }
}
