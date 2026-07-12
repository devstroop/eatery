import 'package:eatery/data/database/eatery_database.dart';
import 'package:eatery/data/models/eatery_db.dart';

class TaxRepository {
  TaxRepository({required EateryDatabase db}) : _db = db;
  final EateryDatabase _db;

  List<TaxSlab> getAllTaxSlabs() => _db.taxSlabBox.values.toList();
  TaxSlab? getTaxSlabById(int id) {
    try {
      return _db.taxSlabBox.values.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<int> saveTaxSlab(TaxSlab slab) async {
    if (slab.id != null && _db.taxSlabBox.containsKey(slab.id)) {
      await slab.save();
      return slab.id!;
    }
    return await _db.taxSlabBox.add(slab);
  }
}
