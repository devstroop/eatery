import 'package:eatery/core/widgets/app_page_shell.dart';
import 'package:eatery/core/theme/app_typography.dart';
import 'package:eatery/presentation/providers/order_provider.dart';
import 'package:eatery/references.dart';
import 'package:eatery/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'edit.order.page.dart';

class ViewOrderPage extends ConsumerStatefulWidget {
  const ViewOrderPage({Key? key, required this.order}) : super(key: key);
  final Order order;

  @override
  ConsumerState<ViewOrderPage> createState() => _ViewOrderPageState();
}

class _ViewOrderPageState extends ConsumerState<ViewOrderPage> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final customer = ref
        .read(customerRepositoryProvider)
        .getCustomerByPhone(widget.order.customerPhone ?? '');
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
            Text(
              'Order ID: ${widget.order.id}',
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Table: ',
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Customer: ${customer?.name ?? 'NA'}',
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Order Status: NA',
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Text(
              'Payment Status: ${widget.order.grandTotal > (widget.order.paidTotal ?? 0) ? 'Not Paid' : 'Paid'}',
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Order Type: ${widget.order.type.name}',
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Order Date: ${widget.order.createdAt}',
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Order Time: ${widget.order.createdAt}',
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Total Amount: ${widget.order.grandTotal}',
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Order Items',
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
