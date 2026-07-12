import 'package:eatery/core/theme/app_spacing.dart';
import 'package:eatery/core/theme/app_typography.dart';
import 'package:eatery/data/repositories/product_repository.dart';
import 'package:eatery/presentation/providers/product_provider.dart';
import 'package:eatery/references.dart';
import 'package:eatery/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'add.product.category.page.dart';
import 'edit.product.category.page.dart';

Color _pageColor = AppColors.menuCategories;

class ProductCategoriesPage extends ConsumerStatefulWidget {
  const ProductCategoriesPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProductCategoriesPage> createState() =>
      _ProductCategoriesPageState();
}

class _ProductCategoriesPageState extends ConsumerState<ProductCategoriesPage> {
  @override
  Widget build(BuildContext context) {
    final repo = ref.read(productRepositoryProvider);
    final categories = repo.getAllCategories();
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,
        title: const Text('Product Categories'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          if (categories.isEmpty)
            Center(
              child: Opacity(
                opacity: 0.50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/empty-folder.png',
                      width: 100,
                      height: 100,
                    ),
                    AppSpacing.gapLg,
                    const Text(
                      'No categories found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Add a product category to get started',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          for (var category in categories)
            ListTile(
              title: Text(
                category.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle:
                  category.description != null &&
                      category.description?.trim() != ''
                  ? Text(category.description ?? '')
                  : null,
              trailing: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  showMenu(
                    context: context,
                    position: const RelativeRect.fromLTRB(100, 100, 0, 100),
                    items: [
                      PopupMenuItem(
                        child: ListTile(
                          leading: const Icon(Icons.edit),
                          title: const Text('Edit'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditProductCategoryPage(category: category),
                              ),
                            ).then((_) {
                              setState(() {});
                            });
                          },
                        ),
                      ),
                      PopupMenuItem(
                        child: ListTile(
                          leading: const Icon(Icons.delete),
                          title: const Text('Delete'),
                          onTap: () => _onCategoryDelete(context, category),
                        ),
                      ),
                    ],
                  );
                },
              ),
              leading: Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Image(
                  image: LibraryImage(category.image).image,
                  fit: BoxFit.contain,
                  height: 48,
                  width: 48,
                ),
              ),
              onTap: () {},
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: Colors.white,
        backgroundColor: _pageColor,
        icon: const Icon(Icons.add),
        label: const Text('Add Product Category'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddProductCategoryPage(),
            ),
          ).then((_) => setState(() {}));
        },
      ),
    );
  }

  _onCategoryDelete(BuildContext context, ProductCategory category) {
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
                showMessageDialog(
                  context,
                  'Category deleted successfully',
                  MessageType.success,
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
