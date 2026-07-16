import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery_core/providers/order_provider.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditOrderPage extends ConsumerStatefulWidget {
  const EditOrderPage({super.key, required this.order});
  final Order order;

  @override
  ConsumerState<EditOrderPage> createState() => _EditOrderPageState();
}

class _EditOrderPageState extends ConsumerState<EditOrderPage> {
  late List<OrderProduct> _items;
  late List<TextEditingController> _qtyControllers;
  late OrderStatus _status;

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

    if (_status != widget.order.status) {
      final now = DateTime.now();
      await repo.saveOrder(
        widget.order.copyWith(status: _status, updatedAt: now),
      );
      await repo.recordStatusTransition(
        OrderStatusHistory(
          orderId: widget.order.id!,
          fromStatus: widget.order.status.id,
          toStatus: _status.id,
          changedAt: now,
        ),
      );
    }

    if (mounted) {
      ScaffoldMessenger.of(
        this.context,
      ).showSnackBar(const SnackBar(content: Text('Order updated')));
      Navigator.pop(this.context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final allowedTransitions = widget.order.status.allowedTransitions;
    final displayStatuses = [widget.order.status, ...allowedTransitions];

    return AppPageShell(
      title: 'Edit Order',
      color: AppColors.menuCategories,
      actions: [IconButton(icon: const Icon(Icons.save), onPressed: _save)],
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            Text(
              'Order ID: ${widget.order.id}',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.gapSm,
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _status.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _status.name,
                    style: TextStyle(
                      color: _status.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                DropdownButton<OrderStatus>(
                  value: _status,
                  hint: const Text('Change status'),
                  items: displayStatuses.map((s) {
                    return DropdownMenuItem(value: s, child: Text(s.name));
                  }).toList(),
                  onChanged: (v) {
                    if (v != null && v != widget.order.status) {
                      setState(() => _status = v);
                    }
                  },
                ),
              ],
            ),
            AppSpacing.gapSm,
            Text(
              'Customer: ${widget.order.customerPhone ?? 'N/A'}',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.gapSm,
            Text(
              'Order Date: ${widget.order.createdAt}',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.gapSm,
            Text(
              'Order Type: ${widget.order.type.name}',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.gapXl,
            Text(
              'Order Items',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.gapSm,
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
                        AppSpacing.gapMd,
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
