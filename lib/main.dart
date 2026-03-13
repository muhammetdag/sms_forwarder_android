import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'services/pref_service.dart';
import 'services/sms_service.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefService.init();
  await SmsService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasSeenTutorial = PrefService.getTutorialSeen();

    return MaterialApp(
      title: 'SMS Forwarder',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: hasSeenTutorial ? const HomeScreen() : const OnboardingScreen(),
    );
  }
}
