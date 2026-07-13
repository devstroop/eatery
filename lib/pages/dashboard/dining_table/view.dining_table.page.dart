import 'package:eatery_core/widgets/app_page_shell.dart';
import 'package:eatery_core/theme/app_spacing.dart';
import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery_core/providers/order_provider.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    return AppPageShell(
      title: 'Dining Table Details',
      color: pageColor,
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
                GoRouter.of(context).pushNamed('editDiningTable', extra: widget.diningTable);
              } else if (value == 'unlink') {
                Navigator.of(context).pop(widget.diningTable.copyWith(orderId: null));
              }
            });
          },
        ),
      ],
      child: Padding(
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
                      style: AppTypography.headlineLarge.copyWith(fontWeight: FontWeight.bold),
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
                      style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w500, color: AppColors.white),
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
                          style: AppTypography.labelSmall,
                        ),
                        Text(
                          (widget.diningTable.capacity ?? 0).toString(),
                          style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
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
                          style: AppTypography.labelSmall,
                        ),
                        Text(
                          widget.diningTable.categoryId != null
                              ? ref.read(diningTableRepositoryProvider)
                                      .getCategoryById(widget.diningTable.categoryId!)
                                      ?.name ?? 'None'
                              : 'None',
                          style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Description',
                      style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
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
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.white500),
                    ),
                  ),
                ],
              ),
            // If table is occupied show the customer details and order details
            if (widget.diningTable.orderId != null) ...[
              AppSpacing.gapLg,
              Text(
                'Customer Details',
                style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
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
                            style: AppTypography.labelSmall,
                          ),
                          Text(
                            ref
                                    .read(customerRepositoryProvider)
                                    .getCustomerByPhone(
                                      widget.diningTable.customerPhone ?? '',
                                    )
                                    ?.name ??
                                'None',
                            style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
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
                            style: AppTypography.labelSmall,
                          ),
                          Text(
                            ref
                                    .read(customerRepositoryProvider)
                                    .getCustomerByPhone(
                                      widget.diningTable.customerPhone ?? '',
                                    )
                                    ?.phone ??
                                'None',
                            style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.gapLg,
              Text(
                'Order Details',
                style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
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
                            style: AppTypography.labelSmall,
                          ),
                          Text(
                            '#${widget.diningTable.orderId ?? 'None'}',
                            style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
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
                            'Order Status',
                            style: AppTypography.labelSmall,
                          ),
                          Text(
                            'None',
                            style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
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
