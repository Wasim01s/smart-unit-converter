import 'package:flutter/material.dart';

class ConversionCard extends StatelessWidget {
  final String category;
  final double input;
  final String fromUnit;
  final double result;
  final String toUnit;
  final VoidCallback? onCopy;
  final VoidCallback? onShare;

  const ConversionCard({
    super.key,
    required this.category,
    required this.input,
    required this.fromUnit,
    required this.result,
    required this.toUnit,
    this.onCopy,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              '$input $fromUnit → $result $toUnit',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: onCopy,
                  tooltip: 'Copy result',
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: onShare,
                  tooltip: 'Share result',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}