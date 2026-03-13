import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';
import 'package:http/http.dart' as http;

import 'pref_service.dart';

@pragma('vm:entry-point')
onBackgroundMessage(SmsMessage message) async {
  print("SMS_DEBUG: Background message received from ${message.address}");
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final url = prefs.getString('webhook_url');
  print("SMS_DEBUG: Webhook URL: $url");
  
  if (url != null && url.isNotEmpty) {
    try {
      final uri = Uri.parse(url);
      print("SMS_DEBUG: Posting to $url");
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'timestamp': DateTime.now().toIso8601String(),
          'sender': message.address ?? 'Unknown',
          'message': message.body ?? '',
          'background': true,
        }),
      );
      print("SMS_DEBUG: Post response: ${response.statusCode}");
      
      // Store log in preferences
      List<String> logs = prefs.getStringList('logs') ?? [];
      String logData = 'bg forwarded ${message.address} status: ${response.statusCode}';
      logs.insert(0, '${DateTime.now().toString()} - $logData');
      if (logs.length > 50) logs = logs.sublist(0, 50);
      await prefs.setStringList('logs', logs);
      print("SMS_DEBUG: Log saved");

    } catch (e) {
      print("SMS_DEBUG: Error in background: $e");
      List<String> logs = prefs.getStringList('logs') ?? [];
      String logData = 'bg fail ${message.address}: $e';
      logs.insert(0, '${DateTime.now().toString()} - $logData');
      if (logs.length > 50) logs = logs.sublist(0, 50);
      await prefs.setStringList('logs', logs);
    }
  } else {
    print("SMS_DEBUG: Webhook URL is empty, skipping forward.");
  }
}

class SmsService {
  static final Telephony telephony = Telephony.instance;

  static void onMessageHandler(SmsMessage message) async {
    // When the app is in the foreground
    final url = PrefService.getWebhookUrl();
    if (url != null && url.isNotEmpty) {
      try {
        final uri = Uri.parse(url);
        final response = await http.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'timestamp': DateTime.now().toIso8601String(),
            'sender': message.address ?? 'Unknown',
            'message': message.body ?? '',
            'background': false,
          }),
        );
        PrefService.addLog("fg forwarded ${message.address} status: ${response.statusCode}");
      } catch (e) {
        PrefService.addLog("fg fail ${message.address}: $e");
      }
    }
  }

  static Future<void> init() async {
    bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
    if (permissionsGranted != null && permissionsGranted) {
      telephony.listenIncomingSms(
        onNewMessage: onMessageHandler,
        onBackgroundMessage: onBackgroundMessage,
        listenInBackground: true,
      );
    }
  }
}
