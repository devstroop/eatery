import 'package:eatery/core/theme/app_spacing.dart';
import 'package:eatery/core/theme/app_typography.dart';
import 'package:eatery/presentation/providers/order_provider.dart';
import 'package:eatery/references.dart';
import 'package:eatery/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewDiningTablePage extends ConsumerStatefulWidget {
  const ViewDiningTablePage({Key? key, required this.diningTable})
    : super(key: key);
  final DiningTable diningTable;

  @override
  ConsumerState<ViewDiningTablePage> createState() =>
      _ViewDiningTablePageState();
}

class _ViewDiningTablePageState extends ConsumerState<ViewDiningTablePage> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color pageColor = widget.diningTable.status.color;
    final appBar = AppBar(
      backgroundColor: pageColor,
      foregroundColor: AppColors.white,
      title: const Text('Dining Table Details'),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            showMenu(
              context: context,
              position: const RelativeRect.fromLTRB(100, 100, 0, 100),
              items: [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(
                  value: 'unlink',
                  child: Text('Unlink from Order'),
                ),
              ],
            ).then((value) {
              if (value == 'edit') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        EditDiningTablePage(diningTable: widget.diningTable),
                  ),
                );
              } else if (value == 'unlink') {
                widget.diningTable.orderId = null;
                Navigator.of(context).pop();
              }
            });
          },
        ),
      ],
    );
    return Scaffold(
      backgroundColor: AppColors.grey200,
      appBar: appBar,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      widget.diningTable.name,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: widget.diningTable.status.color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.diningTable.status.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Capacity',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          (widget.diningTable.capacity ?? 0).toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Category',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          widget.diningTable.category?.name ?? 'None',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Description
            AppSpacing.gapLg,
            if (widget.diningTable.description != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.white900,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.diningTable.description!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: AppColors.white500,
                      ),
                    ),
                  ),
                ],
              ),
            // If table is occupied show the customer details and order details
            if (widget.diningTable.orderId != null) ...[
              AppSpacing.gapLg,
              const Text(
                'Customer Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Customer Name',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            ref
                                    .read(customerRepositoryProvider)
                                    .getCustomerByPhone(
                                      widget.diningTable.customerPhone ?? '',
                                    )
                                    ?.name ??
                                'None',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Customer Phone',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            ref
                                    .read(customerRepositoryProvider)
                                    .getCustomerByPhone(
                                      widget.diningTable.customerPhone ?? '',
                                    )
                                    ?.phone ??
                                'None',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.gapLg,
              const Text(
                'Order Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Order ID',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            '#${widget.diningTable.orderId ?? 'None'}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order Status',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            'None',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
