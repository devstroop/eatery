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
