
import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  static const String appName = 'Pulse News';
  static const String newsApiBaseUrl = 'https://newsapi.org/v2';
  static const String bookmarksBox = 'bookmarks';
  static const String prefsBox = 'prefs';
  static const String darkModeKey = 'isDarkMode';
  static const int pageSize = 20;
  static const Duration shortAnim = Duration(milliseconds: 200);
  static const Duration mediumAnim = Duration(milliseconds: 350);
  static const Duration longAnim = Duration(milliseconds: 500);
  static const String placeholderImageUrl =
      'https://via.placeholder.com/400x200?text=Pulse+News';
}

extension StringExtension on String {
  String get capitalized =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
  String truncate(int maxLength) =>
      length > maxLength ? '${substring(0, maxLength)}...' : this;
  bool get isValidUrl => startsWith('http://') || startsWith('https://');
}

extension DateTimeExtension on DateTime {
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
