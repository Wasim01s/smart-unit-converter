import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/ads_service.dart';
import 'dart:math';
import '../services/billing_service.dart';
import 'package:hive/hive.dart';

class ThemesScreen extends StatefulWidget {
  const ThemesScreen({super.key});

  @override
  State<ThemesScreen> createState() => _ThemesScreenState();
}

class _ThemesScreenState extends State<ThemesScreen> {
  late Box _themeBox;
  final List<Map<String, dynamic>> _themes = [
    {'name': 'Light', 'type': 'free', 'color': Colors.white},
    {'name': 'Dark', 'type': 'free', 'color': Colors.black},
    {'name': 'Ocean', 'type': 'rewarded', 'color': Colors.blue},
    {'name': 'Forest', 'type': 'rewarded', 'color': Colors.green},
    {'name': 'Sunset', 'type': 'rewarded', 'color': Colors.orange},
    {'name': 'Purple', 'type': 'rewarded', 'color': Colors.purple},
    {'name': 'Gold', 'type': 'subscription', 'color': Colors.amber},
    {'name': 'Silver', 'type': 'subscription', 'color': Colors.grey},
    {'name': 'Rose', 'type': 'subscription', 'color': Colors.pink},
    {'name': 'Cyan', 'type': 'subscription', 'color': Colors.cyan},
  ];

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    _themeBox = await Hive.openBox('themesBox');
    setState(() {});
  }

  bool _isUnlocked(Map<String, dynamic> theme) {
    if (theme['type'] == 'free') return true;
    return _themeBox.get(theme['name'], defaultValue: false);
  }

  Future<void> _unlockTheme(Map<String, dynamic> theme) async {
    if (theme['type'] == 'rewarded') {
      // Show rewarded ad
      await AdsService.showRewardedAd();
      _themeBox.put(theme['name'], true);
    } else if (theme['type'] == 'subscription') {
      final isPremium = await BillingService.checkPremiumStatus();
      if (isPremium) {
        _themeBox.put(theme['name'], true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Subscription required to unlock this theme')),
        );
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_themeBox == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Themes'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _themes.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.0,
        ),
        itemBuilder: (context, index) {
          final theme = _themes[index];
          final unlocked = _isUnlocked(theme);

          return GestureDetector(
            onTap: unlocked ? null : () => _unlockTheme(theme),
            child: Container(
              decoration: BoxDecoration(
                color: theme['color'],
                borderRadius: BorderRadius.circular(16),
                border: unlocked
                    ? Border.all(color: Colors.green, width: 3)
                    : Border.all(color: Colors.redAccent, width: 2),
              ),
              child: Center(
                child: Text(
                  theme['name'],
                  style: TextStyle(
                    color: unlocked ? Colors.white : Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}