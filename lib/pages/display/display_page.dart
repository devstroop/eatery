import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/eatery_core.dart';

final _liveOrdersProvider = FutureProvider.autoDispose<List<Order>>((ref) {
  final repo = ref.read(orderRepositoryProvider);
  return repo
      .getAllOrders()
      .where(
        (o) =>
            o.status == OrderStatus.pending ||
            o.status == OrderStatus.preparing,
      )
      .toList();
});

final _orderProductsProvider = FutureProvider.family<List<OrderProduct>, int>((
  ref,
  orderId,
) {
  final repo = ref.read(orderRepositoryProvider);
  return repo.getOrderProducts(orderId);
});

class DisplayPage extends ConsumerStatefulWidget {
  const DisplayPage({super.key});

  @override
  ConsumerState<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends ConsumerState<DisplayPage> {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      ref.invalidate(_liveOrdersProvider);
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(_liveOrdersProvider);
    final size = MediaQuery.of(context).size;
    // Determine column count based on screen width (kiosk-friendly).
    final crossAxisCount = size.width >= 1200
        ? 4
        : size.width >= 800
        ? 3
        : 2;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Order Status'),
        automaticallyImplyLeading: false,
        actions: [
          const SyncStatusChip(),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => SyncHostSettingsSheet.show(context),
          ),
        ],
      ),
      body: orders.when(
        data: (list) => _buildDisplay(list, crossAxisCount),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildDisplay(List<Order> orders, int crossAxisCount) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, size: 80, color: AppColors.success),
            const SizedBox(height: 16),
            Text('All orders ready!', style: AppTypography.headlineMedium),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.6,
      ),
      itemCount: orders.length,
      itemBuilder: (context, index) => _OrderStatusCard(order: orders[index]),
    );
  }
}

class _OrderStatusCard extends ConsumerWidget {
  final Order order;

  const _OrderStatusCard({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(_orderProductsProvider(order.id!));
    final elapsed = DateTime.now().difference(order.createdAt);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: order ID + status + timer
            Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: order.status == OrderStatus.preparing
                        ? AppColors.warning
                        : AppColors.info,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Order #${order.id}',
                    style: AppTypography.titleLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _formatDuration(elapsed),
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.grey600,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: products.when(
                data: (items) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: items
                      .map(
                        (p) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            '${p.productName} x${p.quantity}',
                            style: AppTypography.bodyLarge,
                          ),
                        ),
                      )
                      .toList(),
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: _StatusBadge(status: order.status),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final min = d.inMinutes;
    final sec = d.inSeconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }
}

class _StatusBadge extends StatelessWidget {
  final OrderStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      OrderStatus.pending => ('Preparing', AppColors.warning),
      OrderStatus.preparing => ('Almost ready', AppColors.info),
      OrderStatus.completed => ('Ready!', AppColors.success),
      _ => ('Unknown', AppColors.grey500),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
