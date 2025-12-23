import 'dart:math';

class ConversionService {
  // LENGTH
  static double convertLength(double value, String from, String to) {
    const meter = {
      "m": 1.0,
      "km": 1000.0,
      "cm": 0.01,
      "mm": 0.001,
      "ft": 0.3048,
      "in": 0.0254,
      "mile": 1609.34,
    };

    return value * (meter[from]! / meter[to]!);
  }

  // WEIGHT
  static double convertWeight(double value, String from, String to) {
    const gram = {
      "g": 1.0,
      "kg": 1000.0,
      "mg": 0.001,
      "lb": 453.592,
      "oz": 28.3495,
      "ton": 1e6,
    };

    return value * (gram[from]! / gram[to]!);
  }

  // TEMPERATURE
  static double convertTemperature(double value, String from, String to) {
    if (from == to) return value;

    double celsius;

    // Step 1 => Convert to Celsius
    if (from == "C") celsius = value;
    else if (from == "F") celsius = (value - 32) * 5 / 9;
    else celsius = value + 273.15; // K to C

    // Step 2 => Convert to target
    if (to == "C") return celsius;
    if (to == "F") return celsius * 9 / 5 + 32;
    return celsius - 273.15; // C to K
  }

  // AREA
  static double convertArea(double value, String from, String to) {
    const sqMeter = {
      "m²": 1.0,
      "cm²": 0.0001,
      "km²": 1e6,
      "acre": 4046.86,
      "ft²": 0.092903,
    };

    return value * (sqMeter[from]! / sqMeter[to]!);
  }

  // VOLUME
  static double convertVolume(double value, String from, String to) {
    const liter = {
      "L": 1.0,
      "mL": 0.001,
      "gallon": 3.78541,
      "cm³": 0.001,
    };

    return value * (liter[from]! / liter[to]!);
  }
}