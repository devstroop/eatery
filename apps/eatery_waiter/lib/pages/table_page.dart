import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eatery_core/eatery_core.dart';

final _tablesProvider = FutureProvider<List<DiningTable>>((ref) {
  final repo = ref.read(diningTableRepositoryProvider);
  return repo.getAllTables();
});

class TablePage extends ConsumerWidget {
  const TablePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tables = ref.watch(_tablesProvider);
    final cart = ref.watch(cartProvider);
    final staff = ref.watch(authSessionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(staff != null ? '${staff.name}\'s Tables' : 'Eatery Waiter'),
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
                  right: 6, top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red, shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${cart.cartTotalQuantity}',
                      style: const TextStyle(
                        color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: tables.when(
        data: (list) => _TableGrid(
          tables: list,
          staffId: staff?.id,
          onTableTap: (table) {
            ref.read(cartProvider.notifier).setOrderType(OrderType.dine);
            ref.read(cartProvider.notifier).setDiningTable(table);
            context.push('/menu');
          },
        ),
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

  @override
  Widget build(BuildContext context) {
    var filtered = widget.tables;
    if (_showMyTables && widget.staffId != null) {
      filtered = filtered.where((t) => t.staffId == widget.staffId).toList();
    }
    final available = filtered.where((t) => t.status == DiningTableStatus.available).toList();
    final occupied = filtered.where((t) => t.status == DiningTableStatus.occupied).toList();
    final other = filtered.where((t) =>
      t.status != DiningTableStatus.available && t.status != DiningTableStatus.occupied
    ).toList();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Select Table', style: AppTypography.titleLarge),
              const Spacer(),
              if (widget.staffId != null)
                TextButton.icon(
                  icon: Icon(
                    _showMyTables ? Icons.table_restaurant : Icons.person,
                    size: 18,
                  ),
                  label: Text(_showMyTables ? 'All Tables' : 'My Tables'),
                  onPressed: () => setState(() => _showMyTables = !_showMyTables),
                ),
            ],
          ),
          AppSpacing.gapMd,
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      _showMyTables ? 'No tables assigned to you' : 'No tables found',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  )
                : ListView(
                    children: [
                      if (available.isNotEmpty) ...[
                        Text('Available (${available.length})',
                            style: AppTypography.titleSmall),
                        AppSpacing.gapSm,
                        Wrap(
                          spacing: 8, runSpacing: 8,
                          children: available.map((t) => _TableTile(
                            table: t, onTap: () => widget.onTableTap(t),
                          )).toList(),
                        ),
                        AppSpacing.gapMd,
                      ],
                      if (occupied.isNotEmpty) ...[
                        Text('Occupied (${occupied.length})',
                            style: AppTypography.titleSmall),
                        AppSpacing.gapSm,
                        Wrap(
                          spacing: 8, runSpacing: 8,
                          children: occupied.map((t) => _TableTile(
                            table: t, onTap: () => widget.onTableTap(t),
                          )).toList(),
                        ),
                        AppSpacing.gapMd,
                      ],
                      if (other.isNotEmpty) ...[
                        Text('Other (${other.length})',
                            style: AppTypography.titleSmall),
                        AppSpacing.gapSm,
                        Wrap(
                          spacing: 8, runSpacing: 8,
                          children: other.map((t) => _TableTile(
                            table: t, onTap: () => widget.onTableTap(t),
                          )).toList(),
                        ),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _TableTile extends StatelessWidget {
  final DiningTable table;
  final VoidCallback onTap;
  const _TableTile({required this.table, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = table.status.color;
    final isOccupied = table.status == DiningTableStatus.occupied;

    return GestureDetector(
      onTap: isOccupied ? null : onTap,
      child: Container(
        width: 80, height: 80,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: isOccupied ? Border.all(color: color, width: 2) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(table.name, style: AppTypography.titleMedium),
            AppSpacing.gapXs,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                table.status.shortName,
                style: const TextStyle(
                  color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (table.capacity > 0)
              Text('Cap: ${table.capacity}', style: const TextStyle(fontSize: 9)),
          ],
        ),
      ),
    );
  }
}
