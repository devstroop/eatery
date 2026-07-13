import 'package:eatery_core/widgets/app_page_shell.dart';
import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditOrderPage extends ConsumerStatefulWidget {
  const EditOrderPage({super.key, required this.order});
  final Order order;

  @override
  ConsumerState<EditOrderPage> createState() => _EditOrderPageState();
}

class _EditOrderPageState extends ConsumerState<EditOrderPage> {
  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Edit Order',
      color: AppColors.menuCategories,
      actions: [
        IconButton(
          icon: const Icon(Icons.done),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            Text(
              'Order ID: ${widget.order.id}',
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Table: ',
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Order Status: ',
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Order Date: ',
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Order Time: ',
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Order Total: ',
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Order Items: ',
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
