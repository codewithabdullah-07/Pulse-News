import 'package:flutter/material.dart';

import '../l10n/app_localizations_ext.dart';
import '../theme/app_settings_controller.dart';
import '../widgets/pulse_app_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const _version = '1.0.0+1';

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);
    final l10n = context.l10n;

    return Scaffold(
      appBar: PulseAppBar(
        title: l10n.settingsNav,
        subtitle: l10n.sectionSettingsSubtitle,
        showNotification: false,
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
          children: [
            _SectionCard(
              children: [
                _SettingsTile(
                  leading: const _CodeBadge(code: 'EN'),
                  title: l10n.language,
                  subtitle:
                      _languageName(context, settings.locale.languageCode),
                  onTap: () => _showLanguagePicker(context, settings),
                ),
                _SettingsTile(
                  leading: const Icon(Icons.color_lens_outlined),
                  title: l10n.theme,
                  subtitle: _themeName(context, settings.themeMode),
                  onTap: () => _showThemePicker(context, settings),
                ),
                _SettingsTile(
                  leading: const Icon(Icons.format_size_rounded),
                  title: l10n.fontSize,
                  subtitle: _fontName(context, settings.fontScale),
                  onTap: () => _showFontPicker(context, settings),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _SectionCard(
              children: [
                SwitchListTile.adaptive(
                  value: settings.notificationsEnabled,
                  onChanged: (value) => settings.setNotificationsEnabled(value),
                  secondary: const Icon(Icons.notifications_active_outlined),
                  title: Text(l10n.notifications),
                  subtitle: Text(l10n.notificationsEnabled),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _SectionCard(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded),
                  title: Text(l10n.about),
                  subtitle: Text(l10n.versionLabel(_version)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _languageName(BuildContext context, String code) {
    final l10n = context.l10n;
    switch (code) {
      case 'ar':
        return l10n.languageArabic;
      case 'ur':
        return l10n.languageUrdu;
      case 'fr':
        return l10n.languageFrench;
      case 'es':
        return l10n.languageSpanish;
      default:
        return l10n.languageEnglish;
    }
  }

  String _themeName(BuildContext context, ThemeMode mode) {
    final l10n = context.l10n;
    switch (mode) {
      case ThemeMode.system:
        return l10n.themeSystem;
      case ThemeMode.light:
        return l10n.themeLight;
      case ThemeMode.dark:
        return l10n.themeDark;
    }
  }

  String _fontName(BuildContext context, AppFontScale fontScale) {
    final l10n = context.l10n;
    switch (fontScale) {
      case AppFontScale.small:
        return l10n.fontSmall;
      case AppFontScale.medium:
        return l10n.fontMedium;
      case AppFontScale.large:
        return l10n.fontLarge;
    }
  }

  Future<void> _showLanguagePicker(
    BuildContext context,
    AppSettingsController settings,
  ) async {
    final l10n = context.l10n;
    final options = [
      ('EN', const Locale('en'), l10n.languageEnglish),
      ('AR', const Locale('ar'), l10n.languageArabic),
      ('UR', const Locale('ur'), l10n.languageUrdu),
      ('FR', const Locale('fr'), l10n.languageFrench),
      ('ES', const Locale('es'), l10n.languageSpanish),
    ];

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return RadioGroup<Locale>(
          groupValue: settings.locale,
          onChanged: (value) {
            if (value == null) {
              return;
            }
            settings.setLocale(value);
            Navigator.pop(sheetContext);
          },
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: Text(l10n.settingsLanguagePicker),
              ),
              ...options.map(
                (item) => RadioListTile<Locale>(
                  value: item.$2,
                  title: Text('${item.$1} ${item.$3}'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showThemePicker(
    BuildContext context,
    AppSettingsController settings,
  ) async {
    final l10n = context.l10n;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return RadioGroup<ThemeMode>(
          groupValue: settings.themeMode,
          onChanged: (value) {
            if (value == null) {
              return;
            }
            settings.setThemeMode(value);
            Navigator.pop(sheetContext);
          },
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(title: Text(l10n.settingsThemePicker)),
              RadioListTile<ThemeMode>(
                value: ThemeMode.system,
                title: Text(l10n.themeSystem),
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.light,
                title: Text(l10n.themeLight),
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.dark,
                title: Text(l10n.themeDark),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showFontPicker(
    BuildContext context,
    AppSettingsController settings,
  ) async {
    final l10n = context.l10n;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return RadioGroup<AppFontScale>(
          groupValue: settings.fontScale,
          onChanged: (value) {
            if (value == null) {
              return;
            }
            settings.setFontScale(value);
            Navigator.pop(sheetContext);
          },
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(title: Text(l10n.settingsFontPicker)),
              RadioListTile<AppFontScale>(
                value: AppFontScale.small,
                title: Text(l10n.fontSmall),
              ),
              RadioListTile<AppFontScale>(
                value: AppFontScale.medium,
                title: Text(l10n.fontMedium),
              ),
              RadioListTile<AppFontScale>(
                value: AppFontScale.large,
                title: Text(l10n.fontLarge),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CodeBadge extends StatelessWidget {
  const _CodeBadge({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        code,
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.25),
        ),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final Widget leading;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
