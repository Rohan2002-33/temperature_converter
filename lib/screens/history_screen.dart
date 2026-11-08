import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/conversion_record.dart';
import '../providers/converter_provider.dart';
import '../services/temperature_converter.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  Future<void> _confirmClear(BuildContext context) async {
    final provider = context.read<ConverterProvider>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear history?'),
        content: const Text('All saved conversions will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) provider.clearHistory();
  }

  @override
  Widget build(BuildContext context) {
    final items = context.watch<ConverterProvider>().history;

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          if (items.isNotEmpty)
            IconButton(
              tooltip: 'Clear history',
              icon: const Icon(Icons.delete_outline_rounded),
              onPressed: () => _confirmClear(context),
            ),
        ],
      ),
      body: items.isEmpty
          ? const _EmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, index) => _HistoryTile(record: items[index]),
            ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.record});

  final ConversionRecord record;

  static String _timeLabel(DateTime time) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(time.hour)}:${two(time.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final type = record.type;

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        leading: CircleAvatar(
          backgroundColor: scheme.primaryContainer,
          foregroundColor: scheme.onPrimaryContainer,
          child: const Icon(Icons.swap_horiz_rounded),
        ),
        title: Text(
          '${TemperatureConverter.format(record.input)}${type.fromUnit}'
          '  →  '
          '${TemperatureConverter.format(record.output)}${type.toUnit}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(type.label),
        trailing: Text(
          _timeLabel(record.time),
          style: TextStyle(color: scheme.outline),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history_rounded, size: 64, color: scheme.outlineVariant),
            const SizedBox(height: 16),
            Text(
              'No conversions yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              'Your recent results will show up here.',
              style: TextStyle(color: scheme.outline),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}