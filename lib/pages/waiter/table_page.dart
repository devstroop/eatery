import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eatery_core/eatery_core.dart';

final _tablesProvider = FutureProvider<List<DiningTable>>((ref) {
  final repo = ref.read(diningTableRepositoryProvider);
  return repo.getAllTables();
});

class TablePage extends ConsumerStatefulWidget {
  const TablePage({super.key});

  @override
  ConsumerState<TablePage> createState() => _TablePageState();
}

class _TablePageState extends ConsumerState<TablePage> {
  @override
  void initState() {
    super.initState();
    ref.listenManual(syncStatusProvider, (_, status) {
      if (status != null && status.pendingEntryCount >= 0) {
        ref.invalidate(_tablesProvider);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tables = ref.watch(_tablesProvider);
    final cart = ref.watch(cartProvider);
    final staff = ref.watch(authSessionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(staff != null ? "${staff.name}'s Tables" : 'Eatery Waiter'),
        actions: [
          const SyncStatusChip(),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => context.push('/cart'),
              ),
              if (cart.cart.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${cart.cartTotalQuantity}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: tables.when(
        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.table_restaurant,
                    size: 64,
                    color: AppColors.grey400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tables configured',
                    style: AppTypography.headlineSmall.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ask an admin to add dining tables in settings.',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                ],
              ),
            );
          }
          return _TableGrid(
            tables: list,
            staffId: staff?.id,
            onTableTap: (table) {
              ref.read(cartProvider.notifier).setOrderType(OrderType.dine);
              ref.read(cartProvider.notifier).setDiningTable(table);
              context.push('/menu');
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _TableGrid extends ConsumerStatefulWidget {
  final List<DiningTable> tables;
  final int? staffId;
  final void Function(DiningTable) onTableTap;
  const _TableGrid({
    required this.tables,
    this.staffId,
    required this.onTableTap,
  });

  @override
  ConsumerState<_TableGrid> createState() => _TableGridState();
}

class _TableGridState extends ConsumerState<_TableGrid> {
  bool _showMyTables = false;
  bool _showFloorPlan = false;

  @override
  Widget build(BuildContext context) {
    var filtered = widget.tables;
    if (_showMyTables && widget.staffId != null) {
      filtered = filtered.where((t) => t.staffId == widget.staffId).toList();
    }
    final available = filtered
        .where((t) => t.status == DiningTableStatus.available)
        .toList();
    final occupied = filtered
        .where((t) => t.status == DiningTableStatus.occupied)
        .toList();
    final other = filtered
        .where(
          (t) =>
              t.status != DiningTableStatus.available &&
              t.status != DiningTableStatus.occupied,
        )
        .toList();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FilterChip(
                label: const Text('All Tables'),
                selected: !_showMyTables,
                onSelected: (_) => setState(() => _showMyTables = false),
              ),
              const SizedBox(width: 8),
              if (widget.staffId != null)
                FilterChip(
                  label: const Text('My Tables'),
                  selected: _showMyTables,
                  onSelected: (_) => setState(() => _showMyTables = true),
                ),
              const Spacer(),
              IconButton(
                icon: Icon(_showFloorPlan ? Icons.grid_view : Icons.map),
                onPressed: () =>
                    setState(() => _showFloorPlan = !_showFloorPlan),
                tooltip: _showFloorPlan ? 'Grid view' : 'Floor plan',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _showFloorPlan
                ? _FloorPlanCanvas(
                    tables: filtered,
                    onTableTap: widget.onTableTap,
                    onLongPress: _toggleOccupancy,
                  )
                : ListView(
                    children: [
                      if (available.isNotEmpty)
                        _TableSection(
                          title: 'Available',
                          tables: available,
                          onTableTap: widget.onTableTap,
                          onLongPress: _toggleOccupancy,
                          color: Colors.green,
                        ),
                      if (occupied.isNotEmpty)
                        _TableSection(
                          title: 'Occupied',
                          tables: occupied,
                          onTableTap: widget.onTableTap,
                          onLongPress: _toggleOccupancy,
                          color: Colors.orange,
                        ),
                      if (other.isNotEmpty)
                        _TableSection(
                          title: 'Other',
                          tables: other,
                          onTableTap: widget.onTableTap,
                          onLongPress: _toggleOccupancy,
                          color: Colors.grey,
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleOccupancy(DiningTable table) async {
    final repo = ref.read(diningTableRepositoryProvider);
    final newStatus = table.status == DiningTableStatus.available
        ? DiningTableStatus.occupied
        : DiningTableStatus.available;
    await repo.saveTable(table.copyWith(status: newStatus, orderId: null));
    ref.invalidate(_tablesProvider);
  }
}

class _FloorPlanCanvas extends StatelessWidget {
  final List<DiningTable> tables;
  final void Function(DiningTable) onTableTap;
  final void Function(DiningTable) onLongPress;

  const _FloorPlanCanvas({
    required this.tables,
    required this.onTableTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 3.0,
      child: SizedBox(
        width: 600,
        height: 600,
        child: CustomPaint(
          painter: _FloorPlanPainter(tables: tables),
          child: Stack(
            children: tables.map((table) {
              final pos = _tablePosition(table, tables.length);
              return Positioned(
                left: pos.dx,
                top: pos.dy,
                child: GestureDetector(
                  onTap: () => onTableTap(table),
                  onLongPress: () => onLongPress(table),
                  child: Container(
                    width: 80,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _statusColor(table.status).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _statusColor(table.status),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          table.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _statusColor(table.status),
                          ),
                        ),
                        Text(
                          table.status.shortName,
                          style: TextStyle(
                            fontSize: 10,
                            color: _statusColor(table.status),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Color _statusColor(DiningTableStatus status) {
    switch (status) {
      case DiningTableStatus.available:
        return Colors.green;
      case DiningTableStatus.occupied:
        return Colors.orange;
      case DiningTableStatus.reserved:
        return Colors.blue;
      case DiningTableStatus.inactive:
        return Colors.grey;
    }
  }

  Offset _tablePosition(DiningTable table, int total) {
    final cols = (total / 4).ceil().clamp(1, 4);
    final index = tables.indexOf(table);
    final row = index ~/ cols;
    final col = index % cols;
    return Offset(20.0 + col * 140.0, 20.0 + row * 100.0);
  }
}

class _FloorPlanPainter extends CustomPainter {
  final List<DiningTable> tables;
  _FloorPlanPainter({required this.tables});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    final gridPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.15)
      ..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 70) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 50) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _FloorPlanPainter old) => old.tables != tables;
}

class _TableSection extends StatelessWidget {
  final String title;
  final List<DiningTable> tables;
  final Color color;
  final void Function(DiningTable) onTableTap;
  final void Function(DiningTable) onLongPress;

  const _TableSection({
    required this.title,
    required this.tables,
    required this.color,
    required this.onTableTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.titleSmall.copyWith(color: color)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: tables
              .map(
                (table) => GestureDetector(
                  onTap: () => onTableTap(table),
                  onLongPress: () => onLongPress(table),
                  child: Container(
                    width: 100,
                    height: 80,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: color.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(table.name, style: AppTypography.titleMedium),
                        if (table.capacity > 0)
                          Text(
                            'Cap: ${table.capacity}',
                            style: AppTypography.bodySmall,
                          ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
