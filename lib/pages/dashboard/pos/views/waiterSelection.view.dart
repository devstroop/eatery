import "package:eatery_core/theme/app_colors.dart";
import "package:eatery_core/providers/order_provider.dart";
import "package:eatery/references.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class WaiterSelectionView extends ConsumerWidget {
  final void Function(int employeeId)? onSelected;
  const WaiterSelectionView({super.key, this.onSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeeList = ref
        .read(employeeRepositoryProvider)
        .getAllEmployees()
        .where((s) => s.type == EmployeeRole.waiter)
        .toList();
    return Column(
      children: [
        AppBar(
          title: const Text("Select Waiter"),
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.black600,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          height: 0.5,
          color: AppColors.white600,
        ),
        Expanded(
          child: employeeList.isEmpty
              ? const Center(child: Text("No waiters found"))
              : ListView.builder(
                  itemCount: employeeList.length,
                  itemBuilder: (_, i) => ListTile(
                    leading: CircleAvatar(child: Text(employeeList[i].name[0])),
                    title: Text(employeeList[i].name),
                    subtitle: Text(employeeList[i].phone ?? ""),
                    onTap: () {
                      if (onSelected != null) onSelected!(employeeList[i].id!);
                      Navigator.pop(context);
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
