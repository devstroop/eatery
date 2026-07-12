import 'dart:async';

import 'package:eatery/data/database/eatery_database.dart';
import 'package:eatery/data/database/eatery_db_shim.dart';
import 'package:eatery/pages/main.screen.dart';
import 'package:eatery/presentation/providers/database_provider.dart';
import 'package:eatery/references.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The app's single database instance, initialized once at startup.
late final EateryDatabase appDatabase;

void main() async {
  runZonedGuarded(
    () async {
      WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

      // Mobile-only permission checks — harmless on desktop
      if (Platform.isAndroid || Platform.isIOS) {
        if (!(await Permission.storage.isGranted)) {
          await Permission.storage.request();
        } else if ((await Permission.storage.isPermanentlyDenied)) {
          await openAppSettings();
        }
        if (!(await Permission.manageExternalStorage.isGranted)) {
          await Permission.manageExternalStorage.request();
        } else if ((await Permission
            .manageExternalStorage
            .isPermanentlyDenied)) {
          await openAppSettings();
        }
        if (!(await Permission.camera.isGranted)) {
          await Permission.camera.request();
        } else if ((await Permission.camera.isPermanentlyDenied)) {
          await openAppSettings();
        }
        if (!(await Permission.location.isGranted)) {
          await Permission.location.request();
        } else if ((await Permission.location.isPermanentlyDenied)) {
          await openAppSettings();
        }
      }

      await setupDataAndInitDB();
      runApp(
        ProviderScope(
          overrides: [appDatabaseProvider.overrideWithValue(appDatabase)],
          child: const MyApp(),
        ),
      );
    },
    (error, stack) {
      debugPrint('Uncaught error: $error\n$stack');
    },
  );
}

Future setupDataAndInitDB() async {
  String basePath = '';
  if (Platform.isAndroid) {
    basePath = (await getApplicationDocumentsDirectory()).path;
  } else if (Platform.isIOS) {
    basePath = (await getApplicationDocumentsDirectory()).path;
  } else {
    basePath = (await getApplicationSupportDirectory()).path;
  }

  Common.baseDirectory = basePath;

  // Initialize the injectable database
  appDatabase = EateryDatabase(dataDir: Common.dataDirectory!);
  await appDatabase.init();

  // Bind legacy shim so EateryDB.instance still works
  EateryDB.bind(appDatabase);

  await FastCachedImageConfig.init(
    subDir: '${Common.cacheDirectory}/',
    clearCacheAfter: const Duration(days: 15),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MaterialApp(
      title: 'Eatery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, primarySwatch: Colors.blue),
      home: Scaffold(
        body: appDatabase.companyBox.values.isNotEmpty
            ? const LoginPage()
            : const MainScreen(),
      ),
    );
  }
}
