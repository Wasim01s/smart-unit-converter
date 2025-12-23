import 'package:flutter/material.dart';
import 'app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'services/conversion_service.dart';
import 'services/currency_service.dart';
import 'services/history_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await ConversionService.init();
  await CurrencyService.init();
  final historyService = HistoryService();
  await historyService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConversionService()),
        ChangeNotifierProvider(create: (_) => CurrencyService()),
        ChangeNotifierProvider(create: (_) => historyService),
      ],
      child: const MyApp(),
    ),
  );
}