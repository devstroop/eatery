import 'package:flutter/material.dart';
import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/providers/order_provider.dart';
import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bottom sheet for selecting product modifiers (sizes, toppings, extras).
class ModifierSheet extends ConsumerStatefulWidget {
  final Product product;
  final List<ModifierGroup> groups;
  final VoidCallback onConfirm;

  const ModifierSheet({
    super.key,
    required this.product,
    required this.groups,
    required this.onConfirm,
  });

  @override
  ConsumerState<ModifierSheet> createState() => _ModifierSheetState();
}

class _ModifierSheetState extends ConsumerState<ModifierSheet> {
  final Map<int, List<int>> _selected = {}; // groupId -> [modifierIds]
  double _extraCost = 0;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.85,
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
            const SizedBox(height: 16),
            Text(
              'Customize ${widget.product.name}',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_extraCost > 0)
              Text(
                '+${_extraCost.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                controller: scrollController,
                children: widget.groups.map((group) {
                  final modifiers = ref
                      .read(modifierRepositoryProvider)
                      .getModifiers(group.id!);
                  final selectedIds = _selected[group.id!] ?? [];
                  final totalInGroup = selectedIds.fold<int>(0, (s, id) {
                    final m = modifiers.where((m) => m.id == id).firstOrNull;
                    return s + (m?.priceAdjust.round() ?? 0).toInt();
                  });

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                group.name,
                                style: AppTypography.titleMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (group.isRequired)
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red[50],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Required',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          if (group.description != null)
                            Text(
                              group.description!,
                              style: AppTypography.bodySmall,
                            ),
                          const SizedBox(height: 8),
                          ...modifiers.map((m) {
                            final isSelected = selectedIds.contains(m.id);
                            return CheckboxListTile(
                              dense: true,
                              title: Text(
                                m.name,
                                style: AppTypography.bodyMedium,
                              ),
                              subtitle: m.priceAdjust > 0
                                  ? Text(
                                      '+${m.priceAdjust.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: Colors.green[700],
                                        fontSize: 12,
                                      ),
                                    )
                                  : null,
                              value: isSelected,
                              onChanged: (v) {
                                setState(() {
                                  if (v == true) {
                                    if (group.maxSelect > 0 &&
                                        selectedIds.length >= group.maxSelect)
                                      return;
                                    _selected[group.id!] = [
                                      ...selectedIds,
                                      m.id!,
                                    ];
                                  } else {
                                    if (selectedIds.length <= group.minSelect)
                                      return;
                                    _selected[group.id!] = selectedIds
                                        .where((id) => id != m.id)
                                        .toList();
                                  }
                                  _recalcCost();
                                });
                              },
                            );
                          }),
                          if (modifiers.length > 1)
                            Text(
                              '${selectedIds.length}/${group.maxSelect > 0 ? group.maxSelect : "any"} selected',
                              style: AppTypography.labelSmall,
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: widget.onConfirm,
                child: Text(
                  'Add to Order  \$${(widget.product.salePrice ?? widget.product.mrpPrice) + _extraCost}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _recalcCost() {
    _extraCost = 0;
    for (final entry in _selected.entries) {
      final modifiers = ref
          .read(modifierRepositoryProvider)
          .getModifiers(entry.key);
      for (final id in entry.value) {
        final m = modifiers.where((m) => m.id == id).firstOrNull;
        if (m != null) _extraCost += m.priceAdjust;
      }
    }
  }
}
