import 'package:flutter/foundation.dart';

import '../models/conversion_record.dart';
import '../models/conversion_type.dart';
import '../services/temperature_converter.dart';

class ConverterProvider extends ChangeNotifier {
  static const int _maxHistory = 50;

  ConversionType _type = ConversionType.fahrenheitToCelsius;
  String? _result;
  final List<ConversionRecord> _history = [];

  ConversionType get type => _type;
  String? get result => _result;
  List<ConversionRecord> get history => List.unmodifiable(_history);

  void setType(ConversionType value) {
    if (value == _type) return;
    _type = value;
    _result = null;
    notifyListeners();
  }

  void calculate(double input) {
    final output = TemperatureConverter.convert(input, _type);
    _result = '${TemperatureConverter.format(output)} ${_type.toUnit}';

    _history.insert(
      0,
      ConversionRecord(
        input: input,
        output: output,
        type: _type,
        time: DateTime.now(),
      ),
    );
    if (_history.length > _maxHistory) _history.removeLast();

    notifyListeners();
  }

  void clearResult() {
    if (_result == null) return;
    _result = null;
    notifyListeners();
  }

  void clearHistory() {
    if (_history.isEmpty) return;
    _history.clear();
    notifyListeners();
  }
}