import 'package:eatery_core/theme/app_spacing.dart';
import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery_core/providers/order_provider.dart';
import 'package:eatery_core/providers/database_provider.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

Color _pageColor = AppColors.error;

class DiningTablesPage extends ConsumerStatefulWidget {
  const DiningTablesPage({Key? key}) : super(key: key);

  @override
  ConsumerState<DiningTablesPage> createState() => _DiningTablesPageState();
}

class _DiningTablesPageState extends ConsumerState<DiningTablesPage> {
  DiningTableCategory? selectedCategory;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        selectedCategory = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<DiningTable> diningTables = ref
        .read(diningTableRepositoryProvider)
        .getAllTables()
        .where(
          (element) =>
              selectedCategory == null ||
              element.category?.id == selectedCategory?.id,
        )
        .toList();
    return AppPageShell(
      title: 'Dining Tables',
      color: _pageColor,
      actions: [
        IconButton(
          icon: const Icon(Icons.category),
          onPressed: () {
            GoRouter.of(
              context,
            ).pushNamed('diningTableCategories').then((_) => setState(() {}));
          },
        ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add Dining Table'),
        foregroundColor: AppColors.white,
        backgroundColor: _pageColor,
        icon: const Icon(Icons.add),
        onPressed: () async {
          GoRouter.of(
            context,
          ).pushNamed('addDiningTable').then((_) => setState(() {}));
        },
      ),
      child: Column(
        children: [
          if ((ref.read(diningTableRepositoryProvider) as dynamic)
              .getAllCategories()
              .isNotEmpty)
            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  const SizedBox(width: 10),
                  ...(ref.read(diningTableRepositoryProvider) as dynamic)
                      .getAllCategories()
                      .map((category) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: ChoiceChip(
                            labelStyle: AppTypography.bodyMedium.copyWith(
                              color: selectedCategory?.id == category.id
                                  ? AppColors.white
                                  : AppColors.white500,
                            ),
                            labelPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            side: BorderSide(
                              color: selectedCategory?.id == category.id
                                  ? AppColors.white
                                  : AppColors.white500,
                              width: 1,
                            ),
                            label: Text(category.name),
                            selected: selectedCategory?.id == category.id,
                            selectedColor: _pageColor,
                            onSelected: (value) {
                              setState(() {
                                selectedCategory = value ? category : null;
                              });
                            },
                          ),
                        );
                      })
                      .toList(),
                ],
              ),
            ),
          Expanded(
            child: diningTables.isNotEmpty
                ? ListView(
                    padding: const EdgeInsets.only(bottom: 8),
                    children: [
                      ...diningTables.map((diningTable) {
                        DiningTableCategory? category =
                            diningTable.category?.id != null
                            ? (ref.read(diningTableRepositoryProvider)
                                      as dynamic)
                                  .getCategoryById(diningTable.category!.id)
                            : null;
                        Order? order = diningTable.orderId != null
                            ? ref
                                  .read(orderRepositoryProvider)
                                  .getOrderById(diningTable.orderId!)
                            : null;
                        return ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                diningTable.name,
                                style: AppTypography.titleMedium,
                              ),
                              const SizedBox(width: 6),
                              if (category != null)
                                CaptionLabel(label: category.name),
                              const SizedBox(width: 3),
                              // CaptionLabel(
                              //   label: diningTable.status.name,
                              //   color: AppColors.error,
                              // ),
                            ],
                          ),
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.white500,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                diningTable.id.toString(),
                                style: AppTypography.titleLarge.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                diningTable.status.name,
                                textAlign: TextAlign.end,
                                style: AppTypography.titleSmall.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: diningTable.status.color,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: () {
                                  showMenu(
                                    context: context,
                                    position: const RelativeRect.fromLTRB(
                                      100,
                                      100,
                                      0,
                                      100,
                                    ),
                                    items: [
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Text('Edit'),
                                      ),
                                      if (order == null)
                                        const PopupMenuItem(
                                          value: 'delete',
                                          child: Text('Delete'),
                                        ),
                                    ],
                                  ).then((value) async {
                                    if (value == 'edit') {
                                      GoRouter.of(context)
                                          .pushNamed(
                                            'editDiningTable',
                                            extra: diningTable,
                                          )
                                          .then((_) => setState(() {}));
                                    } else if (value == 'delete') {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                              'Delete Dining Table',
                                            ),
                                            content: const Text(
                                              'Are you sure you want to delete this dining table?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  ref
                                                      .read(eateryStoreProvider)
                                                      .execute(
                                                        'DELETE FROM dining_table WHERE id = ?',
                                                        [diningTable.id],
                                                      );
                                                  Navigator.pop(this.context);
                                                  setState(() {});
                                                },
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (diningTable.description != null &&
                                  diningTable.description?.trim() != '')
                                Text(diningTable.description!),

                              if (order != null)
                                TextButton(
                                  onPressed: () {
                                    GoRouter.of(context)
                                        .pushNamed('viewOrder', extra: order)
                                        .then((_) => setState(() {}));
                                  },
                                  child: Text(
                                    'Order: ${order.id}',
                                    style: AppTypography.titleSmall.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          onTap: () {
                            GoRouter.of(context)
                                .pushNamed(
                                  'viewDiningTable',
                                  extra: diningTable,
                                )
                                .then((_) => setState(() {}));
                          },
                        );
                      }),
                    ],
                  )
                : Center(
                    child: Opacity(
                      opacity: 0.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.table_restaurant, size: 64),
                          AppSpacing.gapLg,
                          Text(
                            'No Tables Found',
                            style: AppTypography.headlineSmall.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Add a dining table to get started',
                            style: AppTypography.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
