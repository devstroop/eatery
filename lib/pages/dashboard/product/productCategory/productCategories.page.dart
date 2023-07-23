import 'package:eatery/references.dart';

Color _pageColor = ColorStyle.tertiary;

class ProductCategoriesPage extends StatefulWidget {
  const ProductCategoriesPage({Key? key}) : super(key: key);

  @override
  State<ProductCategoriesPage> createState() => _ProductCategoriesPageState();
}

class _ProductCategoriesPageState extends State<ProductCategoriesPage> {
  @override
  Widget build(BuildContext context) {
    List<ProductCategory> categories = EateryDB.instance.productCategoryBox!.values.toList();
    return Scaffold(
      backgroundColor: ColorStyle.backgroundColor,
      appBar: AppBar(
          backgroundColor: _pageColor,
          foregroundColor: Colors.white,
          title: const Text('Product Categories'),
          ),
      body: categories.isNotEmpty ? ListView(
        children: [
          ListTile(
            title: const Text('Default',
                style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text('Uncategorized'),
            leading: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/default.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            onTap: () {},
          ),
          ...categories.map((category) {
            return ListTile(
              title: Text(category.name,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: category.description != null && category.description?.trim() != ''
                  ? Text(category.description ?? '')
                  : null,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: _pageColor,),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProductCategoryPage(
                                  category: category,
                                )),
                      ).then((_) => setState(() {}));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: _pageColor,),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            if(EateryDB.instance.productBox!.values.any((element) => element.categoryId == category.id)) {
                              return AlertDialog(
                                title: const Text('Delete Category'),
                                content: const Text(
                                    'This category is being used by some products. Please change the category of those products before deleting this category.'),
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
                                  'Are you sure you want to delete this category?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    category.delete().whenComplete((){
                                      Navigator.pop(context);
                                      setState(() {});
                                    });
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            );
                          });
                    },
                  )
                ],
              ),
              leading: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.circular(12.0),
                child: Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      image: DecorationImage(
                        image: LibraryImage(category.image ?? '').image,
                        fit: BoxFit.cover,
                      ),
                    )),
              ),
              onTap: () {},
            );
          }),
        ],
      ) : Center(
        child: Opacity(
          opacity: 0.50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/empty-folder.png', width: 100, height: 100,),
              const SizedBox(height: 16,),
              const Text('No categories found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              const Text('Add a product category to get started', style: TextStyle(fontSize: 16, color: Colors.black54),),
              const SizedBox(height: 48,),
            ],
          ),
        ),
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
