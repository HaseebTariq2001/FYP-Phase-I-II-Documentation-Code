import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // ✅ Call this once in main.dart
  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);

    // ✅ Initialize timezone
    tz.initializeTimeZones();
  }

  // ✅ Show notification instantly (optional, for testing)
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'activity_reminder_channel',
      'Activity Reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(id, title, body, platformDetails);
  }

  // ✅ Schedule reminder after 3 hours
  static Future<void> scheduleActivityReminder({
    required int lessonIndex,
  }) async {
    final scheduledDate = tz.TZDateTime.now(tz.local).add(const Duration(hours: 3));

    await _notificationsPlugin.zonedSchedule(
      lessonIndex,         // ✅ unique ID per lesson
      "Time to Play! 🎮",
      "You’ve completed your lesson! Open the app and try the activity ⭐",
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'activity_reminder_channel',
          'Activity Reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // ✅ Cancel reminder if child opens activity
  static Future<void> cancelReminder(int lessonIndex) async {
    await _notificationsPlugin.cancel(lessonIndex);
  }
}
