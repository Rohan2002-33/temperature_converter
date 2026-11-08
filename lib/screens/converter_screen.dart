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
    final textTheme = Theme.of(context).textTheme;
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
                    Text(
                      'Quick conversion',
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Enter a value, pick a type and tap Calculate.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: scheme.outline,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
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
                                validator: TemperatureConverter.validateInput,
                                decoration: InputDecoration(
                                  labelText: 'Degrees',
                                  hintText: 'Enter temperature',
                                  prefixIcon:
                                      const Icon(Icons.thermostat_rounded),
                                  suffixText: type.fromUnit,
                                ),
                              ),
                              const SizedBox(height: 16),
                              InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Type',
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<ConversionType>(
                                    value: type,
                                    isExpanded: true,
                                    borderRadius: BorderRadius.circular(14),
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                    ),
                                    items: ConversionType.values
                                        .map(
                                          (item) => DropdownMenuItem(
                                            value: item,
                                            child: Text(
                                              item.label,
                                              overflow: TextOverflow.ellipsis,
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
                              const SizedBox(height: 16),
                              _ResultPanel(result: provider.result),
                              const SizedBox(height: 20),
                              FilledButton.icon(
                                onPressed: _onCalculate,
                                icon: const Icon(Icons.calculate_rounded),
                                label: const Text('Calculate'),
                              ),
                              const SizedBox(height: 4),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: hasResult
            ? scheme.primaryContainer.withValues(alpha: 0.6)
            : const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: hasResult ? scheme.primary : scheme.outlineVariant,
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
              result ?? '—',
              key: ValueKey<String>(result ?? 'empty'),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: hasResult ? scheme.primary : scheme.outline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}