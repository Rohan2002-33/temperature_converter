import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/conversion_type.dart';
import '../providers/converter_provider.dart';
import '../services/temperature_converter.dart';
import 'history_screen.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onCalculate() {
    FocusScope.of(context).unfocus();
    final provider = context.read<ConverterProvider>();

    if (!(_formKey.currentState?.validate() ?? false)) {
      provider.clearResult();
      return;
    }

    final value = TemperatureConverter.parse(_controller.text);
    if (value == null) return;
    provider.calculate(value);
  }

  void _onReset() {
    FocusScope.of(context).unfocus();
    _controller.clear();
    _formKey.currentState?.reset();
    context.read<ConverterProvider>().clearResult();
  }

  void _openHistory() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const HistoryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ConverterProvider>();
    final type = provider.type;
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Temperature Converter'),
          actions: [
            IconButton(
              tooltip: 'History',
              icon: const Icon(Icons.history_rounded),
              onPressed: _openHistory,
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _controller,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                        decimal: true,
                                        signed: true,
                                      ),
                                      textInputAction: TextInputAction.done,
                                      onFieldSubmitted: (_) => _onCalculate(),
                                      onChanged: (_) => context
                                          .read<ConverterProvider>()
                                          .clearResult(),
                                      validator:
                                          TemperatureConverter.validateInput,
                                      decoration: InputDecoration(
                                        labelText: 'Degrees',
                                        hintText: 'Enter temperature',
                                        filled: false,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: scheme.outlineVariant,
                                          ),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: scheme.outlineVariant,
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: scheme.primary,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: InputDecorator(
                                      decoration: InputDecoration(
                                        labelText: 'Type',
                                        filled: false,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 4,
                                        ),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: scheme.outlineVariant,
                                          ),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: scheme.outlineVariant,
                                          ),
                                        ),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<ConversionType>(
                                          value: type,
                                          isExpanded: true,
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          icon: const Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                          ),
                                          items: ConversionType.values
                                              .map(
                                                (item) => DropdownMenuItem(
                                                  value: item,
                                                  child: Text(
                                                    item.fromUnit == '°F'
                                                        ? 'Fahrenheit'
                                                        : 'Celsius',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (value) {
                                            if (value != null) {
                                              context
                                                  .read<ConverterProvider>()
                                                  .setType(value);
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _ResultPanel(result: provider.result),
                              const SizedBox(height: 16),
                              FilledButton(
                                onPressed: _onCalculate,
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFF087FF5),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Convert'),
                              ),
                              const SizedBox(height: 2),
                              TextButton(
                                onPressed: _onReset,
                                child: const Text('Reset'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultPanel extends StatelessWidget {
  const _ResultPanel({required this.result});

  final String? result;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hasResult = result != null;

    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: hasResult ? scheme.primary : scheme.outlineVariant,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Result',
            style: TextStyle(fontSize: 12, color: scheme.outline),
          ),
          const SizedBox(height: 4),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              result ?? '',
              key: ValueKey<String>(result ?? 'empty'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: scheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}