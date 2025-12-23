import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/conversion_service.dart';
import '../services/currency_service.dart';
import '../services/history_service.dart';

class ConvertScreen extends StatefulWidget {
  const ConvertScreen({super.key});

  @override
  State<ConvertScreen> createState() => _ConvertScreenState();
}

class _ConvertScreenState extends State<ConvertScreen> {
  String _category = 'Length';
  String _fromUnit = 'm';
  String _toUnit = 'km';
  double _inputValue = 0.0;
  double _resultValue = 0.0;
  int _precision = 2;

  final TextEditingController _controller = TextEditingController();

  List<String> _units = [];

  @override
  void initState() {
    super.initState();
    _updateUnits();
  }

  void _updateUnits() {
    switch (_category) {
      case 'Length':
        _units = ['m', 'km', 'cm', 'mm', 'mi', 'yd', 'ft', 'in'];
        break;
      case 'Weight/Mass':
        _units = ['kg', 'g', 'mg', 'lb', 'oz'];
        break;
      case 'Temperature':
        _units = ['C', 'F', 'K'];
        break;
      case 'Area':
        _units = ['m²', 'km²', 'cm²', 'mm²', 'ft²', 'yd²', 'acre', 'ha'];
        break;
      case 'Volume':
        _units = ['L', 'mL', 'm³', 'ft³', 'in³', 'gal(US)', 'gal(UK)'];
        break;
      case 'Speed':
        _units = ['m/s', 'km/h', 'mph', 'kn'];
        break;
      case 'Time':
        _units = ['s', 'min', 'h', 'day', 'week', 'month', 'year'];
        break;
      case 'Currency':
        _units = Provider.of<CurrencyService>(context, listen: false).rates.keys.toList();
        break;
      case 'Energy':
        _units = ['J', 'kJ', 'cal', 'kcal', 'Wh', 'kWh'];
        break;
      case 'Pressure':
        _units = ['Pa', 'kPa', 'bar', 'atm', 'psi'];
        break;
      case 'Power':
        _units = ['W', 'kW', 'hp'];
        break;
      case 'Digital Storage':
        _units = ['B', 'KB', 'MB', 'GB', 'TB'];
        break;
      case 'Data Transfer Rate':
        _units = ['bps', 'Kbps', 'Mbps', 'Gbps'];
        break;
      case 'Electric Current':
        _units = ['A', 'mA', 'kA'];
        break;
      case 'Frequency':
        _units = ['Hz', 'kHz', 'MHz', 'GHz'];
        break;
      case 'Angle':
        _units = ['deg', 'rad', 'grad'];
        break;
      case 'Fuel Consumption':
        _units = ['L/100km', 'mpg(US)', 'mpg(UK)'];
        break;
      case 'Density':
        _units = ['kg/m³', 'g/cm³', 'lb/ft³'];
        break;
      case 'Force':
        _units = ['N', 'kN', 'lbf'];
        break;
      case 'Illuminance':
        _units = ['lx', 'fc'];
        break;
      default:
        _units = [];
    }

    if (!_units.contains(_fromUnit)) _fromUnit = _units.first;
    if (!_units.contains(_toUnit)) _toUnit = _units[1 % _units.length];
  }

  void _convert() {
    final conversionService = Provider.of<ConversionService>(context, listen: false);
    final currencyService = Provider.of<CurrencyService>(context, listen: false);

    double value = _inputValue;

    if (_category == 'Currency') {
      _resultValue = currencyService.convert(_fromUnit, _toUnit, value, precision: _precision);
    } else {
      _resultValue = conversionService.convert(_category, value, _fromUnit, _toUnit, precision: _precision);
    }

    // Save history
    Provider.of<HistoryService>(context, listen: false).addRecord({
      'date': DateTime.now().toIso8601String(),
      'category': _category,
      'input': _inputValue,
      'from': _fromUnit,
      'result': _resultValue,
      'to': _toUnit,
    });

    setState(() {});
  }

  void _swapUnits() {
    final temp = _fromUnit;
    _fromUnit = _toUnit;
    _toUnit = temp;
    _convert();
  }

  @override
  Widget build(BuildContext context) {
    _updateUnits();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Unit Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Category dropdown
            DropdownButton<String>(
              value: _category,
              items: [
                'Length','Weight/Mass','Temperature','Area','Volume','Speed','Time','Currency','Energy','Pressure','Power',
                'Digital Storage','Data Transfer Rate','Electric Current','Frequency','Angle','Fuel Consumption','Density','Force','Illuminance'
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (value) {
                setState(() {
                  _category = value!;
                  _updateUnits();
                  _convert();
                });
              },
            ),
            const SizedBox(height: 16),
            // Input field
            TextField(
              controller: _controller,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Enter value'),
              onChanged: (val) {
                setState(() {
                  _inputValue = double.tryParse(val) ?? 0.0;
                  _convert();
                });
              },
            ),
            const SizedBox(height: 16),
            // From/To dropdowns + Swap button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton<String>(
                  value: _fromUnit,
                  items: _units.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (val) {
                    setState(() {
                      _fromUnit = val!;
                      _convert();
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.swap_horiz),
                  onPressed: _swapUnits,
                ),
                DropdownButton<String>(
                  value: _toUnit,
                  items: _units.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (val) {
                    setState(() {
                      _toUnit = val!;
                      _convert();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Result
            Text(
              'Result: $_resultValue $_toUnit',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}