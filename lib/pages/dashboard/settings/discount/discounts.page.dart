import "package:flutter/material.dart";
import "package:eatery_core/widgets/widgets.dart";
import "package:eatery_core/theme/app_typography.dart";
import "package:eatery_core/theme/app_colors.dart";
import "package:eatery_core/theme/app_spacing.dart";
import "package:eatery_core/widgets/app_dialog.dart";
import "package:eatery_core/providers/database_provider.dart";
import "package:eatery_core/data/models/eatery_db.dart";
import "package:eatery_core/data/repositories/discount_repository.dart";
import "package:eatery/references.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:intl/intl.dart";

class DiscountsPage extends ConsumerStatefulWidget {
  const DiscountsPage({super.key});
  @override
  ConsumerState<DiscountsPage> createState() => _DiscountsPageState();
}

class _DiscountsPageState extends ConsumerState<DiscountsPage> {
  @override
  Widget build(BuildContext context) {
    final repo = DiscountRepository(ref.read(eateryStoreProvider));
    final discounts = repo.getAllDiscounts();
    return AppPageShell(
      title: "Discounts",
      color: AppColors.menuCategories,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.menuCategories,
        foregroundColor: AppColors.white,
        label: const Text("Add Discount"),
        icon: const Icon(Icons.add),
        onPressed: () => GoRouter.of(context).pushNamed("addDiscount").then((_) => setState(() {})),
      ),
      child: discounts.isEmpty
          ? const Center(child: Opacity(opacity: 0.5, child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.local_offer, size: 64), SizedBox(height: 16),
                Text("No discounts configured", style: TextStyle(fontSize: 18))])))
          : ListView(children: discounts.map((d) {
        final typeName = d.type == 0 ? "%" : d.type == 1 ? "Fixed" : "BOGO";
        return Card(margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            title: Text(d.name, style: AppTypography.titleMedium),
            subtitle: Text("$typeName ${d.value}  |  Active: ${d.isActive ? "Yes" : "No"}"
                "${d.startsAt != null ? "  ·  From ${DateFormat.yMMMd().format(d.startsAt!)}" : ""}"),
            trailing: IconButton(icon: const Icon(Icons.delete),
              onPressed: () { AppDialog.show(this.context, title: "Delete ${d.name}", destructive: true,
                onConfirm: () { repo.deleteDiscount(d.id!); setState(() {}); }); }),
            onTap: () => GoRouter.of(context).pushNamed("editDiscount", extra: d).then((_) => setState(() {})),
          ));
      }).toList()),
    );
  }
}
