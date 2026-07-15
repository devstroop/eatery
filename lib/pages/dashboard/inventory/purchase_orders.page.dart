import "package:flutter/material.dart";
import "package:eatery_core/widgets/widgets.dart";
import "package:eatery_core/theme/app_typography.dart";
import "package:eatery_core/theme/app_colors.dart";
import "package:eatery_core/providers/database_provider.dart";
import "package:eatery_core/data/repositories/inventory_repository.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:intl/intl.dart";

class PurchaseOrdersPage extends ConsumerStatefulWidget {
  const PurchaseOrdersPage({super.key});
  @override
  ConsumerState<PurchaseOrdersPage> createState() => _PurchaseOrdersPageState();
}

class _PurchaseOrdersPageState extends ConsumerState<PurchaseOrdersPage> {
  @override
  Widget build(BuildContext context) {
    final repo = InventoryRepository(ref.read(eateryStoreProvider));
    final list = repo.getAllPurchaseOrders();
    return AppPageShell(
      title: "Purchase Orders",
      color: AppColors.menuInventory,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.menuInventory,
        foregroundColor: AppColors.white,
        label: const Text("New PO"),
        icon: const Icon(Icons.add),
        onPressed: () => GoRouter.of(
          context,
        ).pushNamed("addPurchaseOrder").then((_) => setState(() {})),
      ),
      child: list.isEmpty
          ? const Center(
              child: Opacity(
                opacity: 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt, size: 64),
                    SizedBox(height: 16),
                    Text("No purchase orders"),
                  ],
                ),
              ),
            )
          : ListView(
              children: list.map((po) {
                final statuses = [
                  "Ordered",
                  "Partial",
                  "Received",
                  "Cancelled",
                ];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: ListTile(
                    title: Text(
                      "PO #${po.id}",
                      style: AppTypography.titleMedium,
                    ),
                    subtitle: Text(
                      "${DateFormat.yMMMd().format(po.orderDate)}  |  \$${po.totalAmount}  |  ${statuses[po.status.clamp(0, 3)]}",
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }
}
