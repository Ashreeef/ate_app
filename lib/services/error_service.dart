import 'dart:ui';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Centralized service for error logging and reporting
class ErrorService {
  // Singleton instance
  static final ErrorService _instance = ErrorService._internal();
  factory ErrorService() => _instance;
  ErrorService._internal();

  /// Initialize error handling
  Future<void> initialize() async {
    // Pass all uncaught "fatal" errors from the framework to Crashlytics
    FlutterError.onError = (errorDetails) {
      // Log to console in debug
      if (kDebugMode) {
        FlutterError.dumpErrorToConsole(errorDetails);
      }
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      // Log to console in debug
      if (kDebugMode) {
        debugPrint('🔴 UNCAUGHT ASYNC ERROR: $error');
        debugPrint(stack.toString());
      }
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  /// Log error to console and Crashlytics
  void logError(
    dynamic error,
    StackTrace? stackTrace, {
    String? context,
    bool isFatal = false,
  }) {
    // Log to console in debug mode
    if (kDebugMode) {
      debugPrint('🔴 ERROR [${context ?? 'Unknown'}]: $error');
      if (stackTrace != null) {
        debugPrint('Stack trace:\n$stackTrace');
      }
    }

    // Log to Crashlytics
    try {
      FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: context,
        fatal: isFatal,
      );
    } catch (e) {
      // Fallback if Crashlytics fails
      debugPrint('Failed to report error to Crashlytics: $e');
    }
  }

  /// Show user-friendly error message
  void showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'DISMISS',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
