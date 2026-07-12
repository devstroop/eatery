import 'dart:async';

import 'package:eatery/core/router/app_router.dart';
import 'package:eatery/core/theme/app_theme.dart';
import 'package:eatery/constants/utils/app_file_system.dart';
import 'package:eatery/data/database/eatery_database.dart';
import 'package:eatery/data/database/eatery_db_shim.dart';
import 'package:eatery/presentation/providers/database_provider.dart';
import 'package:eatery/references.dart';
import 'package:flutter/services.dart';
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
  await AppFileSystem.init(basePath);

  // Initialize the injectable database
  appDatabase = EateryDatabase(dataDir: AppFileSystem.dataDir);
  await appDatabase.init();

  // Bind legacy shim so EateryDB.instance still works
  EateryDB.bind(appDatabase);

  await FastCachedImageConfig.init(
    subDir: '${AppFileSystem.cacheDir}/',
    clearCacheAfter: const Duration(days: 15),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    if (appDatabase.isInitialized) {
      return _KeyboardStateSync(
        child: MaterialApp.router(
          title: 'Eatery',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          routerConfig: createAppRouter(appDatabase),
        ),
      );
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Initializing database...'),
            ],
          ),
        ),
      ),
    );
  }
}

/// Resets [HardwareKeyboard] state when the app returns to foreground.
///
/// Flutter desktop (especially macOS) loses [KeyUpEvent]s when the window
/// loses focus. The stale pressed-key state causes subsequent keystrokes
/// to be silently dropped. This widget syncs the framework's keyboard
/// state with the engine on every [AppLifecycleState.resumed] transition.
class _KeyboardStateSync extends StatefulWidget {
  const _KeyboardStateSync({required this.child});

  final Widget child;

  @override
  State<_KeyboardStateSync> createState() => _KeyboardStateSyncState();
}

class _KeyboardStateSyncState extends State<_KeyboardStateSync>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      HardwareKeyboard.instance.syncKeyboardState();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
