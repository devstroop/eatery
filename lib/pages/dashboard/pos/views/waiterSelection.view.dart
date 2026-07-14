import "package:eatery_core/theme/app_typography.dart";
import "package:eatery_core/theme/app_colors.dart";
import "package:eatery_core/providers/order_provider.dart";
import "package:eatery/references.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class WaiterSelectionView extends ConsumerWidget {
  final void Function(int staffId)? onSelected;
  const WaiterSelectionView({super.key, this.onSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staffList = ref.read(staffRepositoryProvider).getAllStaff()
        .where((s) => s.type == StaffType.waiter).toList();
    return Column(children: [
      AppBar(
        title: const Text("Select Waiter"),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.black600,
      ),
      Container(margin: const EdgeInsets.symmetric(horizontal: 12), height: 0.5, color: AppColors.white600),
      Expanded(
        child: staffList.isEmpty
            ? const Center(child: Text("No waiters found"))
            : ListView.builder(
                itemCount: staffList.length,
                itemBuilder: (_, i) => ListTile(
                  leading: CircleAvatar(child: Text(staffList[i].name[0])),
                  title: Text(staffList[i].name),
                  subtitle: Text(staffList[i].phone ?? ""),
                  onTap: () { if (onSelected != null) onSelected!(staffList[i].id!); Navigator.pop(context); },
                ),
              ),
      ),
    ]);
  }
}
