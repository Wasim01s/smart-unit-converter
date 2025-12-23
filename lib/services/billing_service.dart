import 'package:flutter/material.dart';

class BillingService extends ChangeNotifier {
  bool isPremium = false;

  void buyPremium() {
    isPremium = true;
    notifyListeners();
  }
}