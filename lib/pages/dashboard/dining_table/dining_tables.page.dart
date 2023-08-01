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
            element.category == selectedCategory?.id)
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
        body: Column(
          children: [
            if (EateryDB.instance.diningTableCategoryBox!.values.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(8),
                child: DropdownButton<DiningTableCategory>(
                  isExpanded: true,
                  hint: const Text('Select Category'),
                  value: selectedCategory,
                  onChanged: (DiningTableCategory? newValue) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  },
                  items: EateryDB.instance.diningTableCategoryBox!.values
                      .map<DropdownMenuItem<DiningTableCategory>>(
                          (DiningTableCategory value) {
                    return DropdownMenuItem<DiningTableCategory>(
                      value: value,
                      child: Text(value.name),
                    );
                  }).toList(),
                ),
              ),
            Expanded(
              child: diningTables.isNotEmpty
                  ? ListView(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      children: [
                        ...diningTables.map((diningTable) {
                          DiningTableCategory? category = EateryDB
                                  .instance.diningTableCategoryBox!.values
                                  .where((element) =>
                                      element.id == diningTable.category)
                                  .isNotEmpty
                              ? EateryDB.instance.diningTableCategoryBox!.values
                                  .where((element) =>
                                      element.id == diningTable.category)
                                  .first
                              : null;
                          Order? order = diningTable.order != null
                              ? EateryDB.instance.orderBox!.values.singleWhere(
                                  (elem) => elem.id == diningTable.order)
                              : null;
                          // bool isAvailable = order == null || order.isPaid;
                          return ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  diningTable.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(width: 6),
                                if (category != null)
                                  CaptionLabel(label: category.name),
                                const SizedBox(width: 3),
                                if (!diningTable.isActive)
                                  CaptionLabel(
                                    label: 'Inactive',
                                    color: KColors.red,
                                  ),
                              ],
                            ),
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: KColors.white500,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  diningTable.id.toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                order != null
                                    ? Text(
                                        'Busy\n${Common.currency?.symbol ?? ''}${order.finalTotal}',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: KColors.red),
                                      )
                                    : Text(
                                        'Available',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: KColors.green),
                                      ),
                                IconButton(
                                  icon: const Icon(Icons.more_vert),
                                  onPressed: () {
                                    showMenu(
                                        context: context,
                                        position: const RelativeRect.fromLTRB(
                                            100, 100, 0, 100),
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
                                        ]).then((value) async {
                                      if (value == 'edit') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditDiningTablePage(
                                                      diningTable:
                                                          diningTable)),
                                        ).then((_) => setState(() {}));
                                      } else if (value == 'delete') {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Delete Dining Table'),
                                                content: const Text(
                                                    'Are you sure you want to delete this dining table?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      EateryDB
                                                          .instance
                                                          .diningTableBox!
                                                          .values
                                                          .where((element) =>
                                                              element.id ==
                                                              diningTable.id)
                                                          .firstOrNull
                                                          ?.delete()
                                                          .then((value) {
                                                        Navigator.pop(
                                                            this.context);
                                                        setState(() {});
                                                      });
                                                    },
                                                    child: const Text('Delete'),
                                                  ),
                                                ],
                                              );
                                            });
                                      }
                                    });
                                  },
                                )
                              ],
                            ),
                            subtitle: diningTable.description != null &&
                                    diningTable.description?.trim() != ''
                                ? Text(diningTable.description!)
                                : null,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewDiningTablePage(
                                        diningTable: diningTable)),
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
                    )),
            ),
          ],
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
              MaterialPageRoute(
                  builder: (context) => const AddDiningTablePage()),
            ).then((_) => setState(() {}));
          },
        ));
  }
}
