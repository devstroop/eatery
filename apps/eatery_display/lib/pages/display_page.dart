import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/eatery_core.dart';

final _liveOrdersProvider = FutureProvider.autoDispose<List<Order>>((ref) {
  final repo = ref.read(orderRepositoryProvider);
  return repo.getAllOrders()
      .where((o) => o.status == OrderStatus.pending || o.status == OrderStatus.preparing)
      .toList();
});

final _orderProductsProvider =
    FutureProvider.family<List<OrderProduct>, int>((ref, orderId) {
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
  int _prevCount = 0;

  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) {
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
    final count = orders.valueOrNull?.length ?? 0;
    if (count > _prevCount) _prevCount = count;

    return Scaffold(
      backgroundColor: Colors.black,
      body: orders.when(
        data: (list) {
          if (list.isEmpty) {
            _prevCount = 0;
            return _buildEmptyState();
          }
          return _buildOrderList(list);
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
        error: (e, _) => Center(
          child: Text('Error: $e', style: const TextStyle(color: Colors.red)),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: 1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.green),
            const SizedBox(height: 24),
            const Text(
              'All orders served!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No pending orders',
              style: TextStyle(color: Colors.grey[400], fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(List<Order> orders) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: orders.length,
      itemBuilder: (context, i) => _OrderStatusCard(
        key: ValueKey(orders[i].id),
        order: orders[i],
      ),
    );
  }
}

class _OrderStatusCard extends ConsumerWidget {
  final Order order;
  const _OrderStatusCard({required this.order, super.key});

  String get _elapsed {
    final diff = DateTime.now().difference(order.createdAt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    return '${diff.inHours}h ${diff.inMinutes % 60}m';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(_orderProductsProvider(order.id ?? 0));

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Card(
        color: const Color(0xFF1E1E1E),
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${order.id ?? '-'}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        (order.type.name ?? '').toUpperCase(),
                        style: TextStyle(color: Colors.grey[500], fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _elapsed,
                        style: TextStyle(color: Colors.grey[400], fontSize: 16),
                      ),
                    ],
                  ),
                  const Spacer(),
                  _StatusBadge(status: order.status),
                ],
              ),
              const SizedBox(height: 16),
              items.when(
                data: (list) => Column(
                  children: list.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${item.quantity}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item.productName,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final OrderStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final c = status.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c, width: 2),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
          color: c,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
