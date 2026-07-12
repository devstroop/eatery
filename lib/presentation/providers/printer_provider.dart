import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery/data/models/eatery_db.dart';
import 'package:eatery/data/repositories/printer_repository.dart';
import 'package:eatery/presentation/providers/database_provider.dart';

final printerRepositoryProvider = Provider<PrinterRepository>((ref) {
  final db = ref.read(appDatabaseProvider);
  return PrinterRepository(db: db);
});

final printerListProvider =
    AsyncNotifierProvider<PrinterListNotifier, List<Printer>>(
      PrinterListNotifier.new,
    );

class PrinterListNotifier extends AsyncNotifier<List<Printer>> {
  @override
  Future<List<Printer>> build() async {
    final repo = ref.read(printerRepositoryProvider);
    return repo.getAllPrinters();
  }

  Future<void> addPrinter(Printer printer) async {
    final repo = ref.read(printerRepositoryProvider);
    await repo.addPrinter(printer);
    ref.invalidateSelf();
  }

  Future<void> deletePrinter(Printer printer) async {
    final repo = ref.read(printerRepositoryProvider);
    await repo.deletePrinter(printer);
    ref.invalidateSelf();
  }
}
