// MODIFIED BY CODEX — UI UPGRADE
import 'package:flutter/material.dart';
import 'package:pulse_news/l10n/app_localizations.dart';

import '../models/category_model.dart';

extension AppLocalizationContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  bool get isRtlLocale {
    final code = Localizations.localeOf(this).languageCode;
    return code == 'ar' || code == 'ur';
  }
}

extension LocalizedCategoryLabel on NewsCategory {
  String localizedLabel(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case NewsCategory.topHeadlines:
        return l10n.categoryTopHeadlines;
      case NewsCategory.pakistan:
        return l10n.categoryPakistan;
      case NewsCategory.international:
        return l10n.categoryInternational;
      case NewsCategory.sports:
        return l10n.categorySports;
      case NewsCategory.technology:
        return l10n.categoryTechnology;
      case NewsCategory.business:
        return l10n.categoryBusiness;
      case NewsCategory.entertainment:
        return l10n.categoryEntertainment;
    }
  }
}
