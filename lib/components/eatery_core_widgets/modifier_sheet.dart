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

  /// Called with the selected modifiers: groupId → list of modifierId.
  /// The second parameter is the total price adjustment from selected modifiers.
  final void Function(Map<int, List<int>> selected, double extraCost) onConfirm;

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
  final Map<int, List<int>> _selected = {};
  double _extraCost = 0;

  /// Cached modifiers per group — loaded to avoid repeated repository reads.
  Map<int, List<Modifier>> _modifiers = {};

  void _loadModifiers() {
    try {
      final repo = ref.read(modifierRepositoryProvider);
      for (final group in widget.groups) {
        if (group.id != null) {
          _modifiers[group.id!] = repo.getModifiers(group.id!);
        }
      }
    } catch (e) {
      debugPrint('ModifierSheet: failed to load modifiers: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadModifiers();
  }

  @override
  void didUpdateWidget(ModifierSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.groups != oldWidget.groups) {
      _selected.clear();
      _modifiers = {};
      _loadModifiers();
    }
  }

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
            if (_extraCost != 0)
              Text(
                '${_extraCost > 0 ? '+' : ''}${_extraCost.toStringAsFixed(2)}',
                style: TextStyle(
                  color: _extraCost > 0 ? Colors.green[700] : Colors.red[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                controller: scrollController,
                children: widget.groups.map((group) {
                  if (group.id == null) return const SizedBox.shrink();
                  final modifiers = _modifiers[group.id] ?? [];
                  final selectedIds = _selected[group.id] ?? [];

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
                            if (mod.id == null) return const SizedBox.shrink();
                            final isSelected = selectedIds.contains(mod.id);
                            final atMax =
                                group.maxSelect > 0 &&
                                selectedIds.length >= group.maxSelect;
                            return CheckboxListTile(
                              title: Text(mod.name),
                              subtitle: mod.priceAdjust != 0
                                  ? Text(
                                      '${mod.priceAdjust > 0 ? '+' : ''}${mod.priceAdjust.toStringAsFixed(2)}',
                                    )
                                  : null,
                              value: isSelected,
                              onChanged: (checked) {
                                final gid = group.id;
                                final mid = mod.id;
                                if (gid == null || mid == null) return;
                                setState(() {
                                  if (checked == true) {
                                    // Single-select: always replace (even if atMax).
                                    if (group.maxSelect == 1) {
                                      _selected[gid] = [mid];
                                    } else {
                                      if (atMax && !isSelected) return;
                                      _selected[gid] = [...selectedIds, mid];
                                    }
                                  } else {
                                    _selected[gid] = selectedIds
                                        .where((id) => id != mid)
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
                  // Check that all required modifier groups have a selection.
                  final loadFailed = widget.groups.any(
                    (g) =>
                        g.id != null &&
                        g.isRequired &&
                        (_modifiers[g.id]?.isEmpty ?? true),
                  );
                  if (loadFailed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Some modifier options failed to load. Close and try again.',
                        ),
                      ),
                    );
                    return;
                  }
                  final missing = widget.groups
                      .where(
                        (g) =>
                            g.id != null &&
                            g.isRequired &&
                            (_selected[g.id]?.isEmpty ?? true),
                      )
                      .map((g) => g.name)
                      .toList();
                  if (missing.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please select options for: ${missing.join(", ")}',
                        ),
                      ),
                    );
                    return;
                  }
                  // Check minSelect for non-required groups too.
                  for (final g in widget.groups) {
                    final count = _selected[g.id]?.length ?? 0;
                    if (g.minSelect > 0 && count < g.minSelect) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '"${g.name}" requires at least ${g.minSelect} selection(s)',
                          ),
                        ),
                      );
                      return;
                    }
                  }
                  widget.onConfirm(
                    Map.fromEntries(
                      _selected.entries.map(
                        (e) => MapEntry(e.key, List<int>.from(e.value)),
                      ),
                    ),
                    _extraCost,
                  );
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
      final modifiers = _modifiers[entry.key] ?? [];
      for (final modId in entry.value) {
        final mod = modifiers.where((m) => m.id == modId).firstOrNull;
        cost += mod?.priceAdjust ?? 0;
      }
    }
    _extraCost = cost;
  }
}
