import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/eatery_core.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

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

enum _SectionMode { none, station }

class DisplayPage extends ConsumerStatefulWidget {
  const DisplayPage({super.key});

  @override
  ConsumerState<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends ConsumerState<DisplayPage> {
  Timer? _refreshTimer;
  Timer? _scrollTimer;
  final ScrollController _scrollController = ScrollController();
  _SectionMode _sectionMode = _SectionMode.none;
  int _scrollPage = 0;

  @override
  void initState() {
    super.initState();

    ref.listenManual(syncStatusProvider, (_, status) {
      if (status != null && status.pendingEntryCount >= 0) {
        ref.invalidate(_liveOrdersProvider);
      }
    });
    _refreshTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      ref.invalidate(_liveOrdersProvider);
    });
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _scrollTimer?.cancel();
    _scrollTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      _scrollToNextPage();
    });
  }

  void _scrollToNextPage() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    if (maxScroll <= 0) return;
    final target =
        (_scrollPage + 1) * _scrollController.position.viewportDimension;
    if (target >= maxScroll) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      _scrollPage = 0;
    } else {
      _scrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      _scrollPage++;
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _scrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(_liveOrdersProvider);
    final size = MediaQuery.of(context).size;
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
            icon: Icon(
              _sectionMode == _SectionMode.none ? Icons.view_agenda : Icons.dns,
            ),
            tooltip: _sectionMode == _SectionMode.none
                ? 'Group by station'
                : 'No grouping',
            onPressed: () {
              setState(() {
                _sectionMode = _sectionMode == _SectionMode.none
                    ? _SectionMode.station
                    : _SectionMode.none;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => SyncHostSettingsSheet.show(context),
          ),
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            tooltip: 'Switch Role',
            onPressed: () {
              ref.read(roleProvider.notifier).clearRole();
              context.goNamed('rolePicker');
            },
          ),
        ],
      ),
      body: orders.when(
        data: (list) => _buildDisplay(list, crossAxisCount),
        loading: () => Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: AppSkeleton(height: 400, borderRadius: AppSpacing.radiusLg),
        ),
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
            Lottie.asset(
              'assets/lottie/hurray.json',
              width: 200,
              height: 200,
              repeat: false,
            ),
            const SizedBox(height: 16),
            Text('All orders ready!', style: AppTypography.headlineMedium),
          ],
        ),
      );
    }

    if (_sectionMode == _SectionMode.station) {
      return _buildStationSections(orders, crossAxisCount);
    }

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.6,
      ),
      itemCount: orders.length,
      itemBuilder: (context, index) => AppOrderCard(
        order: orders[index],
        context: OrderCardContext.display,
        displayLeading: orders[index].status == OrderStatus.pending
            ? SizedBox(
                width: 24,
                height: 24,
                child: Lottie.asset(
                  'assets/lottie/105511-fireworks.json',
                  width: 24,
                  height: 24,
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildStationSections(List<Order> orders, int crossAxisCount) {
    final stationMap = <String, List<Order>>{};
    for (final order in orders) {
      final products = ref.watch(_orderProductsProvider(order.id!));
      final stationName = products.when(
        data: (items) {
          final names = items
              .where((p) => p.stationName != null && p.stationName!.isNotEmpty)
              .map((p) => p.stationName!)
              .toSet()
              .toList();
          return names.isNotEmpty ? names.join(', ') : 'General';
        },
        loading: () => 'General',
        error: (_, _) => 'General',
      );
      stationMap.putIfAbsent(stationName, () => []);
      stationMap[stationName]!.add(order);
    }

    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.all(24),
      children: stationMap.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12, top: 8),
              child: Text(
                entry.key,
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.6,
              ),
              itemCount: entry.value.length,
              itemBuilder: (context, index) => AppOrderCard(
                order: entry.value[index],
                context: OrderCardContext.display,
                displayLeading: entry.value[index].status == OrderStatus.pending
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: Lottie.asset(
                          'assets/lottie/105511-fireworks.json',
                          width: 24,
                          height: 24,
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      }).toList(),
    );
  }
}
