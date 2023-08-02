import 'package:eatery/references.dart';

Color _pageColor = KColors.tertiary;

class DiningTableCategoriesPage extends StatefulWidget {
  const DiningTableCategoriesPage({Key? key}) : super(key: key);

  @override
  State<DiningTableCategoriesPage> createState() =>
      _DiningTableCategoriesPageState();
}

class _DiningTableCategoriesPageState extends State<DiningTableCategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,

        title: const Text('Dining Table Categories'),
      ),
      body: EateryDB.instance.diningTableCategoryBox!.values.isNotEmpty ? ListView(
        children: [
          ...EateryDB.instance.diningTableCategoryBox!.values.map((each) {
            return ListTile(
              title: Text(each.name,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: _pageColor,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditDiningTableCategoryPage(category: each,)),
                      ).then((_) => setState(() {}));
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: _pageColor,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          // category exists in dining table then show message and return
                          if (EateryDB.instance.diningTableBox!.values
                              .any((element) => element.category == each.id)) {
                            return AlertDialog(
                              title: const Text('Delete Category'),
                              content: const Text(
                                  'This category is currently in use. Please remove it from dining tables before deleting.'),
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
                                  each.delete().whenComplete(() {
                                    Navigator.pop(context);
                                    setState(() {});
                                  });
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                )
              ),
              onTap: () {},
            );
          })
        ],
      ): const Center(
          child: Opacity(
            opacity: 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.category,
                  size: 64,
                ),
                SizedBox(height: 16),
                Text(
                  'No Table Categories Found',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Add a dining table category to get started',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          )),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add Category'),
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,
        icon: const Icon(
          Icons.add,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddDiningTableCategoryPage()),
          ).then((_) => setState(() {}));
        },
      ),
    );
  }
}
