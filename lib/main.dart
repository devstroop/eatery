import 'dart:io';
import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';
import 'package:eatery/pages/authentication/login.page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'constants/global_variables.dart';
import 'pages/createCompany/createCompany.page.dart';

Future main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding); // bind splash
  await setupPermission();
  await setupDirectory();
  await setupDatabase();

  // TODO: Uncomment to flush companies
  // await flushDatabase();

  runApp(const MyApp());
}

Future setupPermission() async {
  // setup permission
  return;
}

Future setupDirectory() async {
  if (Platform.isAndroid) {
    GlobalVariables.baseDirectory =
        (await getApplicationDocumentsDirectory()).path;
  } else if (Platform.isIOS) {
    GlobalVariables.baseDirectory =
        (await getApplicationDocumentsDirectory()).path;
  } else {
    throw Exception('Unsupported platform');
  }
}

Future setupDatabase() async {
  await EateryDB.instance.init(GlobalVariables.dataDirectoryAbs);
  return;
}

Future flushDatabase() async {
  await EateryDB.instance.companyBox.clear();
  await EateryDB.instance.currencyBox.clear();
  await EateryDB.instance.autoPrintBox.clear();
  await EateryDB.instance.customerBox.clear();
  await EateryDB.instance.diningTableBox.clear();
  await EateryDB.instance.diningTableCategoryBox.clear();
  await EateryDB.instance.orderBox.clear();
  await EateryDB.instance.productBox.clear();
  await EateryDB.instance.productCategoryBox.clear();
  await EateryDB.instance.printerBox.clear();
  await EateryDB.instance.printerTypeBox.clear();
  await EateryDB.instance.printerTypeBox.clear();
  await EateryDB.instance.subscriptionBox.clear();
  await EateryDB.instance.subscriptionTypeBox.clear();
  await EateryDB.instance.editionBox.clear();
  await EateryDB.instance.foodTypeBox.clear();
  await EateryDB.instance.taxSlabBox.clear();
  await EateryDB.instance.taxTypeBox.clear();
  await EateryDB.instance.waiterBox.clear();

  return;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove(); // remove splash
    return MaterialApp(
        title: 'Eatery',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: EateryDB.instance.companyBox.isNotEmpty
              ? const LoginPage()
              : const CreateCompanyPage(),
        ));
  }
}
