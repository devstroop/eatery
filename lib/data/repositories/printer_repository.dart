import 'package:eatery/data/models/eatery_db.dart';
import '../database/native/eatery_store.dart';

class PrinterRepository {
  PrinterRepository({required EateryStore store}) : _db = store;
  final EateryStore _db;
  List<Printer> getAllPrinters() =>
      _db.query('SELECT * FROM printer').map(Printer.fromMap).toList();
  Future<int> addPrinter(Printer printer) async {
    final m = printer.toMap();
    _db.execute('INSERT INTO printer (name, bluetoothAddress, usbVendorId, usbProductId, type) VALUES (?,?,?,?,?)',
        [m['name'], m['bluetoothAddress'], m['usbVendorId'], m['usbProductId'], m['type']]);
    return _db.queryScalar('SELECT last_insert_rowid()') as int;
  }
  Future<void> deletePrinter(Printer printer) async {
    if (printer.id != null) _db.execute('DELETE FROM printer WHERE id = ?', [printer.id]);
  }
  Future<void> clearAll() async => _db.execute('DELETE FROM printer');
}
