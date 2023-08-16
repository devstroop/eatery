import 'package:excel/excel.dart' as excel;
import 'package:eatery/references.dart';
import 'package:http/http.dart' as http;

final _pageColor = KColors.tertiary;

class DataManagementPage extends StatefulWidget {
  const DataManagementPage({Key? key}) : super(key: key);

  @override
  State<DataManagementPage> createState() => _DataManagementPageState();
}

class _DataManagementPageState extends State<DataManagementPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _pageColor,
        foregroundColor: Colors.white,
        title: const Text('Data Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              showMenu(
                  context: context,
                  position: const RelativeRect.fromLTRB(100, 100, 0, 0),
                  items: [
                    const PopupMenuItem(
                      value: 'demo',
                      child: Text('Download Demo Data'),
                    ),
                  ]).then((value) {
                if (value == 'demo') {
                  _downloadDemoData(context);
                }
              });
            },
          ),
        ],
      ),
      body: ListView(scrollDirection: Axis.vertical, children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.googleDrive,
                color: _pageColor,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                'Google Drive Backup / Restore',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700]),
              ),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                child: Divider(color: Colors.grey[300]),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[400]!),
          ),
          child: Row(
            children: [
              Icon(
                Icons.history,
                color: Colors.grey[700],
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                'Last Backup: ',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700]),
              ),
              Text(
                'Never',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700]),
              ),
            ],
          ),
        ),
        ListTile(
            leading: Icon(
              FontAwesomeIcons.upload,
              color: Colors.grey[700],
            ),
            title: Text(
              'Backup ↑',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700]),
            ),
            subtitle: Text(
              'Backup data to Google Drive',
              style: TextStyle(color: Colors.grey[700]),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ImportPage(),
                  fullscreenDialog: true,
                ))),
        ListTile(
          leading: Icon(
            FontAwesomeIcons.download,
            color: Colors.grey[700],
          ),
          title: Text(
            'Restore ↓',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700]),
          ),
          subtitle: Text(
            'Restore data from Google Drive',
            style: TextStyle(color: Colors.grey[700]),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ExportPage(),
                fullscreenDialog: true),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.fileExcel,
                color: _pageColor,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                'Import / Export',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700]),
              ),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                child: Divider(color: Colors.grey[300]),
              ),
            ],
          ),
        ),
        ListTile(
            leading: Icon(
              FontAwesomeIcons.fileImport,
              color: Colors.grey[700],
            ),
            title: Text(
              'Import',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            subtitle: Text(
              'Import data from json/excel file',
              style: TextStyle(color: Colors.grey[700]),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ImportPage(),
                  fullscreenDialog: true,
                ))),
        ListTile(
          leading: Icon(
            FontAwesomeIcons.fileExport,
            color: Colors.grey[700],
          ),
          title: Text(
            'Export',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700]),
          ),
          subtitle: Text(
            'Export data to json/excel file',
            style: TextStyle(color: Colors.grey[700]),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ExportPage(),
                fullscreenDialog: true),
          ),
        ),
      ]),
    );
  }

/*

  Future<void> doImportProducts() async {
    await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xls', 'xlsx']).then((result) {
      if (result != null) {
        File file = File(result.files.single.path!);
        var bytes = file.readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);

        // Fetch sheet by table name
        var productsTable = excel.tables['Products'];
        var productCategoriesTable = excel.tables['Product Categories'];
        var taxSlabsTable = excel.tables['Tax Slabs'];
        var staffsTable = excel.tables['Staffs'];
        var diningTablesTable = excel.tables['Dining Tables'];
        var diningTableCategoriesTable = excel.tables['Dining Table Categories'];
        var customersTable = excel.tables['Customers'];
        var ordersTable = excel.tables['Orders'];

        // Populate Products
        for (var row in productsTable!.rows) {
          Product product = Product.fromIterable(row.map((e) => e?.value.toString()));
          EateryDB.instance.productBox!.put(product.id, product);
        }

        // Populate Product Categories
        for (var row in productCategoriesTable!.rows) {
          ProductCategory productCategory = ProductCategory.fromIterable(row.map((e) => e?.value.toString()));
          EateryDB.instance.productCategoryBox!.put(productCategory.id, productCategory);
        }

        // Populate Tax Slabs
        for (var row in taxSlabsTable!.rows) {
          TaxSlab taxSlab = TaxSlab.fromIterable(row.map((e) => e?.value));
          EateryDB.instance.taxSlabBox!.put(taxSlab.id, taxSlab);
        }

        // Populate Staffs
        for (var row in staffsTable!.rows) {
          Staff staff = Staff.fromIterable(row.map((e) => e?.value));
          EateryDB.instance.staffBox!.put(staff.id, staff);
        }

        // Populate Dining Tables
        for (var row in diningTablesTable!.rows) {
          DiningTable diningTable = DiningTable.fromIterable(row.map((e) => e?.value));
          EateryDB.instance.diningTableBox!.put(diningTable.id, diningTable);
        }

        // Populate Dining Table Categories
        for (var row in diningTableCategoriesTable!.rows) {
          DiningTableCategory diningTableCategory = DiningTableCategory.fromIterable(row.map((e) => e?.value));
          EateryDB.instance.diningTableCategoryBox!.put(diningTableCategory.id, diningTableCategory);
        }

        // Populate Customers
        for (var row in customersTable!.rows) {
          Customer customer = Customer.fromIterable(row.map((e) => e?.value));
          EateryDB.instance.customerBox!.put(customer.id, customer);
        }

        // Populate Orders
        for (var row in ordersTable!.rows) {
          Order order = Order.fromIterable(row.map((e) => e?.value));
          EateryDB.instance.orderBox!.put(order.id, order);
        }

        showMessageDialog(this.context, 'Imported successfully', MessageType.success);

      } else {
        // User canceled the picker
      }
    });
  }

  Future<void> doExportProducts() async {
    // Create excel
    var excel = Excel.createExcel();

    // Remove default sheet
    if(excel.getDefaultSheet() != null) {
      excel.delete(excel.getDefaultSheet()!);
    }

    // Create sheets
    var customersSheet = excel['Customers'];
    var diningTablesSheet = excel['Dining Tables'];
    var diningTableCategoriesSheet = excel['Dining Table Categories'];
    var ordersSheet = excel['Orders'];
    var productsSheet = excel['Products'];
    var productCategoriesSheet = excel['Product Categories'];
    var taxSlabsSheet = excel['Tax Slabs'];
    var staffsSheet = excel['Staffs'];

    // Initialize index
    int index = 0;

    // Populate Customers Sheet
    index = 0;
    for (var element in EateryDB.instance.customerBox!.values) {
      customersSheet.insertRowIterables(element.toMap().values.toList(), index);
      index++;
    }

    // Populate Dining Tables Sheet
    index = 0;
    for (var element in EateryDB.instance.diningTableBox!.values) {
      diningTablesSheet.insertRowIterables(
          element.toMap().values.toList(), index);
      index++;
    }

    // Dining Table Categories Sheet
    index = 0;
    for (var element in EateryDB.instance.diningTableCategoryBox!.values) {
      diningTableCategoriesSheet.insertRowIterables(
          element.toMap().values.toList(), index);
      index++;
    }

    // Populate Orders Sheet
    index = 0;
    for (var element in EateryDB.instance.orderBox!.values) {
      ordersSheet.insertRowIterables(element.toMap().values.toList(), index);
      index++;
    }

    // Populate Products Sheet
    index = 0;
    for (var element in EateryDB.instance.productBox!.values) {
      productsSheet.insertRowIterables(element.toMap().values.toList(), index);
      index++;
    }

    // Populate Product Categories Sheet
    index = 0;
    for (var element in EateryDB.instance.productCategoryBox!.values) {
      productCategoriesSheet.insertRowIterables(
          element.toMap().values.toList(), index);
      index++;
    }

    // Populate Tax Slabs Sheet
    index = 0;
    for (var element in EateryDB.instance.taxSlabBox!.values) {
      taxSlabsSheet.insertRowIterables(element.toMap().values.toList(), index);
      index++;
    }

    // Populate Staffs Sheet
    index = 0;
    for (var element in EateryDB.instance.staffBox!.values) {
      staffsSheet.insertRowIterables(element.toMap().values.toList(), index);
      index++;
    }

    excel.setDefaultSheet(productsSheet.sheetName);
    String filename = 'EXPORT-${DateTime.now().millisecondsSinceEpoch}.xlsx';
    var downloadsPath = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);

    String filePath = join(downloadsPath, filename);

    List<int> bytes = excel.encode()!;
    File(filePath)
        .writeAsBytes(bytes)
        .then((value) => showMessageDialog(this.context, 'Exported successfully', MessageType.success))
        .onError((error, stackTrace) => showMessageDialog(this.context, 'Export failed', MessageType.error));
  }
  */

  Future<void> _downloadDemoData(BuildContext context) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show();
    List<String> logs = [];

    String baseUrl =
        'https://raw.githubusercontent.com/devstroop/eatery_sample_data/main';

    // Customers
    try {
      pd.update(msg: '⏳ Downloading Customers');
      Iterable<Map<String, dynamic>> list =
          await getList('$baseUrl/customers.json');
      pd.update(msg: '⌛️ Saving Customers');
      logs.add('🛢️ Customers');
      Iterable<Customer> custs = list.map((element) {
        try {
          final msg = '\t👤 ${element['name']} downloaded';
          logs.add(msg);
          pd.update(msg: msg);
          return Customer.fromMap(element);
        } catch (e) {
          final msg = '\t❌ Error downloading 👤 ${element['name']}: $e';
          logs.add(msg);
          pd.update(msg: msg);
          return Customer(phone: element['phone']);
        }
      });
      await EateryDB.instance.customerBox!.clear();
      await EateryDB.instance.customerBox!.addAll(custs);
      final msg = '✅ ${custs.length} Customers downloaded successfully';
      logs.add(msg);
      pd.update(msg: msg);
    } catch (e) {
      final msg = '❌ Error downloading Customers: $e';
      logs.add(msg);
      pd.update(msg: msg);
    }

    // Dining Table Categories
    try {
      pd.update(msg: '⏳ Downloading Dining Table Categories');
      Iterable<Map<String, dynamic>> list =
          await getList('$baseUrl/dining_table_categories.json');
      pd.update(msg: '⌛️ Saving Dining Table Categories');
      logs.add('🛢️ Dining Table Categories');
      Iterable<DiningTableCategory> dtCats = list.map((element) {
        try {
          final msg = '\t📖 ${element['name']} downloaded successfully';
          logs.add(msg);
          pd.update(msg: msg);
          return DiningTableCategory.fromMap(element);
        } catch (e) {
          final msg = '\t❌ Error downloading ${element['name']}: $e';
          logs.add(msg);
          pd.update(msg: msg);
          return DiningTableCategory(name: element['name']);
        }
      });
      await EateryDB.instance.diningTableCategoryBox!.clear();
      await EateryDB.instance.diningTableCategoryBox!.addAll(dtCats);
      final msg =
          '✅ ${dtCats.length} Dining Table Categories downloaded successfully';
      logs.add(msg);
      pd.update(msg: msg);
    } catch (e) {
      final msg = '❌ Error downloading Dining Table Categories: $e';
      logs.add(msg);
      pd.update(msg: msg);
    }

    // Dining Tables
    try {
      pd.update(msg: '⏳ Downloading Dining Tables');
      Iterable<Map<String, dynamic>> list =
          await getList('$baseUrl/dining_tables.json');
      pd.update(msg: '⌛️ Saving Dining Tables');
      logs.add('🛢️ Dining Tables');
      Iterable<DiningTable> diningTables = list.map((element) {
        try {
          final msg = '\t🍽️ ${element['name']} downloaded successfully';
          logs.add(msg);
          pd.update(msg: msg);
          return DiningTable.fromMap(element);
        } catch (e) {
          final msg = '\t❌ Error downloading ${element['name']}: $e';
          logs.add(msg);
          pd.update(msg: msg);
          return DiningTable(name: element['name']);
        }
      });
      await EateryDB.instance.diningTableBox!.clear();
      await EateryDB.instance.diningTableBox!.addAll(diningTables);
      final msg =
          '✅ ${diningTables.length} Dining Tables downloaded successfully';
      logs.add(msg);
      pd.update(msg: msg);
    } catch (e) {
      final msg = '❌ Error downloading Dining Tables: $e';
      logs.add(msg);
      pd.update(msg: msg);
    }

    // Orders
    try {
      pd.update(msg: '⏳ Downloading Orders');
      Iterable<Map<String, dynamic>> ordersList =
          await getList('$baseUrl/orders.json');
      pd.update(msg: '⌛️ Saving Orders');
      logs.add('🛢️ Orders');
      Iterable<Order> orders = ordersList.map((element) {
        try {
          final msg = '\t📦 ${element['id']} downloaded successfully';
          logs.add(msg);
          pd.update(msg: msg);
          return Order.fromMap(element);
        } catch (e) {
          final msg = '\t❌ Error downloading ${element['id']}: $e';
          logs.add(msg);
          pd.update(msg: msg);
          rethrow;
        }
      });
      await EateryDB.instance.orderBox!.clear();
      await EateryDB.instance.orderBox!.addAll(orders);
      final msg = '✅ ${orders.length} Orders downloaded successfully';
      logs.add(msg);
      pd.update(msg: msg);
    } catch (e) {
      final msg = '❌ Error downloading Orders: $e';
      logs.add(msg);
      pd.update(msg: msg);
    }

    // Payments
    try {
      pd.update(msg: '⏳ Downloading Payments');
      Iterable<Map<String, dynamic>> paymentsList =
          await getList('$baseUrl/payments.json');
      pd.update(msg: '⌛️ Saving Payments');
      logs.add('🛢️ Payments');
      Iterable<Payment> payments = paymentsList.map((element) {
        try {
          final msg = '\t💰 ${element['id']} downloaded successfully';
          logs.add(msg);
          pd.update(msg: msg);
          return Payment.fromMap(element);
        } catch (e) {
          final msg = '\t❌ Error downloading ${element['id']}: $e';
          logs.add(msg);
          pd.update(msg: msg);
          rethrow;
        }
      });
      await EateryDB.instance.paymentBox!.clear();
      await EateryDB.instance.paymentBox!.addAll(payments);
      final msg = '✅ ${payments.length} Payments downloaded successfully';
      logs.add(msg);
      pd.update(msg: msg);
    } catch (e) {
      final msg = '❌ Error downloading Payments: $e';
      logs.add(msg);
      pd.update(msg: msg);
    }

    // Product Categories
    try {
      pd.update(msg: '⏳ Downloading Product Categories');
      Iterable<Map<String, dynamic>> productCategoriesList =
          await getList('$baseUrl/product_categories.json');
      pd.update(msg: '⌛️ Saving Categories');
      logs.add('🛢️ Product Categories');
      Iterable<ProductCategory> categories =
          productCategoriesList.map((element) {
        try {
          final msg = '\t📖 ${element['name']} downloaded successfully';
          logs.add(msg);
          pd.update(msg: msg);
          return ProductCategory.fromMap(element);
        } catch (e) {
          final msg = '\t❌ Error downloading ${element['name']}: $e';
          logs.add(msg);
          pd.update(msg: msg);
          return ProductCategory(name: element['name']);
        }
      });
      await EateryDB.instance.productCategoryBox!.clear();
      await EateryDB.instance.productCategoryBox!.addAll(categories);
      final msg =
          '✅ ${categories.length} Product Categories downloaded successfully';
      logs.add(msg);
      pd.update(msg: msg);
    } catch (e) {
      final msg = '❌ Error downloading Product Categories: $e';
      logs.add(msg);
      pd.update(msg: msg);
    }

    // Products
    try {
      pd.update(msg: '⏳ Downloading Products');
      Iterable<Map<String, dynamic>> productsList =
          await getList('$baseUrl/products.json');
      pd.update(msg: '⌛️ Saving Products');
      logs.add('🛢️ Products');
      Iterable<Product> products = productsList.map((element) {
        try {
          final msg = '\t⌗ ${element['name']} downloaded successfully';
          logs.add(msg);
          pd.update(msg: msg);
          return Product.fromMap(element);
        } catch (e) {
          final msg = '\t❌ Error downloading ${element['name']}: $e';
          logs.add(msg);
          pd.update(msg: msg);
          return Product(
              name: element['name'],
              mrpPrice: 0.0,
              salePrice: 0.0,
              type: ProductType.inventoryItem,
              isActive: false);
        }
      });
      await EateryDB.instance.productBox!.clear();
      await EateryDB.instance.productBox!.addAll(products);
      final msg = '✅ ${products.length} Products downloaded successfully';
      logs.add(msg);
      pd.update(msg: msg);
    } catch (e) {
      final msg = '❌ Error downloading Products: $e';
      logs.add(msg);
      pd.update(msg: msg);
    }

    // Staffs
    try {
      pd.update(msg: '⏳ Downloading Staffs');
      Iterable<Map<String, dynamic>> staffsList =
          await getList('$baseUrl/staffs.json');
      pd.update(msg: '⌛️ Saving Staffs');
      logs.add('🛢️ Staffs');
      Iterable<Staff> staffs = staffsList.map((element) {
        try {
          final msg = '\t👨🏻‍🔧 ${element['name']} downloaded successfully';
          logs.add(msg);
          pd.update(msg: msg);
          return Staff.fromMap(element);
        } catch (e) {
          final msg = '\t❌ Error downloading ${element['name']}: $e';
          logs.add(msg);
          pd.update(msg: msg);
          return Staff(
              name: element['name'], type: StaffType.other, isActive: false);
        }
      });
      await EateryDB.instance.staffBox!.clear();
      await EateryDB.instance.staffBox!.addAll(staffs);
      final msg = '✅ ${staffs.length} Staffs downloaded successfully';
      logs.add(msg);
      pd.update(msg: msg);
    } catch (e) {
      final msg = '❌ Error downloading Staffs: $e';
      logs.add(msg);
      pd.update(msg: msg);
    }

    // Tax Slabs
    try {
      pd.update(msg: '⏳ Downloading Tax Slabs');
      Iterable<Map<String, dynamic>> taxSlabsList =
          await getList('$baseUrl/tax_slabs.json');
      pd.update(msg: '⌛️ Saving Tax Slabs');
      logs.add('🛢️ Tax Slabs');
      Iterable<TaxSlab> taxSlabs = taxSlabsList.map((element) {
        try {
          final msg = '\t％ ${element['name']} downloaded successfully';
          logs.add(msg);
          pd.update(msg: msg);
          return TaxSlab.fromMap(element);
        } catch (e) {
          final msg = '\t❌ Error downloading ${element['name']}: $e';
          logs.add(msg);
          pd.update(msg: msg);
          return TaxSlab(
              name: element['name'], rate: 0.0, type: TaxType.exclusive);
        }
      });
      await EateryDB.instance.taxSlabBox!.clear();
      await EateryDB.instance.taxSlabBox!.addAll(taxSlabs);
      final msg = '✅ ${taxSlabs.length} Tax Slabs downloaded successfully';
      logs.add(msg);
      pd.update(msg: msg);
    } catch (e) {
      final msg = '❌ Error downloading Tax Slabs: $e';
      logs.add(msg);
      pd.update(msg: msg);
    }

    //

    pd.update(msg: 'Done');
    pd.close(delay: 99);
    Future.delayed(const Duration(milliseconds: 100), () {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Log'),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [...logs.map((e) => Text('$e\n '))],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  Future<Iterable<Map<String, dynamic>>> getList(String customersUrl) async {
    try {
      http.Response response = await http.get(Uri.parse(customersUrl));
      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List<dynamic>)
            .map<Map<String, dynamic>>((e) => e);
      }
    } catch (e) {
      print(e);
    }
    return [];
  }
}
