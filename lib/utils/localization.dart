class Translations {
  static const Map<String, Map<String, String>> strings = {
    'en': {
      'languageSelection': 'Select Language',
      'next': 'Next',
      'finish': 'Finish',
      'tutorialStep1_title': 'Welcome',
      'tutorialStep1_desc': 'This application runs in the background and instantly forwards incoming SMS messages to your specified URL.',
      'tutorialStep2_title': 'How it Works?',
      'tutorialStep2_desc': 'Once you set a webhook URL and grant SMS permissions, the app listens in the background. As soon as an SMS arrives, its content is posted to your URL.',
      'tutorialStep3_title': 'Setup Webhook',
      'tutorialStep3_desc': 'You can enter your custom API endpoint URL on the next screen. Example: https://yourdomain.com/api/sms',
      'homeTitle': 'SMS Forwarder',
      'webhookUrl': 'Webhook URL',
      'saveUrl': 'Save URL',
      'urlSaved': 'Webhook URL saved successfully!',
      'enterValidUrl': 'Please enter a valid URL (http/https)',
      'statusActive': 'Active - Forwarding SMS',
      'statusInactive': 'Inactive - Please check permissions/URL',
      'permissionsRequired': 'SMS Permissions Required',
      'grantPermissions': 'Grant Permissions',
      'back': 'Back',
      'logs': 'Recent Activity',
      'emptyLogs': 'No recent activity.',
    },
    'tr': {
      'languageSelection': 'Dil Seçimi',
      'next': 'İleri',
      'finish': 'Bitir',
      'back': 'Geri',
      'tutorialStep1_title': 'Hoşgeldiniz',
      'tutorialStep1_desc': 'Bu uygulama arka planda çalışarak gelen SMS mesajlarını anlık olarak belirttiğiniz URL adresine iletir.',
      'tutorialStep2_title': 'Nasıl Çalışır?',
      'tutorialStep2_desc': 'Webhook URL\'sini ayarlayıp SMS izinlerini verdikten sonra uygulama arka planda dinler. Bir SMS geldiği anda içeriği URL\'nize gönderilir.',
      'tutorialStep3_title': 'Webhook Ayarı',
      'tutorialStep3_desc': 'Kendi API uç noktanızı(URL) bir sonraki ekranda girebilirsiniz. Örnek: https://domain.com/api/sms',
      'homeTitle': 'SMS Yönlendirici',
      'webhookUrl': 'Webhook URL',
      'saveUrl': 'URL Kaydet',
      'urlSaved': 'Webhook URL başarıyla kaydedildi!',
      'enterValidUrl': 'Lütfen geçerli bir URL girin (http/https)',
      'statusActive': 'Aktif - SMS Yönlendiriliyor',
      'statusInactive': 'Pasif - Lütfen izinleri ve URL\'yi kontrol edin',
      'permissionsRequired': 'SMS İzni Gerekiyor',
      'grantPermissions': 'İzin Ver',
      'logs': 'Son Aktiviteler',
      'emptyLogs': 'Henüz bir aktivite yok.',
    }
  };

  static String get(String key, String languageCode) {
    if (strings.containsKey(languageCode) && strings[languageCode]!.containsKey(key)) {
      return strings[languageCode]![key]!;
    }
    // Fallback logic
    return strings['en']?[key] ?? key;
  }
}
