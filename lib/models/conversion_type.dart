enum ConversionType {
  celsiusToFahrenheit('Celsius to Fahrenheit (°C → °F)', '°C', '°F'),
  fahrenheitToCelsius('Fahrenheit to Celsius (°F → °C)', '°F', '°C');

  const ConversionType(this.label, this.fromUnit, this.toUnit);

  final String label;
  final String fromUnit;
  final String toUnit;
}