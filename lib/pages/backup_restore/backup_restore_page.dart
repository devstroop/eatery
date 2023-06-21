import 'package:eatery/services/cloud/google_drive.dart';
import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';
import 'package:eatery/components/menu_tile.dart';
import 'package:eatery/constants/utils/app_file_system.dart';
import 'package:eatery/services/utility/show_snack_bar.dart';
import 'package:eatery/constants/style/color_style.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:uicons/uicons.dart';

class BackupRestorePage extends StatefulWidget {
  const BackupRestorePage({Key? key, this.company}) : super(key: key);
  final Company? company;
  @override
  State<BackupRestorePage> createState() => _BackupRestorePageState();
}

class _BackupRestorePageState extends State<BackupRestorePage> {
  final drive = GoogleDrive();
  bool inProgress = false;

  Future<void> doBackUp() async {
    ProgressDialog pd = ProgressDialog(context: context);
    setState(() {
      inProgress = true;
    });
    pd.show(
      max: 100,
      msg: 'Backup in progress',
      progressBgColor: Colors.transparent,
      progressValueColor: getThemeColor(),
      completed: Completed(),
    );

    /*Map<String, List<Map<String, dynamic>>> backup = {
      "accounts": await Account.getAll(),
      "diningTables": await DiningTable.getAll(),
      "diningTableCategories": await DiningTableCategory.getAll(),
      "orders": await Order.getAll(),
      "products": await Product.getAll(),
      "productCategories": await ProductCategoryOld.getAll(),
      "waiters": await Waiter.getAll(),
    };*/
    /*pd.update(value: 20, msg: "Packing data");
    await AppFileSystem.saveBackupFile(backupData: backup, backupFilePath: '${await AppFileSystem.getBackupDir()}/backup.json');
    pd.update(value: 40, msg: "Packing resources");
    await AppFileSystem.doZip(dataDirPath: await AppFileSystem.getResourcesDir(), zipFilePath: '${await AppFileSystem.getBackupDir()}/resources.zip');
    pd.update(value: 80, msg: "Uploading data");*/

    /*if(widget.account['backupIds'] != null && (widget.account['backupIds'] as List<dynamic>).isNotEmpty){
      ga.File file1 = await drive.update(File('${await AppFileSystem.getBackupDir()}/backup.json'), widget.account['backupIds'][0]!);
      pd.update(value: 90, msg: "Uploading resources");
      ga.File file2 = await drive.update(File('${await AppFileSystem.getBackupDir()}/resources.zip'), widget.account['backupIds'][1]!);
    }
    else{
      ga.File file1 = await drive.upload(File('${await AppFileSystem.getBackupDir()}/backup.json'));
      pd.update(value: 90, msg: "Uploading resources");
      ga.File file2 = await drive.upload(File('${await AppFileSystem.getBackupDir()}/resources.zip'));
      setState((){
        widget.account['backupIds'] = [file1.id, file2.id];
      });
    }




    pd.update(value: 100, msg: "Finishing");
    await Account.update(widget.account);
    pd.close();


    setState((){
      inProgress = false;
    });
    showSnackBar(context, "Backup done");*/
  }

  void doRestore() async {
    ProgressDialog pd = ProgressDialog(context: context);
    setState(() {
      inProgress = true;
    });
    pd.show(
      max: 100,
      msg: 'Restore in progress',
      progressBgColor: Colors.transparent,
      progressValueColor: getThemeColor(),
      completed: Completed(),
    );

    /*Map<String, dynamic>? account = await Account.get(widget.account['id']);

    List<ga.File> files = await drive.download((account!['backupIds']));
    for(ga.File file in files){
      // file.
      print(file.toJson());
    }*/

    Map<String, dynamic> data = await AppFileSystem.readBackupFile(
        backupFilePath: '${await AppFileSystem.getBackupDir()}/backup.json');
    await AppFileSystem.doUnZip(
        dataDirPath: await AppFileSystem.getResourcesDir(),
        zipFilePath: '${await AppFileSystem.getBackupDir()}/resources.zip');

    // await Account.clear();
    // await DiningTable.clear();
    // await DiningTableCategory.clear();
    // await Order.clear();
    // await Product.clear();
    // await ProductCategoryOld.clear();
    // await Waiter.clear();

    pd.update(value: 10);
    for (Map<String, dynamic> account in data['accounts']) {
      // await Account.add(account);
    }
    pd.update(value: 20);
    for (Map<String, dynamic> diningTable in data['diningTables']) {
      // await DiningTable.add(diningTable);
    }
    pd.update(value: 30);
    for (Map<String, dynamic> diningTableCategory
        in data['diningTableCategories']) {
      // await DiningTableCategory.add(diningTableCategory);
    }
    pd.update(value: 40);
    pd.update(value: 50);
    for (Map<String, dynamic> order in data['orders']) {
      // await Order.add(order);
    }
    pd.update(value: 60);
    for (Map<String, dynamic> product in data['products']) {
      // await Product.add(product);
      debugPrint(product.toString());
    }
    pd.update(value: 70);
    for (Map<String, dynamic> productCategory in data['productCategories']) {
      // await ProductCategoryOld.add(productCategory);
      debugPrint(productCategory.toString());
    }
    pd.update(value: 80);
    await Future.delayed(const Duration(seconds: 1), () async {
      for (Map<String, dynamic> waiter in data['waiters']) {
        // await Waiter.add(waiter);
      }
    }).then((value) {
      pd.update(value: 100);
      pd.close();
      setState(() {
        inProgress = false;
      });
      showSnackBar(context, "Restore done");
    });
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
            prefixIcon: UIcons.regularStraight.time_past,
            title: 'Backup',
            subtitle: 'Backup your settings data to Google Drive',
            postfixIcon: UIcons.regularStraight.arrow_small_right,
            color: getThemeColor(),
            onTap: doBackUp,
          ),
        ),
        InkWell(
          onTap: () {},
          child: MenuTile(
            prefixIcon: UIcons.regularStraight.time_forward,
            title: 'Restore',
            subtitle: 'Restore your settings data from Google Drive',
            postfixIcon: UIcons.regularStraight.arrow_small_right,
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
      leading: IconButton(
        icon: Icon(UIcons.regularStraight.arrow_left),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: getThemeColor(),
      foregroundColor: Colors.white,
      title: const Text('Backup / Restore'),
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
