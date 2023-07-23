import 'package:eatery/references.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await setupDataAndInitDB();
  runApp(const MyApp());
}

Future setupDataAndInitDB() async {
  String basePath = '';
  if (Platform.isAndroid) {
    basePath = (await getApplicationDocumentsDirectory()).path;
  } else if (Platform.isIOS) {
    basePath = (await getApplicationDocumentsDirectory()).path;
  } else {
    throw Exception('Unsupported platform');
  }

  GlobalVariables.baseDirectory = basePath;
  await EateryDB.instance.init(GlobalVariables.dataDirectory);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MaterialApp(
        title: 'Eatery',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: EateryDB.instance.companyBox!.isNotEmpty
              ? const LoginPage()
              : const CreateCompanyPage(),
        ));
  }
}
