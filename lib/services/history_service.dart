import 'package:hive/hive.dart';

class HistoryService {
  static Future<void> saveHistory(Map<String, dynamic> item) async {
    final box = await Hive.openBox("historyBox");
    box.add(item);
  }

  static Future<List<Map>> getHistory() async {
    final box = await Hive.openBox("historyBox");
    return box.values.map((e) => Map.from(e)).toList();
  }

  static Future<void> clearHistory() async {
    final box = await Hive.openBox("historyBox");
    await box.clear();
  }
}