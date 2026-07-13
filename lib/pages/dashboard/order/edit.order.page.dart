import 'package:eatery_core/widgets/app_page_shell.dart';
import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery_core/providers/order_provider.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EditOrderPage extends ConsumerStatefulWidget {
  const EditOrderPage({super.key, required this.order});
  final Order order;

  @override
  ConsumerState<EditOrderPage> createState() => _EditOrderPageState();
}

class _EditOrderPageState extends ConsumerState<EditOrderPage> {
  late List<OrderProduct> _items;
  late List<TextEditingController> _qtyControllers;
  late String _status;

  @override
  void initState() {
    super.initState();
    _items = ref
        .read(orderRepositoryProvider)
        .getOrderProducts(widget.order.id ?? 0);
    _qtyControllers = _items
        .map((item) => TextEditingController(text: item.quantity.toString()))
        .toList();
    _status = widget.order.status;
  }

  @override
  void dispose() {
    for (final c in _qtyControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final repo = ref.read(orderRepositoryProvider);

    // Update quantities
    for (var i = 0; i < _items.length; i++) {
      final qty = int.tryParse(_qtyControllers[i].text) ?? _items[i].quantity;
      if (qty != _items[i].quantity) {
        final updated = _items[i].copyWith(
          quantity: qty,
          subTotal: _items[i].price * qty,
          total: _items[i].price * qty,
        );
        await repo.saveOrderProduct(updated);
      }
    }

    // Update order status
    if (_status != widget.order.status) {
      final now = DateTime.now();
      await repo.saveOrder(widget.order.copyWith(
        status: _status,
        updatedAt: now,
      ));
    }

    if (mounted) {
      ScaffoldMessenger.of(this.context).showSnackBar(
        const SnackBar(content: Text('Order updated')),
      );
      Navigator.pop(this.context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Edit Order',
      color: AppColors.menuCategories,
      actions: [
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: _save,
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            Text(
              'Order ID: ${widget.order.id}',
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _status,
              decoration: const InputDecoration(
                labelText: 'Order Status',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'active', child: Text('Active')),
                DropdownMenuItem(value: 'completed', child: Text('Completed')),
                DropdownMenuItem(value: 'voided', child: Text('Voided')),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _status = v);
              },
            ),
            const SizedBox(height: 10),
            Text(
              'Customer: ${widget.order.customerPhone ?? 'N/A'}',
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Order Date: ${widget.order.createdAt}',
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Order Type: ${widget.order.type.name}',
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Order Items',
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (_items.isEmpty)
              const Text('No items found')
            else
              for (var i = 0; i < _items.length; i++) ...[
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _items[i].productName,
                                style: AppTypography.titleMedium,
                              ),
                              Text(
                                'Price: ${_items[i].price}',
                                style: AppTypography.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: TextField(
                            controller: _qtyControllers[i],
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Qty',
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${_items[i].total}',
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
          ],
        ),
      ),
    );
  }
}
