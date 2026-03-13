import 'dart:convert';
import 'package:http/http.dart' as http;
import 'pref_service.dart';

class ApiService {
  static Future<void> forwardSms(String number, String message) async {
    final url = PrefService.getWebhookUrl();
    if (url == null || url.isEmpty) {
      PrefService.addLog("Forward failed: Webhook URL not set.");
      return;
    }

    try {
      final uri = Uri.parse(url);
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'timestamp': DateTime.now().toIso8601String(),
          'sender': number,
          'message': message,
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        PrefService.addLog("Successfully forwarded SMS from \$number");
      } else {
        PrefService.addLog("Error forwarding: \${response.statusCode}");
      }
    } catch (e) {
      PrefService.addLog("Network Error: \$e");
    }
  }
}
