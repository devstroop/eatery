import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/theme/app_spacing.dart';
import 'package:eatery_core/providers/order_provider.dart';
import 'package:eatery/references.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ModifierGroupsPage extends ConsumerStatefulWidget {
  const ModifierGroupsPage({super.key});

  @override
  ConsumerState<ModifierGroupsPage> createState() => _ModifierGroupsPageState();
}

class _ModifierGroupsPageState extends ConsumerState<ModifierGroupsPage> {
  @override
  Widget build(BuildContext context) {
    final groups = ref.read(modifierRepositoryProvider).getAllGroups();
    return AppPageShell(
      title: 'Modifier Groups',
      color: AppColors.warning,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.warning,
        foregroundColor: AppColors.white,
        label: const Text('Add Group'),
        icon: const Icon(Icons.add),
        onPressed: () {
          GoRouter.of(
            context,
          ).pushNamed('addModifierGroup').then((_) => setState(() {}));
        },
      ),
      child: groups.isEmpty
          ? Center(
              child: Opacity(
                opacity: 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.tune, size: 64),
                    AppSpacing.gapLg,
                    Text(
                      'No modifier groups',
                      style: AppTypography.headlineSmall,
                    ),
                    AppSpacing.gapSm,
                    Text(
                      'Add groups like "Extra Toppings" or "Beverage Size"',
                      style: AppTypography.bodyMedium,
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              children: groups.map((g) {
                final modifiers = ref
                    .read(modifierRepositoryProvider)
                    .getModifiers(g.id!);
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: ListTile(
                    title: Text(g.name, style: AppTypography.titleMedium),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (g.description != null && g.description!.isNotEmpty)
                          Text(g.description!, style: AppTypography.bodySmall),
                        Text(
                          '${modifiers.length} options · ${g.isRequired ? 'Required' : 'Optional'} · min ${g.minSelect} max ${g.maxSelect}',
                          style: AppTypography.labelMedium,
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        AppDialog.show(
                          context,
                          title: 'Delete ${g.name}',
                          content:
                              'Delete this modifier group and all its options?',
                          destructive: true,
                          onConfirm: () {
                            ref
                                .read(modifierRepositoryProvider)
                                .deleteGroup(g.id!);
                            setState(() {});
                          },
                        );
                      },
                    ),
                    onTap: () {
                      GoRouter.of(context)
                          .pushNamed('editModifierGroup', extra: g)
                          .then((_) => setState(() {}));
                    },
                  ),
                );
              }).toList(),
            ),
    );
  }
}
