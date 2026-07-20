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
                  color: AppColors.grey300,
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
                                    color: AppColors.error.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Required',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.error,
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
                          ...modifiers.map((mod) {
                            final isSelected = selectedIds.contains(mod.id);
                            return CheckboxListTile(
                              title: Text(mod.name),
                              subtitle: mod.priceAdjust > 0
                                  ? Text(
                                      '+${mod.priceAdjust.toStringAsFixed(2)}',
                                    )
                                  : null,
                              value: isSelected,
                              onChanged: (checked) {
                                setState(() {
                                  if (checked == true) {
                                    _selected[group.id!] = [
                                      ...selectedIds,
                                      mod.id!,
                                    ];
                                  } else {
                                    _selected[group.id!] = selectedIds
                                        .where((id) => id != mod.id)
                                        .toList();
                                  }
                                  _recalcCost();
                                });
                              },
                              controlAffinity: ListTileControlAffinity.trailing,
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: apply modifiers to cart item
                  widget.onConfirm();
                  Navigator.pop(context);
                },
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _recalcCost() {
    double cost = 0;
    for (final entry in _selected.entries) {
      final repo = ref.read(modifierRepositoryProvider);
      for (final modId in entry.value) {
        final mod = repo.getModifierById(modId);
        cost += mod?.priceAdjust ?? 0;
      }
    }
    _extraCost = cost;
  }
}
