import 'dart:io';

import 'package:eatery/constants/global_variables.dart';
import 'package:eatery/pages/create_company/create_company_page.dart';
import 'package:eatery_db/eatery_db.dart';
import 'package:eatery_services/eatery_services.dart';
import 'package:flutter/material.dart';
import 'package:eatery/pages/auth/login_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding); // bind splash
  await setupPermission();
  await setupDatabase();

  runApp(const MyApp());
}


Future setupDatabase() async {
  // Storage Permission Required
  // String dataDirectory = await AppFileSystem.getDataDir();
  Directory dataDirectory = await getApplicationSupportDirectory();
  await EateryDB().init(dataDirectory.path);
  return;
}

Future setupPermission() async {
  // setup permission
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
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: EateryDB().companyBox().isNotEmpty
              ? const LoginPage()
              : const CreateCompanyPage(),
        ));
  }
}
