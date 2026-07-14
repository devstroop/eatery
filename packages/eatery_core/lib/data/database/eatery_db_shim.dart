/// Minimal stub — Hive has been fully eliminated.
///
/// Model constructors reference `EateryDB.instance.xxxBox?.nextId()` in guarded
/// fallbacks. All return null since all flags are true.
library;

class EateryDB {
  EateryDB._();
  static final EateryDB instance = EateryDB._();

  dynamic get companyBox => null;
  dynamic get customerBox => null;
  dynamic get productBox => null;
  dynamic get productCategoryBox => null;
  dynamic get orderBox => null;
  dynamic get orderProductBox => null;
  dynamic get paymentBox => null;
  dynamic get paymentModeBox => null;
  dynamic get diningTableBox => null;
  dynamic get diningTableCategoryBox => null;
  dynamic get diningTableStatusBox => null;
  dynamic get taxSlabBox => null;
  dynamic get taxTypeBox => null;
  dynamic get staffBox => null;
  dynamic get staffTypeBox => null;
  dynamic get printerBox => null;
  dynamic get printerTypeBox => null;
  dynamic get currencyBox => null;
  dynamic get autoPrintBox => null;
  dynamic get foodTypeBox => null;
  dynamic get productTypeBox => null;
  dynamic get orderTypeBox => null;
  dynamic get voidLogEntryBox => null;
  dynamic get complianceReportBox => null;
  dynamic get kdsStationBox => null;
  dynamic get taxationBox => null;
  dynamic get opLogBox => null;
}
