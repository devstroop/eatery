import 'package:eatery/presentation/providers/order_provider.dart';
import 'package:eatery/presentation/providers/database_provider.dart';
import 'package:eatery/references.dart';
import 'package:eatery/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: _pageColor,
        title: const Text('Dining Tables'),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DiningTableCategoriesPage(),
                ),
              ).then((_) => setState(() {}));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (ref
              .read(appDatabaseProvider)
              .diningTableCategoryBox
              .values
              .isNotEmpty)
            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  const SizedBox(width: 10),
                  ...ref
                      .read(appDatabaseProvider)
                      .diningTableCategoryBox
                      .values
                      .map((category) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: ChoiceChip(
                            labelStyle: TextStyle(
                              fontSize: 14,
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
                            ref
                                .read(appDatabaseProvider)
                                .diningTableCategoryBox
                                .values
                                .where(
                                  (element) =>
                                      element.id == diningTable.category?.id,
                                )
                                .isNotEmpty
                            ? ref
                                  .read(appDatabaseProvider)
                                  .diningTableCategoryBox
                                  .values
                                  .where(
                                    (element) =>
                                        element.id == diningTable.category?.id,
                                  )
                                  .first
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
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
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
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
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
                                style: TextStyle(
                                  fontSize: 14,
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditDiningTablePage(
                                                diningTable: diningTable,
                                              ),
                                        ),
                                      ).then((_) => setState(() {}));
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
                                                      .read(appDatabaseProvider)
                                                      .diningTableBox
                                                      .values
                                                      .where(
                                                        (element) =>
                                                            element.id ==
                                                            diningTable.id,
                                                      )
                                                      .firstOrNull
                                                      ?.delete()
                                                      .then((value) {
                                                        Navigator.pop(
                                                          this.context,
                                                        );
                                                        setState(() {});
                                                      });
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ViewOrderPage(order: order),
                                      ),
                                    ).then((_) => setState(() {}));
                                  },
                                  child: Text(
                                    'Order: ${order.id}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewDiningTablePage(
                                  diningTable: diningTable,
                                ),
                              ),
                            ).then((_) => setState(() {}));
                          },
                        );
                      }),
                    ],
                  )
                : const Center(
                    child: Opacity(
                      opacity: 0.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.table_restaurant, size: 64),
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
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add Dining Table'),
        foregroundColor: Colors.white,
        backgroundColor: _pageColor,
        icon: const Icon(Icons.add),
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddDiningTablePage()),
          ).then((_) => setState(() {}));
        },
      ),
    );
  }
}
