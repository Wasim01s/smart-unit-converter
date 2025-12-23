import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('hi')],
      path: 'l10n',
      fallbackLocale: const Locale('en'),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Unit Converter',
        theme: ThemeData(useMaterial3: true),
        home: const SplashScreen(),
      ),
    );
  }
}