// lib/models/category_model.dart
// Defines news categories with display labels, API parameters, and icons

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

enum NewsCategory {
  topHeadlines,
  pakistan,
  international,
  sports,
  technology,
  business,
  entertainment,
}

extension NewsCategoryExtension on NewsCategory {
  String get label {
    switch (this) {
      case NewsCategory.topHeadlines:
        return 'Top Headlines';
      case NewsCategory.pakistan:
        return 'Pakistan';
      case NewsCategory.international:
        return 'Global';
      case NewsCategory.sports:
        return 'Sports';
      case NewsCategory.technology:
        return 'Tech';
      case NewsCategory.business:
        return 'Business';
      case NewsCategory.entertainment:
        return 'Entertainment';
    }
  }

  /// Category value sent to NewsAPI (category param)
  String? get apiCategory {
    switch (this) {
      case NewsCategory.topHeadlines:
        return null;
      case NewsCategory.pakistan:
        return null; // uses country=pk instead
      case NewsCategory.international:
        return 'general';
      case NewsCategory.sports:
        return 'sports';
      case NewsCategory.technology:
        return 'technology';
      case NewsCategory.business:
        return 'business';
      case NewsCategory.entertainment:
        return 'entertainment';
    }
  }

  /// Country code for NewsAPI
  String get country {
    switch (this) {
      case NewsCategory.pakistan:
        return 'pk';
      case NewsCategory.international:
        return 'us';
      default:
        return 'us';
    }
  }

  IconData get icon {
    switch (this) {
      case NewsCategory.topHeadlines:
        return Iconsax.flash;
      case NewsCategory.pakistan:
        return Iconsax.global;
      case NewsCategory.international:
        return Iconsax.airplane;
      case NewsCategory.sports:
        return Iconsax.cup;
      case NewsCategory.technology:
        return Iconsax.cpu;
      case NewsCategory.business:
        return Iconsax.chart;
      case NewsCategory.entertainment:
        return Iconsax.music;
    }
  }
}
