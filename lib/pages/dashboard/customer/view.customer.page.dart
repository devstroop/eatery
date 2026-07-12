import 'package:eatery/core/widgets/app_page_shell.dart';
import 'package:eatery/core/theme/app_typography.dart';
import 'package:eatery/references.dart';
import 'package:eatery/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery/presentation/providers/order_provider.dart';
import 'package:eatery/presentation/providers/company_provider.dart';

class ViewCustomer extends ConsumerStatefulWidget {
  ViewCustomer({super.key, required this.customer});

  Customer customer;

  @override
  ConsumerState<ViewCustomer> createState() => _ViewCustomerState();
}

class _ViewCustomerState extends ConsumerState<ViewCustomer> {
  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Customer Details',
      actions: [
          // More Vert
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(100, 100, 0, 100),
                items: [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  if (!widget.customer.isActive)
                    const PopupMenuItem(
                      value: 'activate',
                      child: Text('Activate'),
                    ),
                  if (widget.customer.isActive)
                    const PopupMenuItem(
                      value: 'suspend',
                      child: Text('Suspend'),
                    ),
                ],
              ).then((value) {
                switch (value) {
                  case 'edit':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditCustomerPage(customer: widget.customer),
                      ),
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          widget.customer = value;
                        });
                      }
                    });
                    break;
                  case 'activate':
                    widget.customer.isActive = true;
                    ref
                        .read(customerRepositoryProvider)
                        .saveCustomer(widget.customer)
                        .then(
                          (value) => showMessageDialog(
                            context,
                            'Successfully activated',
                            MessageType.success,
                            () => setState(() {}),
                          ),
                        )
                        .onError(
                          (error, stackTrace) => showMessageDialog(
                            context,
                            error.toString(),
                            MessageType.error,
                            () => setState(() {}),
                          ),
                        );
                    setState(() {
                      widget.customer.isActive = true;
                    });
                    break;
                  case 'suspend':
                    widget.customer.isActive = false;
                    ref
                        .read(customerRepositoryProvider)
                        .saveCustomer(widget.customer)
                        .then(
                          (value) => showMessageDialog(
                            context,
                            'Successfully suspended',
                            MessageType.success,
                            () => setState(() {}),
                          ),
                        )
                        .onError(
                          (error, stackTrace) => showMessageDialog(
                            context,
                            error.toString(),
                            MessageType.error,
                            () => setState(() {}),
                          ),
                        );
                    setState(() {
                      widget.customer.isActive = false;
                    });
                    break;
                }
              });
            },
          ),
        ],
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.grey200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                // Outstanding amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Outstanding\nAmount'),
                    Text(
                      '${ref.read(companyProvider.notifier).currency?.symbol ?? ''}${ref.read(customerRepositoryProvider).getOutstandingAmount(widget.customer.phone).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Name'),
                    Text(
                      widget.customer.name ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Phone'),
                    Text(
                      widget.customer.phone,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Address'),
                    Text(
                      (widget.customer.address ?? '').isNotEmpty
                          ? widget.customer.address!
                          : 'NA',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                // Landmark
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Landmark'),
                    Text(
                      (widget.customer.landmark ?? '').isNotEmpty
                          ? widget.customer.landmark!
                          : 'NA',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                // Last order date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Last Order At'),
                    Text(
                      widget.customer.lastOrderAt != null
                          ? widget.customer.lastOrderAt!.toIso8601String()
                          : 'NA',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                // Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Status'),
                    if (widget.customer.isActive)
                      const Icon(Icons.check_circle, color: Colors.green),
                    if (!widget.customer.isActive)
                      const Icon(Icons.cancel, color: AppColors.error),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(color: AppColors.grey200),
          ),

          Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Orders',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey700,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.grey200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      ...ref.read(orderRepositoryProvider).getAllOrders().map(
                        (e) => ListTile(
                          title: Text('${e.id ?? 'NA'}'),
                          subtitle: Text(e.createdAt.toIso8601String()),
                          trailing: Text(
                            '${ref.read(companyProvider.notifier).currency?.symbol ?? ''}${e.grandTotal}',
                          ),
                        ),
                      ),
                      if (ref.read(orderRepositoryProvider).getAllOrders().isEmpty)
                        ListTile(
                          title: Text(
                            'No previous orders',
                            style: TextStyle(color: AppColors.grey400),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /*
  double getCustomerOutstandingAmount(Customer? customer){
    if (customer == null) {
      return 0;
    }
    double outstandingAmount = 0;
    for (var order in EateryDB.instance.orderBox!.values.where((element) => element.customer?.id == customer.id)) {
      var payments = EateryDB.instance.paymentBox!.values.where((element) => element.order.id == order.id);
      if(payments.isNotEmpty){
        outstandingAmount += order.grandTotal - payments.map((e) => e.amount).reduce((value, element) => value + element);
      }
    }
    return outstandingAmount;
  }*/
}
