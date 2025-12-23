import 'package:flutter/material.dart';

class AdsService {
  static bool isPremium = false;

  static void initialize() {
    // Real ads code can be added when using Android Studio
  }

  static Widget banner() {
    if (isPremium) return const SizedBox();
    return Container(
      height: 50,
      color: Colors.grey.shade300,
      alignment: Alignment.center,
      child: const Text("Banner Ad Placeholder"),
    );
  }
}