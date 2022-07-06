import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_pos/components/menu_tile.dart';
import 'package:restaurant_pos/database/product.dart';
import 'package:restaurant_pos/services/utility/show_snack_bar.dart';
import 'package:restaurant_pos/style/color_style.dart';

class ImportExportPage extends StatefulWidget {
  const ImportExportPage({Key? key, this.account}) : super(key: key);
  final dynamic account;

  @override
  State<ImportExportPage> createState() => _ImportExportPageState();
}

class _ImportExportPageState extends State<ImportExportPage> {

  Future<void> doImportProducts() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xls', 'xlsx']
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      int index = 0;
      for (var table in excel.tables.keys) {
        for (List<Data?> row in excel.tables[table]!.rows) {
          try{
            Map<String, dynamic> product = {};
            product['name'] = row[0]!.value;
            product['category'] = row[1]!.value;
            product['description'] = row[2]!.value;
            product['price'] = double.parse(row[3]!.value);
            product['foodType'] = row[4]!.value;
            product['taxType'] = row[5]!.value;
            product['tax'] = double.parse(row[6]!.value);
            product['as'] = row[7]!.value;
            await Product.add(product);
          }
          catch(_){
            showSnackBar(context, 'Failed to add $index');
          }
          index++;
        }
      }
      showSnackBar(context, "Imported successfully");
    } else {
      // User canceled the picker
    }
  }
  Future<void> doExportProducts() async{
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an export file:',
      fileName: 'product_export.pdf',
    );
    if (outputFile != null) {
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['products'];
      List<Map<String, dynamic>> products = await Product.getAll();
      int index = 1;
      for(Map<String, dynamic> product in products){
        var cell = sheetObject.cell(CellIndex.indexByString("A$index"));
        cell.value = product['name'];
        cell = sheetObject.cell(CellIndex.indexByString("B$index"));
        cell.value = product['category'];
        cell = sheetObject.cell(CellIndex.indexByString("C$index"));
        cell.value = product['description'];
        cell = sheetObject.cell(CellIndex.indexByString("D$index"));
        cell.value = product['price'];
        cell = sheetObject.cell(CellIndex.indexByString("E$index"));
        cell.value = product['foodType'];
        cell = sheetObject.cell(CellIndex.indexByString("F$index"));
        cell.value = product['taxType'];
        cell = sheetObject.cell(CellIndex.indexByString("G$index"));
        cell.value = product['tax'];
        cell = sheetObject.cell(CellIndex.indexByString("H$index"));
        cell.value = product['as'];
      }
      excel.save(fileName: outputFile);
      showSnackBar(context, "Exported successfully");
    }else{
      // User cancelled the picker
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Color getThemeColor() {
    return ColorStyle.tertiary;
  }

  SizedBox options(){
    return SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: ListView(scrollDirection: Axis.vertical, shrinkWrap: true, children: [
        InkWell(
          onTap: () { },
          child: MenuTile(
            prefixIcon: Icons.input, title: 'Import Products', subtitle: 'Import invoices and vouchers', postfixIcon: Icons.arrow_forward_ios_sharp, color: getThemeColor(),
            onTap: doImportProducts,
          ),
        ),
        InkWell(
          onTap: () { },
          child: MenuTile(
            prefixIcon: Icons.output, title: 'Export Products', subtitle: 'Export invoices and vouchers', postfixIcon: Icons.arrow_forward_ios_sharp, color: getThemeColor(),
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
          Positioned(top: 12.0, left: 0.0, right: 0.0, bottom: 72, child: options()),
        ],
      ),
    );
  }
}
