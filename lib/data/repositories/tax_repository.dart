import 'package:eatery/data/models/eatery_db.dart';
abstract class TaxRepository {
  List<TaxSlab> getAllTaxSlabs();
  TaxSlab? getTaxSlabById(int id);
  Future<int> saveTaxSlab(TaxSlab slab);
}
