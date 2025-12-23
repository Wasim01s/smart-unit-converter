import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/currency_service.dart';

class CurrencyDropdown extends StatelessWidget {
  final String selectedCurrency;
  final Function(String) onChanged;

  const CurrencyDropdown({
    super.key,
    required this.selectedCurrency,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final currencyService = Provider.of<CurrencyService>(context);

    final currencies = currencyService.rates.keys.toList()..sort();

    return DropdownButton<String>(
      value: selectedCurrency,
      items: currencies
          .map((code) => DropdownMenuItem(
                value: code,
                child: Text('$code - ${currencyService.getCurrencyName(code)}'),
              ))
          .toList(),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
      isExpanded: true,
    );
  }
}