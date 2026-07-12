import 'package:eatery/core/theme/app_typography.dart';
import 'package:eatery/presentation/providers/order_provider.dart';
import 'package:eatery/references.dart';
import 'package:eatery/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: AppColors.menuCategories,
        foregroundColor: Colors.white,
        title: const Text('View Order'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditOrderPage(order: widget.order),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            Text(
              'Order ID: ${widget.order.id}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Table: ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Customer: ${customer?.name ?? 'NA'}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Order Status: NA',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Text(
              'Payment Status: ${widget.order.grandTotal > (widget.order.paidTotal ?? 0) ? 'Not Paid' : 'Paid'}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Order Type: ${widget.order.type.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Order Date: ${widget.order.createdAt}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Order Time: ${widget.order.createdAt}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Total Amount: ${widget.order.grandTotal}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Order Items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
