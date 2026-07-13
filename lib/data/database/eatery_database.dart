import 'package:eatery/data/database/native/eatery_store.dart';

/// Compatibility database that wraps the native store.
///
/// Legacy getters are deprecated stubs — they exist only so old Hive-backed
/// files compile. All data access should go through repository providers.
class EateryDatabase {
  EateryDatabase({required this.dataDir, required EateryStore store})
    : _store = store;

  final String dataDir;
  final EateryStore _store;

  bool get hasCompany {
    try {
      final rows = _store.query('SELECT 1 FROM company LIMIT 1');
      return rows.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> deleteAll() async {
    final tables = _store.query(
      "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'",
    );
    for (final t in tables) {
      _store.execute('DELETE FROM "${t['name']}"');
    }
  }

  @Deprecated('Use repository providers instead')
  _Box get companyBox => _Box();
  @Deprecated('Use repository providers instead')
  _Box get customerBox => _Box();
  @Deprecated('Use repository providers instead')
  _Box get productBox => _Box();
  @Deprecated('Use repository providers instead')
  _Box get productCategoryBox => _Box();
  @Deprecated('Use repository providers instead')
  _Box get orderBox => _Box();
  @Deprecated('Use repository providers instead')
  _Box get orderProductBox => _Box();
  @Deprecated('Use repository providers instead')
  _Box get paymentBox => _Box();
  @Deprecated('Use repository providers instead')
  _Box get paymentModeBox => _Box();
  @Deprecated('Use repository providers instead')
  _Box get diningTableBox => _Box();
  @Deprecated('Use repository providers instead')
  _Box get diningTableCategoryBox => _Box();
  @Deprecated('Use repository providers instead')
  _Box get diningTableStatusBox => _Box();
  @Deprecated('Use repository providers instead')
  _Box get taxSlabBox => _Box();
  @Deprecated('Use repository providers instead')
  _Box get taxTypeBox => _Box();
  @Deprecated('Use repository providers instead')
  _Box get staffBox => _Box();
  @Deprecated('Use repository providers instead')
  _Box get staffTypeBox => _Box();
  @Deprecated('Use repository providers instead')
  _Box get printerBox => _Box();
  @Deprecated('Use repository providers instead')
  _Box get printerTypeBox => _Box();
  @Deprecated('Use repository providers instead')
  _Box get subscriptionBox => _Box();
  @Deprecated('Use repository providers instead')
  _Box get subscriptionTypeBox => _Box();
  @Deprecated('Use repository providers instead')
  _Box get currencyBox => _Box();
  @Deprecated('Use repository providers instead')
  _Box get autoPrintBox => _Box();
  @Deprecated('Use repository providers instead')
  _Box get foodTypeBox => _Box();
  @Deprecated('Use repository providers instead')
  _Box get productTypeBox => _Box();
  @Deprecated('Use repository providers instead')
  _Box get orderTypeBox => _Box();
  @Deprecated('Use repository providers instead')
  _Box get voidLogEntryBox => _Box();
  @Deprecated('Use repository providers instead')
  _Box get complianceReportBox => _Box();
  @Deprecated('Use repository providers instead')
  _Box get kdsStationBox => _Box();
  @Deprecated('Use repository providers instead')
  _Box get taxationBox => _Box();
  @Deprecated('Use repository providers instead')
  _Box get opLogBox => _Box();
}

/// Stub for a Hive Box — always empty. Exists so legacy pages/repos compile.
class _Box {
  List get values => [];
  bool get isNotEmpty => false;
  bool get isEmpty => true;
  int get length => 0;
  dynamic operator [](dynamic key) => null;
  void operator []=(dynamic key, dynamic value) {}
  bool containsKey(dynamic key) => false;
  Iterable get keys => [];
  int put(dynamic key, dynamic value) => 0;
  int add(dynamic value) => 0;
  int addAll(Iterable values) => 0;
  Future<void> clear() async {}
  dynamic get(dynamic key) => null;
  Future<void> deleteFromDisk() async {}
  Future<void> delete(dynamic key) async {}
}
