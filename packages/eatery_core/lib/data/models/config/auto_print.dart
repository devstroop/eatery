import 'package:eatery_core/data/database/eatery_db_shim.dart';
import 'package:eatery_core/data/database/native/store_config.dart';

class AutoPrint {
  int? id;
  bool? invoicePrintEnabled;
  bool? kotPrintEnabled;
  int? invoicePrinterId;
  int? kotPrinterId; // id?

  AutoPrint(
      {
      this.invoicePrintEnabled,
      this.kotPrintEnabled,
      this.invoicePrinterId,
      this.kotPrinterId}): id = kUseSqliteAutoPrintStore ? null : EateryDB.instance.autoPrintBox?.nextId();

  AutoPrint.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        invoicePrintEnabled = map['invoicePrint'],
        kotPrintEnabled = map['invoicePrinter'],
        invoicePrinterId = map['invoicePrinterId'],
        kotPrinterId = map['kotPrinterId'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'invoicePrint': invoicePrintEnabled,
      'kotPrint': kotPrintEnabled,
      'invoicePrinterId': invoicePrinterId,
      'kotPrinterId': kotPrinterId
    };
  }

  static AutoPrint fromIterable(Iterable<dynamic> list) {
    return AutoPrint.fromMap({
      'id': list.elementAt(0),
      'invoicePrint': list.elementAt(1),
      'kotPrint': list.elementAt(2),
      'invoicePrinterId': list.elementAt(3),
      'kotPrinterId': list.elementAt(4)
    });
  }

  Iterable<dynamic> toIterable() {
    var map = toMap();
    return [
      map['id'],
      map['invoicePrint'],
      map['kotPrint'],
      map['invoicePrinterId'],
      map['kotPrinterId']
    ];
  }
}
