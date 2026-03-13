import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';
import '../services/pref_service.dart';
import '../utils/constants.dart';
import '../utils/localization.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _urlController = TextEditingController();
  final Telephony telephony = Telephony.instance;
  bool _hasPermissions = false;
  String _lang = 'en';
  List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    _lang = PrefService.getLanguage();
    _urlController.text = PrefService.getWebhookUrl() ?? '';
    _checkPermissions();
    _loadLogs();
  }

  void _loadLogs() {
    setState(() {
      _logs = PrefService.getLogs();
    });
  }

  Future<void> _checkPermissions() async {
    bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
    setState(() {
      _hasPermissions = permissionsGranted ?? false;
    });
  }

  void _saveUrl() {
    String url = _urlController.text.trim();
    if (url.isEmpty || (!url.startsWith('http://') && !url.startsWith('https://'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Translations.get('enterValidUrl', _lang))),
      );
      return;
    }

    PrefService.setWebhookUrl(url);
    setState(() {}); // trigger rebuild to show active status
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(Translations.get('urlSaved', _lang)), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isActive = _hasPermissions && _urlController.text.isNotEmpty;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.get('homeTitle', _lang)),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isActive ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                  border: Border.all(color: isActive ? Colors.green : Colors.red),
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                ),
                child: Row(
                  children: [
                    Icon(
                      isActive ? Icons.check_circle : Icons.error,
                      color: isActive ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        isActive 
                          ? Translations.get('statusActive', _lang) 
                          : Translations.get('statusInactive', _lang),
                        style: TextStyle(
                          color: isActive ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                Translations.get('webhookUrl', _lang),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _urlController,
                decoration: const InputDecoration(
                  hintText: 'https://...',
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveUrl,
                  child: Text(Translations.get('saveUrl', _lang)),
                ),
              ),
              if (!_hasPermissions) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  ),
                  child: Column(
                    children: [
                      Text(
                        Translations.get('permissionsRequired', _lang),
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _checkPermissions,
                        child: Text(Translations.get('grantPermissions', _lang)),
                      )
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Translations.get('logs', _lang),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _loadLogs,
                  )
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  ),
                  child: _logs.isEmpty 
                    ? Center(child: Text(Translations.get('emptyLogs', _lang), style: const TextStyle(color: AppColors.textMuted)))
                    : ListView.separated(
                        padding: const EdgeInsets.all(8),
                        itemCount: _logs.length,
                        separatorBuilder: (context, index) => const Divider(color: AppColors.background),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              _logs[index],
                              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                            ),
                          );
                        },
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
