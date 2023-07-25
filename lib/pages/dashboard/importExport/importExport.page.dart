import 'package:excel/excel.dart';
import 'package:eatery/references.dart';

class ImportExportPage extends StatefulWidget {
  const ImportExportPage({Key? key}) : super(key: key);

  @override
  State<ImportExportPage> createState() => _ImportExportPageState();
}

class _ImportExportPageState extends State<ImportExportPage> {
  Future<void> doImportProducts() async {
    await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xls', 'xlsx']).then((result) {
      if (result != null) {
        File file = File(result.files.single.path!);
        var bytes = file.readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);

        List<List<Data?>> rows = excel.tables[0]!.rows;
        for (int index = 1; index < rows.length; index++) {
          try {
            Map<String, dynamic> product = {};
            product['name'] = rows[index][0]!.value;
            product['category'] = rows[index][1]!.value;
            product['description'] = rows[index][2]!.value;
            product['price'] = double.parse(rows[index][3]!.value.toString());
            product['foodType'] = rows[index][4]!.value;
            product['taxType'] = rows[index][5]!.value;
            product['tax_slab'] =
                double.parse(rows[index][6]!.value.toString());
            product['as'] = rows[index][7]!.value;
            //await Product.add(product);
          } catch (_) {
            showSnackBar(this.context, 'Failed to add ${index + 1}th row');
          }
        }
        showSnackBar(this.context, "Imported successfully");
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
    var printersSheet = excel['Printers'];
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

    // Populate Printers Sheet
    index = 0;
    for (var element in EateryDB.instance.printerBox!.values) {
      printersSheet.insertRowIterables(element.toMap().values.toList(), index);
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
    String filePath =
        '${GlobalVariables.importExportDirectory}/$filename';
    List<int> bytes = excel.encode()!;
    File(filePath)
        .writeAsBytes(bytes)
        .then((value) => showSnackBar(this.context, 'Exported successfully as `$filename`'))
        .onError((error, stackTrace) =>
            showSnackBar(this.context, 'Failed to export'));
  }

  @override
  void initState() {
    super.initState();
  }

  Color getThemeColor() {
    return ColorStyle.tertiary;
  }

  SizedBox options() {
    return SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child:
          ListView(scrollDirection: Axis.vertical, shrinkWrap: true, children: [
        InkWell(
          onTap: () {},
          child: MenuTile(
            prefixIcon: Icons.get_app,
            title: 'Import Products',
            subtitle: 'Import invoices and vouchers',
            postfixIcon: Icons.chevron_right,
            color: getThemeColor(),
            onTap: doImportProducts,
          ),
        ),
        InkWell(
          onTap: () {},
          child: MenuTile(
            prefixIcon: Icons.upload,
            title: 'Export Products',
            subtitle: 'Export invoices and vouchers',
            postfixIcon: Icons.chevron_right,
            color: getThemeColor(),
            onTap: doExportProducts,
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: getThemeColor(),
      foregroundColor: Colors.white,
      title: const Text('Import / Export'),
    );

    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          Positioned(
              top: 12.0, left: 0.0, right: 0.0, bottom: 72, child: options()),
        ],
      ),
    );
  }
}
