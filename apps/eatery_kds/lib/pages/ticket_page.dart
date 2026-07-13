import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/eatery_core.dart';

final _activeOrdersProvider = FutureProvider.autoDispose<List<Order>>((ref) {
  final repo = ref.read(orderRepositoryProvider);
  return repo.getAllOrders().where((o) => o.status == 'active').toList();
});

final _orderProductsProvider =
    FutureProvider.family<List<OrderProduct>, int>((ref, orderId) {
  final repo = ref.read(orderRepositoryProvider);
  return repo.getOrderProducts(orderId);
});

class TicketPage extends ConsumerStatefulWidget {
  const TicketPage({super.key});

  @override
  ConsumerState<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends ConsumerState<TicketPage> {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      ref.invalidate(_activeOrdersProvider);
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(_activeOrdersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eatery KDS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(_activeOrdersProvider),
          ),
        ],
      ),
      body: orders.when(
        data: (list) {
          if (list.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, size: 64, color: Colors.green),
                  SizedBox(height: 16),
                  Text('All caught up!',
                      style: TextStyle(fontSize: 20, color: Colors.green)),
                ],
              ),
            );
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = (constraints.maxWidth / 260).floor().clamp(2, 6);
              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemCount: list.length,
                itemBuilder: (_, i) => _TicketCard(order: list[i]),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _TicketCard extends ConsumerWidget {
  final Order order;
  const _TicketCard({required this.order});

  Color get _statusColor {
    switch (order.status) {
      case 'active':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  bool get _isNew {
    return DateTime.now().difference(order.createdAt).inMinutes < 2;
  }

  String get _elapsed {
    final diff = DateTime.now().difference(order.createdAt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    return '${diff.inHours}h ${diff.inMinutes % 60}m';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(_orderProductsProvider(order.id ?? 0));

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: _isNew ? 4 : 2,
      child: Stack(
        children: [
          if (_isNew)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'NEW',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _showDetail(context, ref),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_elapsed,
                          style: TextStyle(
                            color: _statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          )),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _statusColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          order.status.toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.gapSm,
                  Text(
                    '#${order.id ?? '-'}',
                    style: AppTypography.titleLarge,
                  ),
                  if (order.customerPhone != null &&
                      order.customerPhone!.isNotEmpty)
                    Text(
                      order.customerPhone!,
                      style: AppTypography.bodySmall,
                    ),
                  AppSpacing.gapXs,
                  Text(
                    (order.type.name ?? '').toUpperCase(),
                    style: AppTypography.bodySmall,
                  ),
                  const Spacer(),
                  items.when(
                    data: (list) => Text(
                      '${list.length} items',
                      style: AppTypography.bodyMedium,
                    ),
                    loading: () =>
                        const Text('...', style: AppTypography.bodyMedium),
                    error: (_, _) =>
                        const Text('?', style: AppTypography.bodyMedium),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDetail(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _TicketDetail(order: order),
    );
  }
}

class _TicketDetail extends ConsumerWidget {
  final Order order;
  const _TicketDetail({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(_orderProductsProvider(order.id ?? 0));

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, scrollController) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            AppSpacing.gapLg,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order #${order.id ?? '-'}',
                    style: AppTypography.headlineSmall),
                Text(
                  order.type.name ?? '',
                  style: AppTypography.bodyMedium,
                ),
              ],
            ),
            AppSpacing.gapSm,
            Text(
              'Placed ${order.createdAt.toString()}',
              style: AppTypography.bodySmall,
            ),
            AppSpacing.gapMd,
            Expanded(
              child: items.when(
                data: (list) => ListView.builder(
                  controller: scrollController,
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final item = list[i];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary,
                          child: Text('${item.quantity}',
                              style: const TextStyle(color: Colors.white)),
                        ),
                        title: Text(item.productName),
                        subtitle: item.stationName != null
                            ? Text('Station: ${item.stationName}')
                            : null,
                        trailing: Text(
                          '\$${item.total.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
            AppSpacing.gapMd,
            SizedBox(
              width: double.infinity,
              child: AppButton.primary(
                label: 'Mark Complete',
                onPressed: () async {
                  final repo = ref.read(orderRepositoryProvider);
                  final updated = order.copyWith(
                    status: 'completed',
                    updatedAt: DateTime.now(),
                  );
                  await repo.saveOrder(updated);
                  final coordinator = ref.read(syncCoordinatorProvider);
                  if (coordinator != null) {
                    MutationTracker.trackSave(
                      coordinator: coordinator,
                      entityType: 'order',
                      entity: updated,
                    );
                  }
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  ref.invalidate(_activeOrdersProvider);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
