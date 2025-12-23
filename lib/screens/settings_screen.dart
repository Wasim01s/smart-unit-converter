import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/billing_service.dart';
import '../config/billing_config.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _adsEnabled = true;
  bool _gdprConsent = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _adsEnabled = prefs.getBool('adsEnabled') ?? true;
      _gdprConsent = prefs.getBool('gdprConsent') ?? false;
    });
  }

  Future<void> _toggleAds(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('adsEnabled', value);
    setState(() {
      _adsEnabled = value;
    });
  }

  Future<void> _toggleGDPR(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('gdprConsent', value);
    setState(() {
      _gdprConsent = value;
    });
  }

  void _restorePurchases() async {
    final restored = await BillingService.restorePurchases();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(restored ? 'Purchases restored!' : 'No purchases found')),
    );
    setState(() {});
  }

  void _subscribe(String sku) async {
    final success = await BillingService.purchaseSubscription(sku);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? 'Subscription successful!' : 'Subscription failed')),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Enable Ads'),
            value: _adsEnabled,
            onChanged: _toggleAds,
          ),
          SwitchListTile(
            title: const Text('GDPR Consent for Personalized Ads'),
            value: _gdprConsent,
            onChanged: _toggleGDPR,
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text('Restore Purchases'),
            onTap: _restorePurchases,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Subscribe Monthly (\$1.49)'),
            onTap: () => _subscribe(SKU_MONTHLY),
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Subscribe Yearly (\$9.99)'),
            onTap: () => _subscribe(SKU_YEARLY),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Privacy Policy'),
            onTap: () {
              // TODO: open assets/privacy_policy.html
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Terms & Conditions'),
            onTap: () {
              // TODO: open assets/terms_and_conditions.html
            },
          ),
        ],
      ),
    );
  }
}