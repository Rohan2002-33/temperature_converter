import '../models/conversion_type.dart';

class TemperatureConverter {
  TemperatureConverter._();

  static final RegExp _numberPattern = RegExp(r'^[+-]?(\d+\.?\d*|\.\d+)$');

  /// F = (C × 9/5) + 32   |   C = (F - 32) × 5/9
  static double convert(double value, ConversionType type) {
    return switch (type) {
      ConversionType.celsiusToFahrenheit => (value * 9 / 5) + 32,
      ConversionType.fahrenheitToCelsius => (value - 32) * 5 / 9,
    };
  }

  /// Returns null when [raw] is not a valid number.
  static double? parse(String raw) {
    final text = raw.trim();
    if (!_numberPattern.hasMatch(text)) return null;
    final value = double.tryParse(text);
    if (value == null || !value.isFinite) return null;
    return value;
  }

  /// Returns an error message, or null when input is valid.
  static String? validateInput(String? raw) {
    final text = (raw ?? '').trim();
    if (text.isEmpty) return 'Please enter a temperature value.';
    if (parse(text) == null) return 'Please enter a valid number.';
    return null;
  }

  /// Up to 2 decimal places. Avoids "-0.00".
  static String format(double value) {
    final fixed = value.toStringAsFixed(2);
    return fixed == '-0.00' ? '0.00' : fixed;
  }
}