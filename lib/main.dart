import 'package:eatery/references.dart';

Future main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding); // bind splash
  // await setupPermission();
  await setupDirectory();
  await setupDatabase();
  await initSharedPrefs();

  // TODO: Uncomment to flush companies7/
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
  debugPrint(GlobalVariables.baseDirectory);
}

Future setupDatabase() async {
  await EateryDB.instance.connectDB(GlobalVariables.dataDirectoryAbs);
  return;
}

SharedPreferences? sharedPreferences;
Future<void> flushDatabase({bool confirm = false}) => EateryDB.instance.clearDB(confirm: confirm);
Future initSharedPrefs() async {
  sharedPreferences = await SharedPreferences.getInstance();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool onBoarded = sharedPreferences?.getBool('onBoarded') ?? false;
    FlutterNativeSplash.remove(); // remove splash
    return MaterialApp(
        title: 'Eatery',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
        ),
        home: onBoarded ? Scaffold(
          body: EateryDB.instance.companyBox.values.isNotEmpty
              ? const LoginPage()
              : const CreateCompanyPage(),
        ) : const OnboardingPage()
        // home: const OnboardingPage()
        );
  }
}
