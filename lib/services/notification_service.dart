import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _morningEnabledKey = 'morning_notification_enabled';
  static const String _eveningEnabledKey = 'evening_notification_enabled';
  static const String _morningHourKey = 'morning_notification_hour';
  static const String _morningMinuteKey = 'morning_notification_minute';
  static const String _eveningHourKey = 'evening_notification_hour';
  static const String _eveningMinuteKey = 'evening_notification_minute';

  static const int _morningNotificationId = 1;
  static const int _eveningNotificationId = 2;

  static Future<void> initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(initSettings);
  }

  static Future<void> scheduleMorningReminder({
    required int hour,
    required int minute,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_morningEnabledKey, true);
    await prefs.setInt(_morningHourKey, hour);
    await prefs.setInt(_morningMinuteKey, minute);

    await _scheduleDaily(
      id: _morningNotificationId,
      title: 'أذكاري',
      body: 'حان وقت أذكار الصباح',
    );
  }

  static Future<void> scheduleEveningReminder({
    required int hour,
    required int minute,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_eveningEnabledKey, true);
    await prefs.setInt(_eveningHourKey, hour);
    await prefs.setInt(_eveningMinuteKey, minute);

    await _scheduleDaily(
      id: _eveningNotificationId,
      title: 'أذكاري',
      body: 'حان وقت أذكار المساء',
    );
  }

  static Future<void> cancelMorningReminder() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_morningEnabledKey, false);
    await _plugin.cancel(_morningNotificationId);
  }

  static Future<void> cancelEveningReminder() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_eveningEnabledKey, false);
    await _plugin.cancel(_eveningNotificationId);
  }

  static Future<bool> isMorningEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_morningEnabledKey) ?? false;
  }

  static Future<bool> isEveningEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_eveningEnabledKey) ?? false;
  }

  static Future<Map<String, int>> getMorningTime() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'hour': prefs.getInt(_morningHourKey) ?? 5,
      'minute': prefs.getInt(_morningMinuteKey) ?? 30,
    };
  }

  static Future<Map<String, int>> getEveningTime() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'hour': prefs.getInt(_eveningHourKey) ?? 16,
      'minute': prefs.getInt(_eveningMinuteKey) ?? 0,
    };
  }

  static Future<void> _scheduleDaily({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'adhkari_reminders',
      'تذكيرات الأذكار',
      channelDescription: 'تنبيهات لتذكيرك بأذكار الصباح والمساء',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.periodicallyShow(
      id,
      title,
      body,
      RepeatInterval.daily,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  static Future<void> restoreScheduledNotifications() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool(_morningEnabledKey) ?? false) {
      await scheduleMorningReminder(
        hour: prefs.getInt(_morningHourKey) ?? 5,
        minute: prefs.getInt(_morningMinuteKey) ?? 30,
      );
    }

    if (prefs.getBool(_eveningEnabledKey) ?? false) {
      await scheduleEveningReminder(
        hour: prefs.getInt(_eveningHourKey) ?? 16,
        minute: prefs.getInt(_eveningMinuteKey) ?? 0,
      );
    }
  }
}
