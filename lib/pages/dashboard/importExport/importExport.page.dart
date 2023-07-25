import 'package:excel/excel.dart';
import 'package:eatery/references.dart';
import 'package:get/get.dart';

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
    var excel = Excel.createExcel();
    var sheet = excel[excel.getDefaultSheet()!];
    debugPrint('Exporting products ${sheet.maxCols} ${sheet.maxRows}');

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0)).value = 'Name';
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0)).value = 'Category id';
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0)).value = 'Description';
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0)).value = 'Image';
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0)).value = 'Sale Price';
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 0)).value = 'Mrp Price';
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 0)).value = 'Food Type)';
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 0)).value = 'Product Type';
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: 0)).value = 'Tax Slab';
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: 0)).value = 'is_active';

    List<Product> products = EateryDB.instance.productBox!.values.toList();
    // Populate the data for each product
    for (int index = 0; index < EateryDB.instance.productBox!.values.length ; index++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: index + 1)).value = products[index].name;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: index + 1)).value = products[index].categoryId;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: index + 1)).value = products[index].description;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: index + 1)).value = products[index].image;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: index + 1)).value = products[index].salePrice;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: index + 1)).value = products[index].mrpPrice;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: index + 1)).value = products[index].foodType;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: index + 1)).value = products[index].type;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: index + 1)).value = products[index].taxSlabId;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: index + 1)).value = products[index].isActive;
    }

    // Export category data
    var categorySheet = excel['Categories'];
    // Headers for the Excel file
    categorySheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0)).value = 'Name';
    categorySheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0)).value = 'Description';
    categorySheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0)).value = 'Image';
    List<ProductCategory> categories = EateryDB.instance.productCategoryBox!.values.toList();
    for (int index = 0; index < categories.length; index++) {
      categorySheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: index + 1)).value = categories[index].name;
      categorySheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: index + 1)).value = categories[index].description;
      categorySheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: index + 1)).value = categories[index].image;
      // Add other category data to the corresponding columns as needed
    }

    // Export tax customer data
    var customerSheet = excel['Customers'];
    customerSheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0)).value = 'Name';
    customerSheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0)).value = 'Phone';
    customerSheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0)).value = 'Email';
    customerSheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0)).value = 'Address';
    customerSheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0)).value = 'Landmark';
    customerSheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 0)).value = 'is_active';
    List<Customer> customers = EateryDB.instance.customerBox!.values.toList();
    for (int index = 0; index < customers.length; index++) {
      customerSheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: index + 1)).value = customers[index].name;
      customerSheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: index + 1)).value = customers[index].phone;
      customerSheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: index + 1)).value = customers[index].email;
      customerSheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: index + 1)).value = customers[index].address;
      customerSheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: index + 1)).value = customers[index].landmark?? "";
      customerSheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: index + 1)).value = customers[index].isActive;
    }

    // Export staff data
    var staffSheet = excel['Staff'];
    staffSheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0)).value = 'Name';
    staffSheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0)).value = 'Phone';
    staffSheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0)).value = 'Type';
    staffSheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0)).value = 'Photo';
    staffSheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0)).value = 'is_active';
    List<Staff> staffs = EateryDB.instance.staffBox!.values.toList();
    for (int index = 0; index < staffs.length; index++) {
      staffSheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: index + 1)).value = staffs[index].name;
      staffSheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: index + 1)).value = staffs[index].phone;
      staffSheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: index + 1)).value = staffs[index].type;
      staffSheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: index + 1)).value = staffs[index].photo;
      staffSheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: index + 1)).value = staffs[index].isActive;
      // Add other staff data to the corresponding columns as needed
    }


    String filePath = '${GlobalVariables.importExportDirectory}/exported_products.xlsx';
    List<int> bytes = excel.encode()!;
    await File(filePath).writeAsBytes(bytes);

    showSnackBar(this.context, "Exported successfully");
    showDialog(
      context: this.context,
      builder: (BuildContext context) {
        return DialogBox(
          title: 'Confirm',
          message:
              'Successfully exported all products\nDo you want to share now?',
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel')),
            TextButton(
                onPressed: () async {
                  //await shareFile(filePath, 'Products Sheet', 'Autogenerated by RestaurantPOS');
                },
                child: const Text('Share'))
          ],
        );
      },
    );
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
