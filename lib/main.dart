import 'package:eatery/references.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await setupDirectory();
  await EateryDB.instance.init();
  await EateryDB.instance.waitUntilInitialized();
  runApp(const MyApp());
}

Future setupDirectory() async {
  String basePath = '';
  if (Platform.isAndroid) {
    basePath = (await getApplicationDocumentsDirectory()).path;
  } else if (Platform.isIOS) {
    basePath = (await getApplicationDocumentsDirectory()).path;
  } else {
    throw Exception('Unsupported platform');
  }

  GlobalVariables.baseDirectory = basePath;
  EateryDB.dataDir = GlobalVariables.dataDirectory;
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
  await EateryDB.instance.staffBox.clear();

  return;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove(); // remove splash
    return MaterialApp(
        title: 'Eatery',
        debugShowCheckedModeBanner: false,
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
