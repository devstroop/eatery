import 'package:eatery/references.dart';
import 'package:googleapis/chat/v1.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Implement permission check
  if(!(await Permission.storage.isGranted)) {
    await Permission.storage.request();
  } else if((await Permission.storage.isPermanentlyDenied)) {
    await openAppSettings();
  }
  if(!(await Permission.manageExternalStorage.isGranted)) {
    await Permission.manageExternalStorage.request();
  } else if((await Permission.manageExternalStorage.isPermanentlyDenied)) {
    await openAppSettings();
  }
  if(!(await Permission.camera.isGranted)) {
    await Permission.camera.request();
  } else if((await Permission.camera.isPermanentlyDenied)) {
    await openAppSettings();
  }
  if(!(await Permission.location.isGranted)) {
    await Permission.location.request();
  } else if((await Permission.location.isPermanentlyDenied)) {
    await openAppSettings();
  }

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

  Common.baseDirectory = basePath;
  await EateryDB.instance.init(Common.dataDirectory).onError((error, stackTrace) => throw Exception('Error initializing DB: $error'));
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
