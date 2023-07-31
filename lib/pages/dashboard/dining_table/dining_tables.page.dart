import 'package:eatery/references.dart';

Color _pageColor = KColors.tertiary;

class DiningTablesPage extends StatefulWidget {
  const DiningTablesPage({Key? key}) : super(key: key);

  @override
  State<DiningTablesPage> createState() => _DiningTablesPageState();
}

class _DiningTablesPageState extends State<DiningTablesPage> {
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
    List<DiningTable> diningTables = EateryDB.instance.diningTableBox!.values
        .where((element) =>
            selectedCategory == null ||
            element.categoryId == selectedCategory?.id)
        .toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _pageColor,
        title: const Text('Dining Tables'),
        foregroundColor: Colors.white,
        
        actions: [
          IconButton(
            icon: const Icon(
              Icons.category,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DiningTableCategoriesPage()),
              ).then((_) => setState(() {}));
            },
          ),
        ],
      ),
      body: diningTables.isNotEmpty
          ? ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                ...diningTables.map((diningTable) {
                  DiningTableCategory? category = EateryDB.instance
                          .diningTableCategoryBox!.values
                          .where((element) => element.id == diningTable.categoryId)
                          .isNotEmpty
                      ? EateryDB.instance.diningTableCategoryBox!.values
                          .where((element) => element.id == diningTable.categoryId)
                          .first
                      : null;
                  Order? order = diningTable.orderId != null
                      ? EateryDB.instance.orderBox!.values
                          .singleWhere((elem) => elem.id == diningTable.orderId)
                      : null;
                  // bool isAvailable = order == null || order.isPaid;
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          diningTable.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 6),
                        if (category != null)
                          CaptionLabel(label: category.name),
                        const SizedBox(width: 3),
                        if (diningTable.isActive)
                          CaptionLabel(
                            label: 'Active',
                            color: KColors.green,
                          )
                        else
                          CaptionLabel(
                            label: 'Inactive',
                            color: KColors.red,
                          ),
                      ],
                    ),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: KColors.primary,
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: LibraryImage(diningTable.image).image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    trailing: order != null
                        ? Text(
                            '${Common.currency?.symbol ?? ''}${order.finalTotal}',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: KColors.red),
                          )
                        : null,
                    subtitle: diningTable.description != null && diningTable.description?.trim() != ''
                        ? Text(diningTable.description!)
                        : null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditDiningTablePage(diningTable: diningTable)),
                      ).then((_) => setState(() {}));
                    },
                  );
                })
              ],
            )
          : const Center(
              child: Opacity(
                opacity: 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.table_restaurant,
                      size: 64,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No Tables Found',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Add a dining table to get started',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              )
            ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add Dining Table'),
        foregroundColor: Colors.white,
        backgroundColor: _pageColor,
        icon: const Icon(
          Icons.add,
        ),
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddDiningTablePage()),
          ).then((_) => setState(() {}));
        },
      )
    );
  }
}
