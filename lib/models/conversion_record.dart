import 'conversion_type.dart';

class ConversionRecord {
  const ConversionRecord({
    required this.input,
    required this.output,
    required this.type,
    required this.time,
  });

  final double input;
  final double output;
  final ConversionType type;
  final DateTime time;
}