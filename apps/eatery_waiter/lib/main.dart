import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:eatery_core/eatery_core.dart';
import 'app.dart';

EateryStore? appStore;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationSupportDirectory();

  if (kUseSqliteStore) {
    final store = EateryStore.open('${dir.path}/$kEateryDbFileName');
    final schema = await rootBundle.loadString(kSchemaAssetPath);
    initEaterySchema(store, schema);
    appStore = store;
  }

  runApp(
    ProviderScope(
      overrides: [
        if (appStore != null)
          eateryStoreProvider.overrideWithValue(appStore!),
      ],
      child: const EateryWaiterApp(),
    ),
  );
}

class SyncInitializer extends ConsumerStatefulWidget {
  final Widget child;
  const SyncInitializer({super.key, required this.child});

  @override
  ConsumerState<SyncInitializer> createState() => _SyncInitializerState();
}

class _SyncInitializerState extends ConsumerState<SyncInitializer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initSync());
  }

  Future<void> _initSync() async {
    if (appStore == null) return;
    final config = SyncHostConfig(appStore!);
    var hostAddress = config.getHostAddress();

    // Try mDNS discovery when no manual address is configured.
    if (hostAddress == kDefaultHostAddress) {
      final hosts = await MdnsService.discoverHosts(
        timeout: const Duration(seconds: 3),
      );
      if (hosts.isNotEmpty) {
        hostAddress = hosts.first.ip;
        config.setHostAddress(hostAddress);
      }
    }

    ref.read(syncInitProvider(SyncConfig.leaf(
      deviceId: 'eatery-waiter',
      hostAddress: hostAddress,
    )));
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
