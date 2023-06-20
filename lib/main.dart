import 'dart:io';
import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';
import 'package:eatery/pages/auth/login_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'constants/global_variables.dart';
import 'pages/create_company/create_company_page.dart';

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
  GlobalVariables.rootDirectory = await getApplicationSupportDirectory();
  GlobalVariables.dataDirectory =
      Directory('${GlobalVariables.rootDirectory?.path}/data');
  GlobalVariables.resourcesDirectory =
      Directory('${GlobalVariables.rootDirectory?.path}/resources');
  GlobalVariables.backupDirectory =
      Directory('${GlobalVariables.rootDirectory?.path}/backup');
  if (!await GlobalVariables.dataDirectory!.exists()) {
    await GlobalVariables.dataDirectory!.create();
  }
  if (!await GlobalVariables.resourcesDirectory!.exists()) {
    await GlobalVariables.resourcesDirectory!.create();
  }
  if (!await GlobalVariables.backupDirectory!.exists()) {
    await GlobalVariables.backupDirectory!.create();
  }
  // TODO: Remove debug tag
  debugPrint(GlobalVariables.rootDirectory?.path);
  return;
}

Future setupDatabase() async {
  await EateryDB.instance.init(GlobalVariables.dataDirectory?.path);
  return;
}

Future flushDatabase() async {
  await EateryDB.instance.companyBox.clear();
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
