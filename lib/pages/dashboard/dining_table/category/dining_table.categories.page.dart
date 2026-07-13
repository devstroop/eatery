import 'package:eatery/core/theme/app_spacing.dart';
import 'package:eatery/core/theme/app_typography.dart';
import 'package:eatery/presentation/providers/database_provider.dart';
import 'package:eatery/presentation/providers/order_provider.dart';
import 'package:eatery/references.dart';
import 'package:eatery/core/theme/app_colors.dart';
import 'package:eatery/core/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

Color _pageColor = AppColors.menuCategories;

class DiningTableCategoriesPage extends ConsumerStatefulWidget {
  const DiningTableCategoriesPage({Key? key}) : super(key: key);

  @override
  ConsumerState<DiningTableCategoriesPage> createState() =>
      _DiningTableCategoriesPageState();
}

class _DiningTableCategoriesPageState
    extends ConsumerState<DiningTableCategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Dining Table Categories',
      color: _pageColor,
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add Category'),
        backgroundColor: _pageColor,
        foregroundColor: AppColors.white,
        icon: const Icon(Icons.add),
        onPressed: () {
          GoRouter.of(
            context,
          ).pushNamed('addDiningTableCategory').then((_) => setState(() {}));
        },
      ),
      child:
          (ref.read(diningTableRepositoryProvider) as dynamic)
              .getAllCategories()
              .isNotEmpty
          ? ListView(
              children: [
                ...(ref.read(diningTableRepositoryProvider) as dynamic).getAllCategories().map((
                  each,
                ) {
                  return ListTile(
                    title: Text(each.name, style: AppTypography.titleMedium),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: _pageColor),
                          onPressed: () {
                            GoRouter.of(context)
                                .pushNamed(
                                  'editDiningTableCategory',
                                  extra: each,
                                )
                                .then((_) => setState(() {}));
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: _pageColor),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                // category exists in dining table then show message and return
                                if (ref
                                    .read(diningTableRepositoryProvider)
                                    .getAllTables()
                                    .any(
                                      (element) =>
                                          element.category?.id == each.id,
                                    )) {
                                  return AlertDialog(
                                    title: const Text('Delete Category'),
                                    content: const Text(
                                      'This category is currently in use. Please remove it from dining tables before deleting.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Ok'),
                                      ),
                                    ],
                                  );
                                }
                                return AlertDialog(
                                  title: const Text('Delete Category'),
                                  content: const Text(
                                    'Are you sure you want to delete this category?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        ref.read(eateryStoreProvider).execute(
                                          'DELETE FROM dining_table_category WHERE id = ?',
                                          [each.id],
                                        );
                                        Navigator.pop(context);
                                        setState(() {});
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    subtitle: Text(each.description ?? ''),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _pageColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          each.name[0],
                          style: AppTypography.headlineSmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {},
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
                    Icon(Icons.category, size: 64),
                    AppSpacing.gapLg,
                    Text(
                      'No Table Categories Found',
                      style: AppTypography.headlineSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Add a dining table category to get started',
                      style: AppTypography.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
