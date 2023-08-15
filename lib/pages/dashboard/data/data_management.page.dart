import 'package:excel/excel.dart';
import 'package:eatery/references.dart';

final _pageColor = KColors.tertiary;

class ImportExportPage extends StatefulWidget {
  const ImportExportPage({Key? key}) : super(key: key);

  @override
  State<ImportExportPage> createState() => _ImportExportPageState();
}

class _ImportExportPageState extends State<ImportExportPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: _pageColor,
      foregroundColor: Colors.white,
      title: const Text('Import / Export'),
    );

    return Scaffold(
      appBar: appBar,
      body: ListView(scrollDirection: Axis.vertical, children: [
        ListTile(
          leading: Icon(
            Icons.file_download_outlined,
            color: _pageColor,
          ),
          title: Text(
            'Import',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: _pageColor),
          ),
          subtitle: Text(
            'Import data from json/excel file',
            style: TextStyle(color: Colors.grey[700]),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ImportPage(), fullscreenDialog: true,))
        ),
        ListTile(
          leading: Icon(
            Icons.file_upload_outlined,
            color: _pageColor,
          ),
          title: Text(
            'Export',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: _pageColor),
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
}
