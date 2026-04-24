import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppFontScale { small, medium, large }

class AppLocaleOption {
  const AppLocaleOption({
    required this.locale,
    required this.flag,
    required this.nameBuilder,
  });

  final Locale locale;
  final String flag;
  final String Function(BuildContext context) nameBuilder;
}

class AppSettingsController extends ChangeNotifier {
  AppSettingsController._({
    required this.locale,
    required this.themeMode,
    required this.fontScale,
    required this.notificationsEnabled,
    required this.recentSearches,
  });

  static const _localeKey = 'ui_locale_code';
  static const _themeModeKey = 'ui_theme_mode';
  static const _fontScaleKey = 'ui_font_scale';
  static const _notificationsKey = 'ui_notifications';
  static const _recentSearchesKey = 'ui_recent_searches';

  Locale locale;
  ThemeMode themeMode;
  AppFontScale fontScale;
  bool notificationsEnabled;
  List<String> recentSearches;

  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('ar'),
    Locale('ur'),
    Locale('fr'),
    Locale('es'),
  ];

  bool get isRtl => locale.languageCode == 'ar' || locale.languageCode == 'ur';

  double get textScaleFactor {
    switch (fontScale) {
      case AppFontScale.small:
        return 0.92;
      case AppFontScale.medium:
        return 1;
      case AppFontScale.large:
        return 1.1;
    }
  }

  static Future<AppSettingsController> load() async {
    final prefs = await SharedPreferences.getInstance();

    final localeCode = prefs.getString(_localeKey) ?? 'en';
    final themeModeName =
        prefs.getString(_themeModeKey) ?? ThemeMode.system.name;
    final fontScaleName =
        prefs.getString(_fontScaleKey) ?? AppFontScale.medium.name;

    return AppSettingsController._(
      locale: supportedLocales.firstWhere(
        (locale) => locale.languageCode == localeCode,
        orElse: () => const Locale('en'),
      ),
      themeMode: ThemeMode.values.firstWhere(
        (mode) => mode.name == themeModeName,
        orElse: () => ThemeMode.system,
      ),
      fontScale: AppFontScale.values.firstWhere(
        (scale) => scale.name == fontScaleName,
        orElse: () => AppFontScale.medium,
      ),
      notificationsEnabled: prefs.getBool(_notificationsKey) ?? true,
      recentSearches: prefs.getStringList(_recentSearchesKey) ?? <String>[],
    );
  }

  Future<void> setLocale(Locale newLocale) async {
    locale = newLocale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, newLocale.languageCode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode.name);
  }

  Future<void> quickToggleTheme() async {
    if (themeMode == ThemeMode.dark) {
      await setThemeMode(ThemeMode.light);
      return;
    }
    await setThemeMode(ThemeMode.dark);
  }

  Future<void> setFontScale(AppFontScale scale) async {
    fontScale = scale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fontScaleKey, scale.name);
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    notificationsEnabled = enabled;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, enabled);
  }

  Future<void> addRecentSearch(String query) async {
    final normalized = query.trim();
    if (normalized.isEmpty) {
      return;
    }

    recentSearches = [
      normalized,
      ...recentSearches.where(
        (existing) => existing.toLowerCase() != normalized.toLowerCase(),
      ),
    ].take(8).toList();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_recentSearchesKey, recentSearches);
  }

  Future<void> removeRecentSearch(String query) async {
    recentSearches = recentSearches.where((item) => item != query).toList();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_recentSearchesKey, recentSearches);
  }

  Future<void> clearRecentSearches() async {
    recentSearches = <String>[];
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_recentSearchesKey);
  }
}

class AppSettingsScope extends InheritedNotifier<AppSettingsController> {
  const AppSettingsScope({
    super.key,
    required AppSettingsController controller,
    required super.child,
  }) : super(notifier: controller);

  static AppSettingsController of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<AppSettingsScope>();
    assert(scope != null, 'AppSettingsScope not found in widget tree.');
    return scope!.notifier!;
  }

  static AppSettingsController read(BuildContext context) {
    final element =
        context.getElementForInheritedWidgetOfExactType<AppSettingsScope>();
    final scope = element?.widget as AppSettingsScope?;
    assert(scope != null, 'AppSettingsScope not found in widget tree.');
    return scope!.notifier!;
  }
}
