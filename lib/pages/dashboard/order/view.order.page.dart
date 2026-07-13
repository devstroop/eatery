import 'package:eatery_core/widgets/app_page_shell.dart';
import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery_core/providers/order_provider.dart';
import 'package:eatery_core/providers/company_provider.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ViewOrderPage extends ConsumerStatefulWidget {
  const ViewOrderPage({Key? key, required this.order}) : super(key: key);
  final Order order;

  @override
  ConsumerState<ViewOrderPage> createState() => _ViewOrderPageState();
}

class _ViewOrderPageState extends ConsumerState<ViewOrderPage> {
  late List<OrderProduct> _items;

  @override
  void initState() {
    super.initState();
    _items = ref
        .read(orderRepositoryProvider)
        .getOrderProducts(widget.order.id ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    final customer = ref
        .read(customerRepositoryProvider)
        .getCustomerByPhone(widget.order.customerPhone ?? '');
    final diningTable = widget.order.id != null
        ? ref.read(diningTableRepositoryProvider)
            .getTableByOrderId(widget.order.id!)
        : null;
    final currencySymbol =
        ref.read(companyProvider.notifier).currency?.symbol ?? '';

    return AppPageShell(
      title: 'View Order',
      color: AppColors.menuCategories,
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            GoRouter.of(context).pushNamed('editOrder', extra: widget.order);
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            _label('Order ID: ${widget.order.id}'),
            _label('Table: ${diningTable?.name ?? 'N/A'}'),
            _label('Customer: ${customer?.name ?? 'NA'}'),
            _label('Order Status: ${widget.order.status}'),
            _label(
              'Payment Status: ${widget.order.grandTotal > (widget.order.paidTotal ?? 0) ? 'Not Paid' : 'Paid'}',
            ),
            _label('Order Type: ${widget.order.type.name}'),
            _label(
              'Order Date: ${DateFormat.yMMMd().add_jm().format(widget.order.createdAt)}',
            ),
            _label('Total: $currencySymbol${widget.order.grandTotal}'),
            const SizedBox(height: 20),
            Text(
              'Order Items',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            if (_items.isEmpty)
              _label('No items found')
            else
              ..._items.map(
                (item) => Card(
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
                                item.productName,
                                style: AppTypography.titleMedium,
                              ),
                              if (item.stationName != null)
                                CaptionLabel(label: item.stationName!),
                            ],
                          ),
                        ),
                        Text('${item.quantity} x $currencySymbol${item.price}'),
                        const SizedBox(width: 12),
                        Text(
                          '$currencySymbol${item.total}',
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
