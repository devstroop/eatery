import 'package:eatery/data/database/eatery_database.dart';
import 'package:eatery/data/models/eatery_db.dart';

/// Repository for [Printer] configuration.
class PrinterRepository {
  PrinterRepository({required EateryDatabase db}) : _db = db;

  final EateryDatabase _db;

  List<Printer> getAllPrinters() => _db.printerBox.values.toList();

  Future<int> addPrinter(Printer printer) => _db.printerBox.add(printer);

  Future<void> deletePrinter(Printer printer) => printer.delete();

  Future<void> clearAll() => _db.printerBox.clear();
}
