import 'package:flutter/material.dart';
import '../services/pref_service.dart';
import '../utils/constants.dart';
import '../utils/localization.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String _selectedLang = 'tr';

  @override
  void initState() {
    super.initState();
    _selectedLang = PrefService.getLanguage();
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      PrefService.setTutorialSeen(true);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  Widget _buildLanguageSelection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.language, size: 80, color: AppColors.primary),
        const SizedBox(height: 32),
        Text(
          Translations.get('languageSelection', _selectedLang),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _langButton('tr', 'Türkçe'),
            const SizedBox(width: 16),
            _langButton('en', 'English'),
          ],
        ),
        const Spacer(),
        _bottomButton(),
      ],
    );
  }

  Widget _langButton(String code, String label) {
    final isSelected = _selectedLang == code;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedLang = code;
        });
        PrefService.setLanguage(code);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStep(String titleKey, String descKey, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: AppColors.primary),
          const SizedBox(height: 48),
          Text(
            Translations.get(titleKey, _selectedLang),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            Translations.get(descKey, _selectedLang),
            style: const TextStyle(fontSize: 16, color: AppColors.textMuted, height: 1.5),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          _bottomButton(),
        ],
      ),
    );
  }

  Widget _bottomButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _nextPage,
          child: Text(
            _currentPage == 3 
              ? Translations.get('finish', _selectedLang) 
              : Translations.get('next', _selectedLang),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(), // User must click "Next"
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          children: [
            _buildLanguageSelection(),
            _buildStep('tutorialStep1_title', 'tutorialStep1_desc', Icons.autorenew),
            _buildStep('tutorialStep2_title', 'tutorialStep2_desc', Icons.settings_applications),
            _buildStep('tutorialStep3_title', 'tutorialStep3_desc', Icons.link),
          ],
        ),
      ),
    );
  }
}
