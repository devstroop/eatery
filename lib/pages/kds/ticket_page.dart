import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/eatery_core.dart';

final _stationsProvider = FutureProvider<List<KdsStation>>((ref) {
  final store = ref.read(eateryStoreProvider);
  return SqlitePreferenceStore(store: store).getAllKdsStations();
});

final _activeOrdersProvider = FutureProvider.autoDispose<List<Order>>((ref) {
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

/// Currently selected station filter (null = all stations).
final _selectedStationProvider = StateProvider<int?>((ref) => null);

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
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) {
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
    final stations = ref.watch(_stationsProvider);
    final selectedStation = ref.watch(_selectedStationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitchen Display'),
        actions: [
          const SyncStatusChip(),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => SyncHostSettingsSheet.show(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Station filter tabs
          stations.when(
            data: (list) => _StationFilter(
              stations: list,
              selected: selectedStation,
              onSelected: (id) =>
                  ref.read(_selectedStationProvider.notifier).state = id,
            ),
            loading: () => const SizedBox(height: 48),
            error: (_, __) => const SizedBox(height: 48),
          ),
          // Order grid
          Expanded(
            child: orders.when(
              data: (orderList) {
                var filtered = orderList;
                if (selectedStation != null) {
                  filtered = orderList.where((o) {
                    final products = ref.watch(_orderProductsProvider(o.id!));
                    return products.when(
                      data: (items) =>
                          items.any((p) => p.stationId == selectedStation),
                      loading: () => false,
                      error: (_, __) => false,
                    );
                  }).toList();
                }
                return _buildTicketGrid(filtered);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketGrid(List<Order> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: AppColors.success,
            ),
            const SizedBox(height: 16),
            Text('All caught up!', style: AppTypography.headlineSmall),
            const SizedBox(height: 8),
            Text('No pending orders', style: AppTypography.bodyLarge),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: orders.length,
      itemBuilder: (context, index) => _TicketCard(order: orders[index]),
    );
  }
}

class _StationFilter extends StatelessWidget {
  final List<KdsStation> stations;
  final int? selected;
  final void Function(int?) onSelected;

  const _StationFilter({
    required this.stations,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: const Text('All'),
              selected: selected == null,
              onSelected: (_) => onSelected(null),
            ),
          ),
          ...stations.map(
            (s) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(s.name),
                selected: selected == s.id,
                onSelected: (_) => onSelected(s.id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketCard extends ConsumerWidget {
  final Order order;

  const _TicketCard({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(_orderProductsProvider(order.id!));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.id}',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _StatusBadge(status: order.status),
              ],
            ),
            const SizedBox(height: 8),
            products.when(
              data: (items) => Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (_, i) =>
                      Text('• ${items[i].productName} x${items[i].quantity}'),
                ),
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${order.grandTotal.toStringAsFixed(2)}',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                _StatusActionButton(order: order),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusActionButton extends ConsumerWidget {
  final Order order;

  const _StatusActionButton({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (order.status == OrderStatus.completed) return const SizedBox.shrink();

    final nextStatus = order.status == OrderStatus.pending
        ? OrderStatus.preparing
        : OrderStatus.completed;
    final label = order.status == OrderStatus.pending ? 'Start' : 'Done';
    final color = order.status == OrderStatus.pending
        ? AppColors.info
        : AppColors.success;

    return SizedBox(
      height: 32,
      child: ElevatedButton(
        onPressed: () async {
          final repo = ref.read(orderRepositoryProvider);
          final staff = ref.read(authSessionProvider);
          final oid = order.id;
          if (oid == null) return;
          try {
            final updated = order.copyWith(status: nextStatus);
            await repo.saveOrder(updated);
            await repo.recordStatusTransition(
              OrderStatusHistory(
                orderId: oid,
                fromStatus: order.status.id,
                toStatus: nextStatus.id,
                changedByStaffId: staff?.id,
                changedAt: DateTime.now(),
              ),
            );
            ref.invalidate(_activeOrdersProvider);
          } catch (e) {
            debugPrint('Status transition failed: $e');
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed: $e'), backgroundColor: Colors.red),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          textStyle: const TextStyle(fontSize: 12),
        ),
        child: Text(label),
      ),
    );
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
      _ => ('Unknown', AppColors.grey500),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12)),
    );
  }
}
