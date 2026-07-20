import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/providers/order_provider.dart';
import 'package:eatery_core/data/repositories/loyalty_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:eatery_core/providers/company_provider.dart';
import 'package:eatery_core/providers/database_provider.dart';

class ViewCustomer extends ConsumerStatefulWidget {
  const ViewCustomer({super.key, required this.customer});

  final Customer customer;

  @override
  ConsumerState<ViewCustomer> createState() => _ViewCustomerState();
}

class _ViewCustomerState extends ConsumerState<ViewCustomer> {
  late Customer _customer;

  @override
  void initState() {
    super.initState();
    _customer = widget.customer;
  }

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
                if (!_customer.isActive)
                  const PopupMenuItem(
                    value: 'activate',
                    child: Text('Activate'),
                  ),
                if (_customer.isActive)
                  const PopupMenuItem(value: 'suspend', child: Text('Suspend')),
              ],
            ).then((value) {
              switch (value) {
                case 'edit':
                  GoRouter.of(
                    context,
                  ).pushNamed('editCustomer', extra: _customer).then((value) {
                    if (value != null) {
                      setState(() {
                        _customer = value as Customer;
                      });
                    }
                  });
                  break;
                case 'activate':
                  _customer = _customer.copyWith(isActive: true);
                  ref
                      .read(customerRepositoryProvider)
                      .saveCustomer(_customer)
                      .then(
                        (value) => AppDialog.showMessage(
                          context,
                          message: 'Successfully activated',
                          type: MessageType.success,
                          onConfirm: () => setState(() {}),
                        ),
                      )
                      .onError(
                        (error, stackTrace) => AppDialog.showMessage(
                          context,
                          message: error.toString(),
                          type: MessageType.error,
                          onConfirm: () => setState(() {}),
                        ),
                      );
                  break;
                case 'suspend':
                  _customer = _customer.copyWith(isActive: false);
                  ref
                      .read(customerRepositoryProvider)
                      .saveCustomer(_customer)
                      .then(
                        (value) => AppDialog.showMessage(
                          context,
                          message: 'Successfully suspended',
                          type: MessageType.success,
                          onConfirm: () => setState(() {}),
                        ),
                      )
                      .onError(
                        (error, stackTrace) => AppDialog.showMessage(
                          context,
                          message: error.toString(),
                          type: MessageType.error,
                          onConfirm: () => setState(() {}),
                        ),
                      );
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
                      '${ref.read(companyProvider.notifier).currency?.symbol ?? ''}${ref.read(customerRepositoryProvider).getOutstandingAmount(_customer.phone).toStringAsFixed(2)}',
                      style: AppTypography.displayMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapSm,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Name'),
                    Text(
                      _customer.name ?? '',
                      style: AppTypography.titleMedium.copyWith(
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
                      _customer.phone,
                      style: AppTypography.titleMedium.copyWith(
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
                      (_customer.address ?? '').isNotEmpty
                          ? _customer.address!
                          : 'NA',
                      style: AppTypography.titleMedium.copyWith(
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
                      (_customer.landmark ?? '').isNotEmpty
                          ? _customer.landmark!
                          : 'NA',
                      style: AppTypography.titleMedium.copyWith(
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
                      _customer.lastOrderAt != null
                          ? _customer.lastOrderAt!.toIso8601String()
                          : 'NA',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                _buildLoyaltyCard(),
                const SizedBox(height: 5),
                // Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Status'),
                    if (_customer.isActive)
                      const Icon(Icons.check_circle, color: AppColors.success),
                    if (!_customer.isActive)
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
                    style: AppTypography.titleLarge.copyWith(
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
                      ...ref
                          .read(orderRepositoryProvider)
                          .getAllOrders()
                          .map(
                            (e) => ListTile(
                              title: Text('${e.id ?? 'NA'}'),
                              subtitle: Text(e.createdAt.toIso8601String()),
                              trailing: Text(
                                '${ref.read(companyProvider.notifier).currency?.symbol ?? ''}${e.grandTotal}',
                              ),
                            ),
                          ),
                      if (ref
                          .read(orderRepositoryProvider)
                          .getAllOrders()
                          .isEmpty)
                        ListTile(
                          title: Text(
                            'No previous orders',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.grey400,
                            ),
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

  Widget _buildLoyaltyCard() {
    final loyalty = LoyaltyRepository(
      ref.read(eateryStoreProvider),
    ).getByCustomer(_customer.id ?? 0);
    if (loyalty == null) return const SizedBox.shrink();
    final tierNames = ['Regular', 'Silver', 'Gold', 'Platinum'];
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.card_giftcard, color: Colors.amber),
                const SizedBox(width: 8),
                Text(
                  'Loyalty',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tierNames[loyalty.tier.clamp(0, 3)],
                    style: AppTypography.labelSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _loyaltyStat(loyalty.points.toStringAsFixed(0), 'Points'),
                _loyaltyStat('${loyalty.totalVisits}', 'Visits'),
                _loyaltyStat(
                  '\$${loyalty.totalSpent.toStringAsFixed(0)}',
                  'Spent',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _loyaltyStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        Text(label, style: AppTypography.labelSmall),
      ],
    );
  }
}
