import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

class CurrencyService extends ChangeNotifier {
  Map<String, dynamic> rates = {};
  DateTime? lastUpdated;

  final String api = "https://open.er-api.com/v6/latest/USD";

  CurrencyService() {
    _loadLocalRates();
    fetchRates();
  }

  Future<void> _loadLocalRates() async {
    var box = await Hive.openBox('currencyBox');
    final data = box.get('rates');
    final time = box.get('time');

    if (data != null) {
      rates = Map<String, dynamic>.from(data);
      lastUpdated = DateTime.tryParse(time ?? "");
      notifyListeners();
    }
  }

  Future<void> fetchRates() async {
    try {
      final response = await http.get(Uri.parse(api));
      final json = jsonDecode(response.body);

      rates = json["rates"];
      lastUpdated = DateTime.now();

      var box = await Hive.openBox('currencyBox');
      box.put('rates', rates);
      box.put('time', lastUpdated.toString());

      notifyListeners();
    } catch (e) {
      print("Currency fetch error: $e");
    }
  }

  double convert(double value, String from, String to) {
    if (rates.isEmpty) return value;
    return value * (rates[to]! / rates[from]!);
  }

  String getCurrencyName(String code) {
    const names = {
      "USD": "US Dollar",
      "EUR": "Euro",
      "INR": "Indian Rupee",
      "GBP": "British Pound",
      "JPY": "Japanese Yen",
      "AUD": "Australian Dollar",
      "CAD": "Canadian Dollar",
      "CHF": "Swiss Franc",
    };

    return names[code] ?? code;
  }
}