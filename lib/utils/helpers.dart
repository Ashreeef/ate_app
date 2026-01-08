import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';

class AppHelpers {
  /// Formats a [DateTime] into a human-friendly "time ago" string.
  /// Examples: "Just now", "2h ago", "Jan 8"
  static String formatTimeAgo(BuildContext context, DateTime dateTime) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return DateFormat.MMMd().format(dateTime);

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return l10n.justNow;
    } else if (difference.inMinutes < 60) {
      return l10n.minutesAgo(difference.inMinutes);
    } else if (difference.inHours < 24) {
      return l10n.hoursAgo(difference.inHours);
    } else if (difference.inDays < 7) {
      return l10n.daysAgo(difference.inDays);
    } else {
      // For older posts, show simple date like "Jan 8"
      final currentYear = now.year;
      final postYear = dateTime.year;
      
      if (currentYear == postYear) {
        return DateFormat.MMMd(l10n.localeName).format(dateTime);
      } else {
        return DateFormat.yMMMd(l10n.localeName).format(dateTime);
      }
    }
  }
}
