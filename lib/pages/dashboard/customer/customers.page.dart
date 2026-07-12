import 'package:eatery/core/theme/app_spacing.dart';
import 'package:eatery/core/theme/app_typography.dart';
import 'package:eatery/core/utils/responsive.dart';
import 'package:eatery/widgets/responsive/responsive_list_view.dart';
import 'package:eatery/pages/dashboard/customer/view.customer.page.dart';
import 'package:eatery/references.dart';
import 'package:eatery/core/theme/app_colors.dart';
import 'package:eatery/core/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery/presentation/providers/order_provider.dart';

Color _pageColor = AppColors.primary;

class CustomersPage extends ConsumerStatefulWidget {
  const CustomersPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends ConsumerState<CustomersPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Customers',
      color: _pageColor,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _pageColor,
        foregroundColor: AppColors.white,
        label: const Text('Add Customer'),
        icon: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCustomerPage()),
          ).then((_) => setState(() {}));
        },
      ),
      child: ref.read(customerRepositoryProvider).getAllCustomers().isNotEmpty
          ? ResponsiveListView(
              itemCount: ref
                  .read(customerRepositoryProvider)
                  .getAllCustomers()
                  .length,
              childAspectRatio: 3.5,
              itemBuilder: (context, index) {
                final customer = ref
                    .read(customerRepositoryProvider)
                    .getAllCustomers()[index];
                return _CustomerCard(customer: customer, pageColor: _pageColor);
              },
            )
          : const Center(
              child: Opacity(
                opacity: 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person, size: 64),
                    AppSpacing.gapLg,
                    Text(
                      'No Customers',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Add a customer to get started',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

/// Desktop-friendly card wrapper for a customer list item.
class _CustomerCard extends ConsumerStatefulWidget {
  final dynamic customer;
  final Color pageColor;

  const _CustomerCard({required this.customer, required this.pageColor});

  @override
  ConsumerState<_CustomerCard> createState() => _CustomerCardState();
}

class _CustomerCardState extends ConsumerState<_CustomerCard> {
  @override
  Widget build(BuildContext context) {
    final c = widget.customer;
    final isDesktop = Responsive.isDesktop(context);
    return Card(
      margin: EdgeInsets.symmetric(horizontal: isDesktop ? 4 : 0, vertical: 2),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ViewCustomer(customer: c)),
          );
        },
        leading: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.pageColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            c.name![0],
            style: const TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        title: Text(
          c.name ?? 'NA',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (c.address != null && c.address!.isNotEmpty) Text(c.address!),
            Text(c.phone),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () async {
            await showModalBottomSheet(
              context: context,
              builder: (ctx) => Container(
                margin: const EdgeInsets.only(bottom: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.edit),
                      title: const Text('Edit'),
                      onTap: () {
                        Navigator.pop(ctx);
                        if (c.id != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditCustomerPage(customer: c),
                            ),
                          ).then((_) => setState(() {}));
                        }
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.delete),
                      title: const Text('Delete'),
                      onTap: () {
                        Navigator.pop(ctx);
                        showDialog(
                          context: context,
                          builder: (ctx2) => AlertDialog(
                            title: const Text('Delete Customer'),
                            content: const Text(
                              'Are you sure you want to delete this customer?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx2),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  c
                                      .delete()
                                      .then((_) {
                                        showMessageDialog(
                                          context,
                                          'Customer deleted successfully',
                                          MessageType.success,
                                        );
                                        Navigator.pop(ctx2);
                                      })
                                      .onError((error, _) {
                                        showMessageDialog(
                                          context,
                                          error.toString(),
                                          MessageType.error,
                                        );
                                      })
                                      .whenComplete(() => setState(() {}));
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
