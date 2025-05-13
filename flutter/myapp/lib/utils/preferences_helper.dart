import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  static const String _notificationsKey = 'notifications_on';

  // ✅ Check if notifications are enabled
  static Future<bool> isNotificationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsKey) ?? true;
  }

  // ✅ Set notifications on/off
  static Future<void> setNotificationEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, value);
  }
}
