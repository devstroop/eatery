import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eatery_core/eatery_core.dart';

final _waiterOrdersProvider = FutureProvider.autoDispose<List<Order>>((ref) {
  final staff = ref.watch(authSessionProvider);
  final repo = ref.read(orderRepositoryProvider);
  if (staff == null) return [];
  final all = repo.getAllOrders();
  return all.where((o) => o.staffId == staff.id).toList();
});

class WaiterOrdersPage extends ConsumerStatefulWidget {
  const WaiterOrdersPage({super.key});

  @override
  ConsumerState<WaiterOrdersPage> createState() => _WaiterOrdersPageState();
}

class _WaiterOrdersPageState extends ConsumerState<WaiterOrdersPage> {
  @override
  void initState() {
    super.initState();
    ref.listenManual(syncStatusProvider, (_, status) {
      if (status != null && status.pendingEntryCount >= 0) {
        ref.invalidate(_waiterOrdersProvider);
      }
    });
    // Show banner on order list changes
    ref.listenManual(_waiterOrdersProvider, (prev, next) {
      next.whenData((orders) {
        if (prev != null && mounted) {
          AppNotificationBanner.show(
            context,
            type: NotificationType.orderStatusChanged,
            message: 'Orders updated',
            subtitle: '${orders.length} order(s)',
            autoDismiss: const Duration(seconds: 4),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(_waiterOrdersProvider);
    final staff = ref.watch(authSessionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(staff != null ? "${staff.name}'s Orders" : 'My Orders'),
        actions: const [SyncStatusChip()],
      ),
      body: orders.when(
        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.receipt_long, size: 64, color: AppColors.grey400),
                  const SizedBox(height: 16),
                  Text(
                    'No orders yet',
                    style: AppTypography.headlineSmall.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap a table to start a new order.',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  AppButton.primary(
                    label: 'View Tables',
                    onPressed: () => context.goNamed('tables'),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (context, index) => _OrderCard(order: list[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _OrderCard extends ConsumerWidget {
  final Order order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staff = ref.watch(authSessionProvider);
    final isWaiter = staff?.type == StaffType.waiter;
    final currencySymbol =
        ref.read(companyProvider.notifier).currency?.symbol ?? '';
    final canEdit =
        isWaiter &&
        (order.status == OrderStatus.pending ||
            order.status == OrderStatus.preparing);

    return AppOrderCard(
      order: order,
      context: OrderCardContext.waiter,
      currencySymbol: currencySymbol,
      onTap: () => context.pushNamed('viewOrder', extra: order),
      trailing: canEdit
          ? PopupMenuButton<String>(
              onSelected: (value) =>
                  _handleAction(context, ref, value, order, staff),
              itemBuilder: (_) => [
                if (order.status == OrderStatus.pending)
                  const PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                      leading: Icon(Icons.edit, size: 20),
                      title: Text('Edit'),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                if (order.status == OrderStatus.pending ||
                    order.status == OrderStatus.preparing)
                  const PopupMenuItem(
                    value: 'void',
                    child: ListTile(
                      leading: Icon(Icons.cancel, size: 20, color: Colors.red),
                      title: Text('Void', style: TextStyle(color: Colors.red)),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
              ],
            )
          : null,
    );
  }

  void _handleAction(
    BuildContext context,
    WidgetRef ref,
    String value,
    Order order,
    Staff? staff,
  ) {
    if (value == 'edit') {
      context.pushNamed('editOrder', extra: order);
    } else if (value == 'void') {
      _showVoidDialog(context, ref, order, staff);
    }
  }

  void _showVoidDialog(
    BuildContext context,
    WidgetRef ref,
    Order order,
    Staff? staff,
  ) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Void Order'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Are you sure you want to void Order #${order.id}?'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason (required)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              reasonController.dispose();
              Navigator.pop(ctx);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final reason = reasonController.text.trim();
              reasonController.dispose();
              if (reason.isEmpty) return;
              Navigator.pop(ctx);
              try {
                final repo = ref.read(orderRepositoryProvider);
                final now = DateTime.now();
                await repo.saveOrder(
                  order.copyWith(
                    status: OrderStatus.voided,
                    voidReason: reason,
                    voidedBy: staff?.name,
                    voidedAt: now,
                    updatedAt: now,
                  ),
                );
                await repo.recordStatusTransition(
                  OrderStatusHistory(
                    orderId: order.id!,
                    fromStatus: order.status.id,
                    toStatus: OrderStatus.voided.id,
                    changedByStaffId: staff?.id,
                    changedAt: now,
                  ),
                );
                // Record void log
                final store = ref.read(sqlitePreferenceStoreProvider);
                store.saveVoidLogEntry(
                  VoidLogEntry(
                    orderId: order.id!,
                    voidedAt: now,
                    voidedBy: staff?.name ?? '',
                    reasonCode: 'WAITER_VOID',
                    reasonDescription: reason,
                    amount: order.grandTotal,
                  ),
                );
                ref.invalidate(_waiterOrdersProvider);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Order voided'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                debugPrint('Void failed: $e');
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Void Order'),
          ),
        ],
      ),
    );
  }
}
