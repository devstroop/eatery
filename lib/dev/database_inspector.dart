import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/eatery_core.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseInspectorPage extends ConsumerWidget {
  const DatabaseInspectorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.read(eateryStoreProvider);

    final tables = <String>[
      'product_category',
      'product',
      'customer',
      'orders',
      'order_product',
      'payment',
      'tax_slab',
      'dining_table_category',
      'dining_table',
      'company',
      'currency',
      'staff',
      'subscription',
      'auto_print',
      'kds_station',
      'compliance_report',
      'void_log_entry',
      'printer',
      'order_status_history',
      'modifier_group',
      'modifier',
      'product_modifier',
      'order_product_modifier',
      'discount',
      'order_discount',
      'shift',
      'time_entry',
      'business_hours',
      'holiday_hours',
      'expense_category',
      'expense',
      'inventory_item',
      'inventory_transaction',
      'loyalty_program',
      'loyalty_card',
      'loyalty_transaction',
      'op_log',
      'app_config',
    ];

    final rowCounts = <String, int>{};
    for (final table in tables) {
      try {
        final count = store.queryScalar('SELECT COUNT(*) FROM $table');
        rowCounts[table] = (count as int?) ?? 0;
      } catch (_) {
        rowCounts[table] = -1;
      }
    }

    final totalRows = rowCounts.values
        .where((c) => c > 0)
        .fold(0, (a, b) => a + b);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Inspector'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () => _exportJson(context, store, tables),
            tooltip: 'Export as JSON',
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            onPressed: () => _confirmClearAll(context, ref),
            tooltip: 'Clear All Data',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: AppColors.primary.withValues(alpha: 0.08),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.storage, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total rows: $totalRows across ${tables.length} tables',
                          style: AppTypography.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Store: ${store.version}',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.grey500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          for (final table in tables) ...[
            _TableRowTile(tableName: table, count: rowCounts[table] ?? 0),
            const Divider(height: 1),
          ],
        ],
      ),
    );
  }

  Future<void> _exportJson(
    BuildContext context,
    EateryStore store,
    List<String> tables,
  ) async {
    try {
      final data = <String, dynamic>{};
      for (final table in tables) {
        try {
          final rows = store.query('SELECT * FROM $table');
          data[table] = rows;
        } catch (_) {
          data[table] = [];
        }
      }
      final json = const JsonEncoder.withIndent('  ').convert(data);
      final dir = await getApplicationDocumentsDirectory();
      final file = File(
        '${dir.path}/eatery_export_${DateTime.now().millisecondsSinceEpoch}.json',
      );
      await file.writeAsString(json);

      if (!context.mounted) return;
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Eatery DB Export',
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _confirmClearAll(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
          'This will delete ALL data from every table. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final store = ref.read(eateryStoreProvider);
      _clearAllData(store, context);
    }
  }

  void _clearAllData(EateryStore store, BuildContext context) {
    final tables = [
      'op_log',
      'order_product_modifier',
      'order_product',
      'order_discount',
      'order_status_history',
      'payment',
      'orders',
      'product_modifier',
      'modifier',
      'modifier_group',
      'time_entry',
      'shift',
      'inventory_transaction',
      'inventory_item',
      'loyalty_transaction',
      'loyalty_card',
      'loyalty_program',
      'discount',
      'compliance_report',
      'void_log_entry',
      'expense',
      'expense_category',
      'business_hours',
      'holiday_hours',
      'dining_table',
      'dining_table_category',
      'customer',
      'staff',
      'product',
      'product_category',
      'tax_slab',
      'currency',
      'subscription',
      'company',
      'auto_print',
      'kds_station',
      'printer',
      'app_config',
    ];
    try {
      store.transaction(() {
        for (final table in tables) {
          store.execute('DELETE FROM $table');
        }
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('All data cleared')));
    } catch (e) {
      debugPrint('Clear all data failed: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Clear failed: $e')));
    }
  }
}

class _TableRowTile extends StatelessWidget {
  final String tableName;
  final int count;

  const _TableRowTile({required this.tableName, required this.count});

  @override
  Widget build(BuildContext context) {
    final color = count > 0
        ? AppColors.success
        : (count == 0 ? AppColors.grey400 : AppColors.grey200);
    final label = count > 0 ? '$count rows' : (count == 0 ? 'empty' : 'n/a');

    return ListTile(
      dense: true,
      leading: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
      title: Text(tableName, style: AppTypography.bodyMedium),
      trailing: Text(
        label,
        style: AppTypography.bodySmall.copyWith(color: color),
      ),
    );
  }
}
