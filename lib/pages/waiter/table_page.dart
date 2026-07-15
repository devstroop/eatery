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
        title: Text(
          staff != null ? '${staff.name}\'s Tables' : 'Eatery Waiter',
        ),
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
            ],
          ),
          const SizedBox(height: 12),
          if (available.isNotEmpty)
            _TableSection(
              title: 'Available',
              tables: available,
              onTableTap: widget.onTableTap,
              color: Colors.green,
            ),
          if (occupied.isNotEmpty)
            _TableSection(
              title: 'Occupied',
              tables: occupied,
              onTableTap: widget.onTableTap,
              color: Colors.orange,
            ),
          if (other.isNotEmpty)
            _TableSection(
              title: 'Other',
              tables: other,
              onTableTap: widget.onTableTap,
              color: Colors.grey,
            ),
        ],
      ),
    );
  }
}

class _TableSection extends StatelessWidget {
  final String title;
  final List<DiningTable> tables;
  final Color color;
  final void Function(DiningTable) onTableTap;

  const _TableSection({
    required this.title,
    required this.tables,
    required this.color,
    required this.onTableTap,
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
                        if (table.capacity != null && table.capacity! > 0)
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
