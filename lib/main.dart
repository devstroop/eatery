import 'dart:async';

import 'package:eatery/core/router/app_router.dart';
import 'package:eatery_core/theme/app_theme.dart';
import 'package:eatery_core/utils/device_id.dart';
import 'package:eatery/constants/utils/app_file_system.dart';
import 'package:eatery_core/data/database/eatery_database.dart';
import 'package:eatery_core/data/database/native/eatery_schema.dart';
import 'package:eatery_core/data/database/native/eatery_store.dart';
import 'package:eatery_core/data/database/native/schema_migrator.dart';
import 'package:eatery_core/data/database/native/store_config.dart';
import 'package:eatery_core/data/sync/mdns_service.dart';
import 'package:eatery_core/data/sync/sync_providers.dart';
import 'package:eatery_core/data/sync/sync_host_config.dart';
import 'package:eatery_core/providers/database_provider.dart';
import 'package:eatery_core/providers/role_provider.dart';
import 'package:eatery/references.dart';
import 'package:eatery/functions/order.function.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The native SQLite store, initialized at startup.
EateryStore? appStore;

/// Compatibility database wrapper.
EateryDatabase? appDatabase;

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
          overrides: [
            if (appStore != null)
              eateryStoreProvider.overrideWithValue(appStore!),
            if (appDatabase != null)
              appDatabaseProvider.overrideWithValue(appDatabase!),
          ],
          child: const RoleShell(),
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

  // Open the native SQLite store and initialize the schema.
  if (kUseSqliteStore) {
    final store = EateryStore.open(
      '${AppFileSystem.dataDir}/$kEateryDbFileName',
    );
    final schema = await rootBundle.loadString(kSchemaAssetPath);
    initEaterySchema(store, schema);
    SchemaMigrator(store).migrate();
    appStore = store;
    appDatabase = EateryDatabase(dataDir: AppFileSystem.dataDir, store: store);
    OrderFunction.init(store);
  }

  await FastCachedImageConfig.init(
    subDir: '${AppFileSystem.cacheDir}/',
    clearCacheAfter: const Duration(days: 15),
  );
}

/// Starts the sync host (admin) or client (leaf) based on the device role.
Future<void> startSync(WidgetRef ref) async {
  if (!kUseSqliteStore) return;

  final role = ref.read(roleProvider);
  if (role == null) return; // no role chosen yet — sync will init lazily

  final deviceId = await getDeviceId() ?? 'eatery-device';

  if (role == 'admin') {
    ref.read(syncInitProvider(SyncConfig.host(deviceId: deviceId)));
    debugPrint('Sync host started on port 9876 (device: $deviceId)');

    unawaited(MdnsService.startAdvertising(port: 9876, deviceName: deviceId));
  } else {
    // Leaf role — discover host via mDNS, fallback to localhost.
    var hostAddress = kDefaultHostAddress;
    try {
      final hosts = await MdnsService.discoverHosts(
        timeout: const Duration(seconds: 3),
      );
      if (hosts.isNotEmpty) {
        hostAddress = hosts.first.ip;
      }
    } catch (e) {
      debugPrint(
        'mDNS discovery failed: $e — falling back to $kDefaultHostAddress',
      );
    }
    ref.read(
      syncInitProvider(
        SyncConfig.leaf(deviceId: deviceId, hostAddress: hostAddress),
      ),
    );
    debugPrint('Sync client started — connecting to $hostAddress');
  }
}

/// Role-aware entry widget that reads the device role and renders
/// the appropriate shell.
class RoleShell extends ConsumerStatefulWidget {
  const RoleShell({super.key});

  @override
  ConsumerState<RoleShell> createState() => _RoleShellState();
}

class _RoleShellState extends ConsumerState<RoleShell> {
  @override
  void initState() {
    super.initState();
    _initSync();
  }

  void _initSync() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      startSync(ref);
    });

    // Retry sync when the device role changes (e.g. after login or picker).
    ref.listenManual(roleProvider, (_, role) {
      if (role != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          startSync(ref);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return _KeyboardStateSync(
      child: MaterialApp.router(
        title: 'Eatery',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: createAppRouter(
          appDatabase ??
              EateryDatabase(dataDir: '', store: EateryStore.open(':memory:')),
          store: appStore,
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
