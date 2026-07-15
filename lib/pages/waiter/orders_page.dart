import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eatery_core/eatery_core.dart';

/// Displays orders created by the currently authenticated waiter.
final _waiterOrdersProvider = FutureProvider.autoDispose<List<Order>>((ref) {
  final staff = ref.watch(authSessionProvider);
  final repo = ref.read(orderRepositoryProvider);
  if (staff == null) return [];
  final all = repo.getAllOrders();
  return all.where((o) => o.staffId == staff.id).toList();
});

final _waiterOrderProductsProvider =
    FutureProvider.family<List<OrderProduct>, int>((ref, orderId) {
      final repo = ref.read(orderRepositoryProvider);
      return repo.getOrderProducts(orderId);
    });

class WaiterOrdersPage extends ConsumerWidget {
  const WaiterOrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(_waiterOrdersProvider);
    final staff = ref.watch(authSessionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(staff != null ? '${staff.name}\'s Orders' : 'My Orders'),
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
                    'Your submitted orders will appear here.',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.grey500,
                    ),
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
    final products = ref.watch(_waiterOrderProductsProvider(order.id!));

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.pushNamed('viewOrder', extra: order),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Order icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _statusColor(order.status).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.receipt, color: _statusColor(order.status)),
              ),
              const SizedBox(width: 16),
              // Order info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${order.id}',
                      style: AppTypography.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    products.when(
                      data: (items) => Text(
                        '${items.length} item${items.length == 1 ? '' : 's'}',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.grey600,
                        ),
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${order.grandTotal.toStringAsFixed(2)}',
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Status badge
              _StatusBadge(status: order.status),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return AppColors.warning;
      case OrderStatus.preparing:
        return AppColors.info;
      case OrderStatus.completed:
        return AppColors.success;
      default:
        return AppColors.grey500;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final OrderStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      OrderStatus.pending => ('Pending', AppColors.warning),
      OrderStatus.preparing => ('Preparing', AppColors.info),
      OrderStatus.completed => ('Completed', AppColors.success),
      _ => ('Unknown', AppColors.grey500),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
