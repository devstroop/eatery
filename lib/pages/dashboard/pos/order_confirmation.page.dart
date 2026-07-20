import 'package:eatery_core/theme/app_typography.dart';
import 'package:intl/intl.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/theme/app_spacing.dart';
import 'package:eatery_core/providers/order_provider.dart';
import 'package:eatery_core/providers/company_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OrderConfirmationPage extends ConsumerStatefulWidget {
  const OrderConfirmationPage({super.key, required this.order});
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
            SizedBox(height: 48),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Receipt Preview', style: AppTypography.headlineSmall),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('Customer copy', style: AppTypography.bodyLarge)],
            ),
            AppSpacing.gapXl,
            RepaintBoundary(
              key: genKey,
              child: Container(
                color: AppColors.white,
                margin: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppSpacing.gapMd,
                    if (customer != null) ...[
                      Text(
                        customer.name ?? 'Unnamed',
                        style: AppTypography.headlineSmall,
                      ),
                      Text(customer.phone, style: AppTypography.bodyLarge),
                    ],
                    AppSpacing.gapSm,
                    Text(
                      'Order #${widget.order.id}',
                      style: AppTypography.bodyLarge,
                    ),
                    Text(
                      DateFormat(
                        'dd MMM yyyy hh:mm a',
                      ).format(widget.order.createdAt),
                      style: AppTypography.bodyLarge,
                    ),
                    AppSpacing.gapMd,
                    Divider(color: AppColors.white900),
                    AppSpacing.gapMd,
                    ..._items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item.productName,
                                style: AppTypography.bodyLarge,
                              ),
                            ),
                            Text(
                              '${item.quantity} x $currencySymbol${item.price}',
                              style: AppTypography.bodyMedium,
                            ),
                            AppSpacing.gapSm,
                            Text(
                              '$currencySymbol${item.total}',
                              style: AppTypography.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppSpacing.gapMd,
                    Divider(color: AppColors.white900),
                    AppSpacing.gapSm,
                    _totalRow(
                      'Sub Total',
                      '$currencySymbol${widget.order.subTotal}',
                    ),
                    if (widget.order.discountTotal > 0)
                      _totalRow(
                        'Discount',
                        '-$currencySymbol${widget.order.discountTotal}',
                      ),
                    _totalRow('Tax', '$currencySymbol${widget.order.taxTotal}'),
                    if (widget.order.roundOff != 0)
                      _totalRow(
                        'Round Off',
                        '$currencySymbol${widget.order.roundOff}',
                      ),
                    _totalRow(
                      'Grand Total',
                      '$currencySymbol${widget.order.grandTotal}',
                      bold: true,
                    ),
                    AppSpacing.gapMd,
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
            style: bold ? AppTypography.titleLarge : AppTypography.bodyLarge,
          ),
          Text(
            value,
            style: bold ? AppTypography.titleLarge : AppTypography.bodyLarge,
          ),
        ],
      ),
    );
  }
}
