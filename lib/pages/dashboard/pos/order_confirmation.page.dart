import 'package:eatery_core/theme/app_typography.dart';
import 'package:intl/intl.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/providers/order_provider.dart';
import 'package:eatery_core/providers/company_provider.dart';
import 'package:eatery_core/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OrderConfirmationPage extends ConsumerStatefulWidget {
  const OrderConfirmationPage({Key? key, required this.order})
    : super(key: key);
  final Order order;

  @override
  ConsumerState<OrderConfirmationPage> createState() =>
      _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends ConsumerState<OrderConfirmationPage> {
  late List<OrderProduct> _items;
  final GlobalKey genKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _items = ref
        .read(orderRepositoryProvider)
        .getOrderProducts(widget.order.id ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    final currencySymbol =
        ref.read(companyProvider.notifier).currency?.symbol ?? '';
    final customer = ref
        .read(customerRepositoryProvider)
        .getCustomerByPhone(widget.order.customerPhone ?? '');

    return Scaffold(
      backgroundColor: AppColors.grey200,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Receipt Preview',
                  style: AppTypography.headlineSmall,
                ),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Customer copy',
                  style: AppTypography.bodyLarge,
                ),
              ],
            ),
            const SizedBox(height: 24),
            RepaintBoundary(
              key: genKey,
              child: Container(
                color: AppColors.white,
                margin: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 12),
                    if (customer != null) ...[
                      Text(
                        customer.name ?? 'Unnamed',
                        style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        customer.phone,
                        style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      'Order #${widget.order.id}',
                      style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      DateFormat('dd MMM yyyy hh:mm a')
                          .format(widget.order.createdAt),
                      style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 12),
                    Divider(color: AppColors.white900),
                    const SizedBox(height: 12),
                    ..._items.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.productName,
                              style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ),
                          Text(
                            '${item.quantity} x $currencySymbol${item.price}',
                            style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$currencySymbol${item.total}',
                            style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )),
                    const SizedBox(height: 12),
                    Divider(color: AppColors.white900),
                    const SizedBox(height: 8),
                    _totalRow('Sub Total', '$currencySymbol${widget.order.subTotal}'),
                    if (widget.order.discountTotal > 0)
                      _totalRow('Discount', '-$currencySymbol${widget.order.discountTotal}'),
                    _totalRow('Tax', '$currencySymbol${widget.order.taxTotal}'),
                    if (widget.order.roundOff != 0)
                      _totalRow('Round Off', '$currencySymbol${widget.order.roundOff}'),
                    _totalRow('Grand Total', '$currencySymbol${widget.order.grandTotal}', bold: true),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.white,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 1,
              child: AppButton.primary(
                onPressed: () {
                  GoRouter.of(context).goNamed('dashboard');
                },
                label: '< Back',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _totalRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: bold ? 18 : 16,
              fontWeight: bold ? FontWeight.bold : FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: bold ? 18 : 16,
              fontWeight: bold ? FontWeight.bold : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}