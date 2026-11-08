# Temperature Converter

A clean Flutter app that converts temperatures between Celsius and Fahrenheit.

## Features

- Side-by-side temperature input and conversion type selector
- Convert button with results shown to 2 decimal places
- Validation for empty and non-numeric input
- Conversion history (in memory only, no database)
- Splash screen and Material 3 UI

## Screenshots

<p align="center">
  <img src="screenshots/converter-home.png" alt="Temperature converter showing 72 °F converted to 22.22 °C" width="320">
  &nbsp;&nbsp;
  <img src="screenshots/conversion-history.png" alt="Conversion history showing recent Fahrenheit-to-Celsius results" width="320">
</p>
<p align="center">
  <em>Converter</em>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <em>Conversion history</em>
</p>

## Formulas

- Celsius to Fahrenheit: F = (C × 9/5) + 32
- Fahrenheit to Celsius: C = (F − 32) × 5/9

## Tech

- Flutter, Dart
- State management: Provider

## Project structure

    lib/
      core/        app theme
      models/      ConversionType, ConversionRecord
      services/    TemperatureConverter (pure logic)
      providers/   ConverterProvider
      screens/     splash, converter, history
    test/          unit and widget tests

## Run

    flutter pub get
    flutter run

## Test

    flutter test