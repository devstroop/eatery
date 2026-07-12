import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery/data/database/eatery_database.dart';
import 'package:eatery/presentation/providers/database_provider.dart';

/// Debug tool to inspect Hive database contents at runtime.
/// Only visible in debug mode from the Settings > Developer menu.
class DatabaseInspector extends ConsumerWidget {
  const DatabaseInspector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.read(appDatabaseProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('DB Inspector')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _BoxTile('Company', db.companyBox.length),
          _BoxTile('Products', db.productBox.length),
          _BoxTile('Product Categories', db.productCategoryBox.length),
          _BoxTile('Orders', db.orderBox.length),
          _BoxTile('Order Products', db.orderProductBox.length),
          _BoxTile('Customers', db.customerBox.length),
          _BoxTile('Payments', db.paymentBox.length),
          _BoxTile('Dining Tables', db.diningTableBox.length),
          _BoxTile('Dining Table Categories', db.diningTableCategoryBox.length),
          _BoxTile('Tax Slabs', db.taxSlabBox.length),
          _BoxTile('Staff', db.staffBox.length),
          _BoxTile('Subscriptions', db.subscriptionBox.length),
          _BoxTile('Currencies', db.currencyBox.length),
          _BoxTile('Printers', db.printerBox.length),
          const SizedBox(height: 32),
          TextButton.icon(
            onPressed: () => _clearAllData(context, db),
            icon: const Icon(Icons.warning_amber_rounded, color: Colors.red),
            label: const Text(
              'Clear All Data',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _clearAllData(BuildContext context, EateryDatabase db) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
          'This will permanently delete all data. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Delete Everything',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await db.deleteAll();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All data cleared. Restart app.')),
        );
      }
    }
  }
}

class _BoxTile extends StatelessWidget {
  final String label;
  final int count;
  const _BoxTile(this.label, this.count);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: Text(
          '$count items',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
