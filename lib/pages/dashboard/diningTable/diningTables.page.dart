import 'package:eatery/references.dart';

Color _pageColor = ColorStyle.tertiary;

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
              children: [
                ...diningTables.map((e) {
                  DiningTableCategory? category = EateryDB.instance
                          .diningTableCategoryBox!.values
                          .where((element) => element.id == e.categoryId)
                          .isNotEmpty
                      ? EateryDB.instance.diningTableCategoryBox!.values
                          .where((element) => element.id == e.categoryId)
                          .first
                      : null;
                  Order? order = e.orderId != null
                      ? EateryDB.instance.orderBox!.values
                          .singleWhere((elem) => elem.id == e.orderId)
                      : null;
                  // bool isAvailable = order == null || order.isPaid;
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          e.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 6),
                        if (category != null)
                          CaptionLabel(label: category.name),
                        const SizedBox(width: 3),
                        if (e.isActive)
                          CaptionLabel(
                            label: 'Inactive',
                            color: ColorStyle.text300,
                          )
                      ],
                    ),
                    leading: LeadingImageWidget(
                      image: LibraryImage(e.image ?? '').image,
                      elevation: 0.0,
                    ),
                    trailing: order != null
                        ? Text(
                            '${GlobalVariables.currency?.symbol ?? ''}${order.finalTotal}',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: ColorStyle.error),
                          )
                        : null,
                    subtitle: e.description != null && e.description?.trim() != ''
                        ? Text(e.description!)
                        : null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditDiningTablePage(diningTable: e)),
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
                      Icons.person,
                      size: 64,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No dining tables found',
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
