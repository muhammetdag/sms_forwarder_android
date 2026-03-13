import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setLanguage(String code) async {
    await prefs.setString('language', code);
  }

  static String getLanguage() {
    return prefs.getString('language') ?? 'en'; // default en
  }

  static Future<void> setTutorialSeen(bool seen) async {
    await prefs.setBool('tutorial_seen', seen);
  }

  static bool getTutorialSeen() {
    return prefs.getBool('tutorial_seen') ?? false;
  }

  static Future<void> setWebhookUrl(String url) async {
    await prefs.setString('webhook_url', url);
  }

  static String? getWebhookUrl() {
    return prefs.getString('webhook_url');
  }

  static Future<void> addLog(String log) async {
    List<String> logs = prefs.getStringList('logs') ?? [];
    logs.insert(0, "${DateTime.now().toString()} - $log");
    // Keep max 50 logs
    if (logs.length > 50) logs = logs.sublist(0, 50);
    await prefs.setStringList('logs', logs);
  }

  static List<String> getLogs() {
    return prefs.getStringList('logs') ?? [];
  }
}
