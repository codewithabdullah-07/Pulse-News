import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/article_model.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  static const _permissionPromptedKey = 'notification_permission_prompted';
  static const _breakingId = 1200;
  static const _dailyMorningId = 2201;
  static const _dailyEveningId = 2202;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  static const AndroidNotificationChannel _breakingChannel =
      AndroidNotificationChannel(
    'breaking_news',
    'Breaking News',
    description: 'Breaking and live Pulse News alerts',
    importance: Importance.max,
  );

  static const AndroidNotificationChannel _dailyChannel =
      AndroidNotificationChannel(
    'daily_news',
    'Daily News',
    description: 'Scheduled Pulse News digests',
    importance: Importance.high,
  );

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    tz.initializeTimeZones();

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _plugin.initialize(initializationSettings);

    final android = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await android?.createNotificationChannel(_breakingChannel);
    await android?.createNotificationChannel(_dailyChannel);

    _initialized = true;
  }

  Future<bool> ensurePermissionIfNeeded({required bool enabled}) async {
    await initialize();
    final prefs = await SharedPreferences.getInstance();
    final prompted = prefs.getBool(_permissionPromptedKey) ?? false;
    if (!enabled || prompted) {
      return await hasPermission();
    }

    final granted = await requestPermission();
    await prefs.setBool(_permissionPromptedKey, true);
    return granted;
  }

  Future<bool> requestPermission() async {
    await initialize();

    final android = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    final macos = _plugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>();

    final androidGranted = await android?.requestNotificationsPermission();
    final iosGranted = await ios?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        ) ??
        true;
    final macosGranted = await macos?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        ) ??
        true;

    return (androidGranted ?? true) && iosGranted && macosGranted;
  }

  Future<bool> hasPermission() async {
    await initialize();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    final androidEnabled = await android?.areNotificationsEnabled();
    return androidEnabled ?? true;
  }

  Future<void> cancelAll() async {
    await initialize();
    await _plugin.cancelAll();
  }

  Future<void> showBreakingNews(
    ArticleModel article,
  ) async {
    await initialize();

    final title = article.title ?? 'New article available';
    final body = article.description?.trim().isNotEmpty == true
        ? article.description!.trim()
        : article.source?.name ?? 'Tap to read the latest story.';

    await _plugin.show(
      _breakingId,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'breaking_news',
          'Breaking News',
          channelDescription: 'Breaking and live Pulse News alerts',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> scheduleDailyDigests(List<ArticleModel> articles) async {
    await initialize();
    await _plugin.cancel(_dailyMorningId);
    await _plugin.cancel(_dailyEveningId);

    final usable = articles
        .where((article) => (article.title ?? '').trim().isNotEmpty)
        .take(2)
        .toList();

    if (usable.isEmpty) {
      return;
    }

    await _scheduleDaily(
      id: _dailyMorningId,
      article: usable.first,
      hour: 9,
    );

    await _scheduleDaily(
      id: _dailyEveningId,
      article: usable.length > 1 ? usable[1] : usable.first,
      hour: 19,
    );
  }

  Future<void> _scheduleDaily({
    required int id,
    required ArticleModel article,
    required int hour,
  }) async {
    final scheduledAt = _nextInstanceOf(hour);
    final body = article.description?.trim().isNotEmpty == true
        ? article.description!.trim()
        : article.source?.name ?? 'Open Pulse News for details.';

    await _plugin.zonedSchedule(
      id,
      article.title ?? 'Pulse News update',
      body,
      scheduledAt,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_news',
          'Daily News',
          channelDescription: 'Scheduled Pulse News digests',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  tz.TZDateTime _nextInstanceOf(int hour) {
    final location = tz.local;
    final now = tz.TZDateTime.now(location);
    var scheduled = tz.TZDateTime(location, now.year, now.month, now.day, hour);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
