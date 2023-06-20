import 'dart:io';
import 'package:eatery_db/eatery_db.dart';
import 'package:flutter/material.dart';
import 'package:eatery/pages/auth/login_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'pages/create_company/create_company_page.dart';

Future main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding); // bind splash
  await setupPermission();
  await setupDatabase();

  // Uncomment to flush company list
  //await flushDatabase();

  runApp(const MyApp());
}

Future setupDatabase() async {
  // Storage Permission Required
  // String dataDirectory = await AppFileSystem.getDataDir();
  Directory dataDirectory = await getApplicationSupportDirectory();
  await EateryDB.instance.init(dataDirectory.path);
  return;
}

Future setupPermission() async {
  // setup permission
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
