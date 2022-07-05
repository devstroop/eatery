import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restaurant_pos/components/menu_tile.dart';
import 'package:restaurant_pos/components/pos_category_widget.dart';
import 'package:restaurant_pos/components/product_card.dart';
import 'package:restaurant_pos/components/waiter_card.dart';
import 'package:restaurant_pos/database/account.dart';
import 'package:restaurant_pos/database/dining_table.dart';
import 'package:restaurant_pos/database/dining_table_category.dart';
import 'package:restaurant_pos/database/dish_customization.dart';
import 'package:restaurant_pos/database/order.dart';
import 'package:restaurant_pos/database/product.dart';
import 'package:restaurant_pos/database/product_category.dart';
import 'package:restaurant_pos/database/waiter.dart';
import 'package:restaurant_pos/extensions/app_file_system.dart';
import 'package:restaurant_pos/models/order_type.dart';
import 'package:restaurant_pos/pages/add_waiter_page.dart';
import 'package:restaurant_pos/pages/detailed_history_page.dart';
import 'package:restaurant_pos/pages/edit_waiter_page.dart';
import 'package:restaurant_pos/services/utility/generate.dart';
import 'package:restaurant_pos/services/utility/show_snack_bar.dart';
import 'package:restaurant_pos/style/color_style.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class BackupRestorePage extends StatefulWidget {
  const BackupRestorePage({Key? key, this.account}) : super(key: key);
  final dynamic account;

  @override
  State<BackupRestorePage> createState() => _BackupRestorePageState();
}

class _BackupRestorePageState extends State<BackupRestorePage> {
  bool inProgress = false;


  Future<void> doBackUp() async {

    ProgressDialog pd = ProgressDialog(context: context);
    setState((){
      inProgress = true;
    });
    pd.show(
      max: 100,
      msg: 'Backup in progress',
      progressBgColor: Colors.transparent,
      completed: Completed(),
    );

    Map<String, List<Map<String, dynamic>>> backup = {
      "accounts": await Account.getAll(),
      "diningTables": await DiningTable.getAll(),
      "diningTableCategories": await DiningTableCategory.getAll(),
      "dishCustomizations": await DishCustomization.getAll(),
      "orders": await Order.getAll(),
      "products": await Product.getAll(),
      "productCategories": await ProductCategory.getAll(),
      "waiters": await Waiter.getAll(),
    };
    pd.update(value: 20);
    await AppFileSystem.saveBackupFile(backupData: backup, backupFilePath: '${await AppFileSystem.getBackupDir()}/backup.json');
    pd.update(value: 50);
    await AppFileSystem.doZip(dataDirPath: await AppFileSystem.getResourcesDir(), zipFilePath: '${await AppFileSystem.getBackupDir()}/resources.zip ');
    pd.update(value: 100);

    pd.close();

    setState((){
      inProgress = false;
    });
    showSnackBar(context, "Backup done");
  }
  void doRestore() async {
    ProgressDialog pd = ProgressDialog(context: context);
    setState((){
      inProgress = true;
    });
    pd.show(
      max: 100,
      msg: 'Restore in progress',
      progressBgColor: Colors.transparent,
      completed: Completed(),
    );

    Map<String, dynamic> data = await AppFileSystem.readBackupFile(backupFilePath: '${await AppFileSystem.getBackupDir()}/backup.json');
    await AppFileSystem.doUnZip(dataDirPath: await AppFileSystem.getResourcesDir(), zipFilePath: '${await AppFileSystem.getBackupDir()}/resources.zip ');

    await Account.clear();
    await DiningTable.clear();
    await DiningTableCategory.clear();
    await DishCustomization.clear();
    await Order.clear();
    await Product.clear();
    await ProductCategory.clear();
    await Waiter.clear();

    pd.update(value: 10);
    for(Map<String, dynamic> account in data['accounts']){
      await Account.add(account);
    }
    pd.update(value: 20);
    for(Map<String, dynamic> diningTable in data['diningTables']){
      await DiningTable.add(diningTable);
    }
    pd.update(value: 30);
    for(Map<String, dynamic> diningTableCategory in data['diningTableCategories']){
      await DiningTableCategory.add(diningTableCategory);
    }
    pd.update(value: 40);
    for(Map<String, dynamic> dishCustomization in data['dishCustomizations']){
      await DishCustomization.add(dishCustomization);
    }
    pd.update(value: 50);
    for(Map<String, dynamic> order in data['orders']){
      await Order.add(order);
    }
    pd.update(value: 60);
    for(Map<String, dynamic> product in data['products']){
      await Product.add(product);
    }
    pd.update(value: 70);
    for(Map<String, dynamic> productCategory in data['productCategories']){
      await ProductCategory.add(productCategory);
    }
    pd.update(value: 80);
    for(Map<String, dynamic> waiter in data['waiters']){
      await Waiter.add(waiter);
    }
    pd.update(value: 100);

    pd.close();

    setState((){
      inProgress = false;
    });
    showSnackBar(context, "Restore done");
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
      child: ListView(scrollDirection: Axis.vertical, shrinkWrap: true, children: [
        InkWell(
          onTap: () {},
          child: MenuTile(
            prefixIcon: Icons.backup,
            title: 'Backup',
            subtitle: 'Backup your company data',
            postfixIcon: Icons.arrow_forward_ios_sharp,
            color: getThemeColor(),
            onTap: doBackUp,
          ),
        ),
        InkWell(
          onTap: () {},
          child: MenuTile(
            prefixIcon: Icons.restore,
            title: 'Restore',
            subtitle: 'Restore your company data',
            postfixIcon: Icons.arrow_forward_ios_sharp,
            color: getThemeColor(),
            onTap: doRestore,
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: getThemeColor(),
      title: const Text('Backup / Restore'),
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
