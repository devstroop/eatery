import 'package:eatery/data/database/eatery_database.dart';
import 'package:eatery/data/models/eatery_db.dart';

class DiningTableRepository {
  DiningTableRepository({required EateryDatabase db}) : _db = db;
  final EateryDatabase _db;

  List<DiningTable> getAllTables() => _db.diningTableBox.values.toList();
  DiningTable? getTableById(int id) {
    try {
      return _db.diningTableBox.values.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<int> saveTable(DiningTable table) async {
    if (table.id != null && _db.diningTableBox.containsKey(table.id)) {
      await table.save();
      return table.id!;
    }
    return await _db.diningTableBox.add(table);
  }
}
