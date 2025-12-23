import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/convert_screen.dart';
import 'screens/history_screen.dart';
import 'screens/themes_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/splash_screen.dart';

class Routes {
  static const String splash = '/';
  static const String home = '/home';
  static const String convert = '/convert';
  static const String history = '/history';
  static const String themes = '/themes';
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case convert:
        return MaterialPageRoute(builder: (_) => const ConvertScreen());
      case history:
        return MaterialPageRoute(builder: (_) => const HistoryScreen());
      case themes:
        return MaterialPageRoute(builder: (_) => const ThemesScreen());
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('No route defined for this screen')),
          ),
        );
    }
  }
}