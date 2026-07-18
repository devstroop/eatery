import 'package:eatery_core/theme/app_spacing.dart';
import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery_core/providers/product_provider.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

Color _pageColor = AppColors.menuCategories;

class ProductCategoriesPage extends ConsumerStatefulWidget {
  const ProductCategoriesPage({super.key});

  @override
  ConsumerState<ProductCategoriesPage> createState() =>
      _ProductCategoriesPageState();
}

class _ProductCategoriesPageState extends ConsumerState<ProductCategoriesPage> {
  @override
  Widget build(BuildContext context) {
    final repo = ref.read(productRepositoryProvider);
    final categories = repo.getAllCategories();

    return AppPageShell(
      title: 'Product Categories',
      color: _pageColor,
      showBack: true,
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: AppColors.white,
        backgroundColor: _pageColor,
        icon: const Icon(Icons.add),
        label: const Text('Add Product Category'),
        onPressed: () {
          GoRouter.of(
            context,
          ).pushNamed('addProductCategory').then((_) => setState(() {}));
        },
      ),
      child: categories.isEmpty
          ? const AppEmptyState(
              icon: Icons.category,
              title: 'No categories found',
              subtitle: 'Add a product category to get started',
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return AppCard(
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  onTap: () {},
                  child: ListTile(
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMd,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMd,
                        ),
                        child: Image(
                          image: LibraryImage(category.image).image,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    title: Text(category.name, style: AppTypography.titleSmall),
                    subtitle: category.description?.trim().isNotEmpty == true
                        ? Text(
                            category.description!,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.grey500,
                            ),
                          )
                        : null,
                    trailing: PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.more_vert,
                        color: AppColors.grey500,
                      ),
                      onSelected: (value) async {
                        if (value == 'edit') {
                          await GoRouter.of(
                            context,
                          ).pushNamed('editProductCategory', extra: category);
                          setState(() {});
                        } else if (value == 'delete') {
                          _onCategoryDelete(context, category);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: ListTile(
                            leading: Icon(Icons.edit, size: 20),
                            title: Text('Edit'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: ListTile(
                            leading: const Icon(
                              Icons.delete,
                              size: 20,
                              color: AppColors.error,
                            ),
                            title: Text(
                              'Delete',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _onCategoryDelete(BuildContext context, ProductCategory category) {
    final repo = ref.read(productRepositoryProvider);
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Category'),
          content: const Text('Are you sure you want to delete this category?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await repo.deleteCategory(category);
                setState(() {});
                AppDialog.showMessage(
                  context,
                  message: 'Category deleted successfully',
                  type: MessageType.success,
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
