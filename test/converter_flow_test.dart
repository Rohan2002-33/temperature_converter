import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:temperature_converter/app.dart';
import 'package:temperature_converter/models/conversion_type.dart';
import 'package:temperature_converter/providers/converter_provider.dart';

Future<void> openConverter(WidgetTester tester) async {
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (_) => ConverterProvider(),
      child: const TemperatureConverterApp(),
    ),
  );
  await tester.pump(const Duration(seconds: 2));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows error when field is empty', (tester) async {
    await openConverter(tester);

    await tester.tap(find.text('Calculate'));
    await tester.pump();

    expect(find.text('Please enter a temperature value.'), findsOneWidget);
  });

  testWidgets('shows error for invalid number', (tester) async {
    await openConverter(tester);

    await tester.enterText(find.byType(TextFormField), 'abc');
    await tester.tap(find.text('Calculate'));
    await tester.pump();

    expect(find.text('Please enter a valid number.'), findsOneWidget);
  });

  testWidgets('converts Celsius to Fahrenheit', (tester) async {
    await openConverter(tester);

    await tester.enterText(find.byType(TextFormField), '100');
    await tester.tap(find.text('Calculate'));
    await tester.pumpAndSettle();

    expect(find.text('212.00 °F'), findsOneWidget);
  });

  testWidgets('converts Fahrenheit to Celsius', (tester) async {
    await openConverter(tester);

    await tester.tap(find.byType(DropdownButton<ConversionType>));
    await tester.pumpAndSettle();
    await tester.tap(find.text(ConversionType.fahrenheitToCelsius.label).last);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), '212');
    await tester.tap(find.text('Calculate'));
    await tester.pumpAndSettle();

    expect(find.text('100.00 °C'), findsOneWidget);
  });
}