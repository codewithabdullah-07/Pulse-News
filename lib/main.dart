import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pulse_news/l10n/app_localizations.dart';

import 'models/article_model.dart';
import 'screens/splash_screen.dart';
import 'services/notification_service.dart';
import 'services/supabase_bootstrap.dart';
import 'theme/app_settings_controller.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await SupabaseBootstrap.initialize();

  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(ArticleModelAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(SourceModelAdapter());
  }
  if (!Hive.isBoxOpen('bookmarks')) {
    await Hive.openBox<ArticleModel>('bookmarks');
  }

  await SystemChrome.setPreferredOrientations(const [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final settings = await AppSettingsController.load();
  await NotificationService.instance.initialize();
  await NotificationService.instance.ensurePermissionIfNeeded(
    enabled: settings.notificationsEnabled,
  );

  runApp(
    ProviderScope(
      child: PulseNewsApp(settings: settings),
    ),
  );
}

class PulseNewsApp extends StatelessWidget {
  const PulseNewsApp({
    super.key,
    required this.settings,
    this.home,
  });

  final AppSettingsController settings;
  final Widget? home;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settings,
      builder: (context, _) {
        return AppSettingsScope(
          controller: settings,
          child: MaterialApp(
            title: 'Pulse News',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settings.themeMode,
            locale: settings.locale,
            supportedLocales: AppSettingsController.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              if (locale == null) {
                return const Locale('en');
              }
              return supportedLocales.firstWhere(
                (supported) => supported.languageCode == locale.languageCode,
                orElse: () => const Locale('en'),
              );
            },
            builder: (context, child) {
              final mediaQuery = MediaQuery.of(context);
              final isRtl = AppSettingsScope.of(context).isRtl;

              final brightness = Theme.of(context).brightness;
              SystemChrome.setSystemUIOverlayStyle(
                brightness == Brightness.dark
                    ? SystemUiOverlayStyle.light
                    : SystemUiOverlayStyle.dark,
              );

              return Directionality(
                textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                child: MediaQuery(
                  data: mediaQuery.copyWith(
                    textScaler: TextScaler.linear(settings.textScaleFactor),
                  ),
                  child: child ?? const SizedBox.shrink(),
                ),
              );
            },
            home: home ?? const SplashScreen(),
          ),
        );
      },
    );
  }
}
