import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:eatery/components/dialog_box.dart';
import 'package:eatery/components/menu_tile.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery/constants/style/color_style.dart';
import 'package:eatery_db/eatery_db.dart';

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
            showSnackBar(context, 'Failed to add ${index + 1}th row');
          }
        }
        showSnackBar(context, "Imported successfully");
      } else {
        // User canceled the picker
      }
    });
  }

  Future<void> doExportProducts() async {
    var excel = Excel.createExcel();
    var sheet = excel[excel.getDefaultSheet()!];
    debugPrint('Exporting products ${sheet.maxCols} ${sheet.maxRows}');
    /*   List<Map<String, dynamic>> products = await Product.getAll();

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
        .value = 'productname';
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0))
        .value = 'categoryid';
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0))
        .value = 'description';
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0))
        .value = 'price';
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0))
        .value = 'foodtype(veg/nonVeg)';
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 0))
        .value = 'taxtype(inclusive/exclusive)';
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 0))
        .value = 'tax_slab';
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 0))
        .value = 'as(dish/item)';

    int index = 1;
    for(Map<String, dynamic> product in products) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: index))
          .value = product['name'];
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: index))
          .value = product['category'];
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: index))
          .value = product['description'];
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: index))
          .value = product['price'];
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: index))
          .value = product['foodType'];
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: index))
          .value = product['taxType'];
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: index))
          .value = product['tax_slab'];
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: index))
          .value = product['as'];
    }
    String filePath = '${await AppFileSystem.getExportDir()}/export-${getRandomString(8)}.xlsx';
    File(filePath).writeAsBytes(excel.encode()!);*/

    showSnackBar(context, "Exported successfully");
    showDialog(
      context: context,
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
          onTap: () {
            Focus.of(context).unfocus();
          },
          child: MenuTile(
            prefixIcon: Icons.input,
            title: 'Import Products',
            subtitle: 'Import invoices and vouchers',
            postfixIcon: Icons.arrow_forward_ios_sharp,
            color: getThemeColor(),
            onTap: doImportProducts,
          ),
        ),
        InkWell(
          onTap: () {
            Focus.of(context).unfocus();
          },
          child: MenuTile(
            prefixIcon: Icons.output,
            title: 'Export Products',
            subtitle: 'Export invoices and vouchers',
            postfixIcon: Icons.arrow_forward_ios_sharp,
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
