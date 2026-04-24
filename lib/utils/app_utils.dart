// lib/utils/app_utils.dart
// Shared utility functions, constants, and extensions for Pulse News.

import 'package:flutter/material.dart';

// ─── App Constants ────────────────────────────────────────────────────────────

class AppConstants {
  AppConstants._();

  static const String appName = 'Pulse News';
  static const String newsApiBaseUrl = 'https://newsapi.org/v2';

  // Hive box names
  static const String bookmarksBox = 'bookmarks';
  static const String prefsBox = 'prefs';

  // SharedPrefs keys
  static const String darkModeKey = 'isDarkMode';

  // Pagination
  static const int pageSize = 20;

  // Animation durations
  static const Duration shortAnim = Duration(milliseconds: 200);
  static const Duration mediumAnim = Duration(milliseconds: 350);
  static const Duration longAnim = Duration(milliseconds: 500);

  // Default image placeholder (fallback for broken images)
  static const String placeholderImageUrl =
      'https://via.placeholder.com/400x200?text=Pulse+News';
}

// ─── String Extensions ────────────────────────────────────────────────────────

extension StringExtension on String {
  /// Capitalize first letter
  String get capitalized =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  /// Truncate with ellipsis
  String truncate(int maxLength) =>
      length > maxLength ? '${substring(0, maxLength)}...' : this;

  /// Check if string is a valid URL
  bool get isValidUrl => startsWith('http://') || startsWith('https://');
}

// ─── DateTime Extensions ──────────────────────────────────────────────────────

extension DateTimeExtension on DateTime {
  /// Returns "Today", "Yesterday", or formatted date
  String get friendlyDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(year, month, day);
    final diff = today.difference(date).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '$day ${_monthName(month)} $year';
  }

  String _monthName(int m) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[m];
  }
}

// ─── Context Extensions ───────────────────────────────────────────────────────

extension ContextExtension on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get isTablet => screenWidth >= 600;
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  void showSnackBar(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: backgroundColor ?? colors.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
