import 'package:eatery/references.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';

Color _pageColor = KColors.tertiary;

class ProductCategoriesPage extends StatefulWidget {
  const ProductCategoriesPage({Key? key}) : super(key: key);

  @override
  State<ProductCategoriesPage> createState() => _ProductCategoriesPageState();
}

class _ProductCategoriesPageState extends State<ProductCategoriesPage> {
  @override
  Widget build(BuildContext context) {
    List<ProductCategory> categories =
        EateryDB.instance.productCategoryBox!.values.toList();
    return Scaffold(
      backgroundColor: KColors.white800,
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
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      'No categories found',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Add a product category to get started',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                  ],
                ),
              ),
            ),
          for (var category in categories)
            ListTile(
              title: Text(category.name,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: category.description != null &&
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditProductCategoryPage(
                                            category: category)),
                              ).then((_) => setState(() {}));
                            },
                          ),
                        ),
                        PopupMenuItem(
                          child: ListTile(
                            leading: const Icon(Icons.delete),
                            title: const Text('Delete'),
                            onTap: () {
                              showMenu(
                                  context: context,
                                  position: const RelativeRect.fromLTRB(
                                      100, 100, 0, 100),
                                  items: [
                                    PopupMenuItem(
                                      child: ListTile(
                                        leading: const Icon(Icons.delete),
                                        title: const Text('Delete'),
                                        onTap: () {
                                          EateryDB.instance.productCategoryBox!
                                              .delete(category.id);
                                          setState(() {});
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ]);
                            },
                          ),
                        ),
                      ]);
                },
              ),
              leading: Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: (category.image ?? '').startsWith('http')
                      ? FastCachedImage(url: category.image!)
                      : Image(image: LibraryImage(category.image ?? '').image),
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
                builder: (context) => const AddProductCategoryPage()),
          ).then((_) => setState(() {}));
        },
      ),
    );
  }
}
