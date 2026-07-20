import "package:flutter/material.dart";
import "package:eatery/components/eatery_core_widgets/widgets.dart";
import "package:eatery_core/theme/app_typography.dart";
import "package:eatery_core/theme/app_colors.dart";
import "package:eatery_core/providers/database_provider.dart";
import "package:eatery_core/data/repositories/inventory_repository.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

class SuppliersPage extends ConsumerStatefulWidget {
  const SuppliersPage({super.key});
  @override
  ConsumerState<SuppliersPage> createState() => _SuppliersPageState();
}

class _SuppliersPageState extends ConsumerState<SuppliersPage> {
  @override
  Widget build(BuildContext context) {
    final repo = InventoryRepository(ref.read(eateryStoreProvider));
    final list = repo.getAllSuppliers();
    return AppPageShell(
      title: "Suppliers",
      color: AppColors.menuInventory,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.menuInventory,
        foregroundColor: AppColors.white,
        label: const Text("Add Supplier"),
        icon: const Icon(Icons.add),
        onPressed: () => GoRouter.of(
          context,
        ).pushNamed("addSupplier").then((_) => setState(() {})),
      ),
      child: list.isEmpty
          ? const Center(
              child: Opacity(
                opacity: 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.business, size: 64),
                    SizedBox(height: 16),
                    Text("No suppliers"),
                  ],
                ),
              ),
            )
          : ListView(
              children: list
                  .map(
                    (s) => Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: ListTile(
                        title: Text(s.name, style: AppTypography.titleMedium),
                        subtitle: Text(
                          "${s.contactName ?? ""}  ${s.phone ?? ""}",
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              onPressed: () => GoRouter.of(context)
                                  .pushNamed("editSupplier", extra: s)
                                  .then((_) => setState(() {})),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 20),
                              onPressed: () {
                                repo.deleteSupplier(s.id!);
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
