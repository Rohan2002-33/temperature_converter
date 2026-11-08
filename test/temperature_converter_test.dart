import 'package:flutter_test/flutter_test.dart';
import 'package:temperature_converter/models/conversion_type.dart';
import 'package:temperature_converter/services/temperature_converter.dart';

void main() {
  group('convert', () {
    test('Celsius to Fahrenheit', () {
      const t = ConversionType.celsiusToFahrenheit;
      expect(TemperatureConverter.convert(0, t), 32);
      expect(TemperatureConverter.convert(100, t), 212);
      expect(TemperatureConverter.convert(-40, t), -40);
    });

    test('Fahrenheit to Celsius', () {
      const t = ConversionType.fahrenheitToCelsius;
      expect(TemperatureConverter.convert(32, t), 0);
      expect(TemperatureConverter.convert(212, t), 100);
      expect(
        TemperatureConverter.format(TemperatureConverter.convert(72, t)),
        '22.22',
      );
    });
  });

  group('validation', () {
    test('empty input is rejected', () {
      expect(TemperatureConverter.validateInput(''), isNotNull);
      expect(TemperatureConverter.validateInput('   '), isNotNull);
      expect(TemperatureConverter.validateInput(null), isNotNull);
    });

    test('non-numbers are rejected', () {
      for (final bad in ['abc', '1.2.3', '--5', '-', '.', '12a', 'NaN']) {
        expect(TemperatureConverter.validateInput(bad), isNotNull, reason: bad);
      }
    });

    test('numbers are accepted', () {
      for (final ok in ['0', '-5', '+5', '36.6', '.5', '5.', ' 42 ']) {
        expect(TemperatureConverter.validateInput(ok), isNull, reason: ok);
      }
    });
  });

  test('format uses 2 decimals and never -0.00', () {
    expect(TemperatureConverter.format(22.22222), '22.22');
    expect(TemperatureConverter.format(-0.001), '0.00');
  });
}