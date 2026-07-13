import 'package:eatery/data/models/eatery_db.dart';

abstract class DiningTableRepository {
  List<DiningTable> getAllTables();
  DiningTable? getTableById(int id);
  Future<int> saveTable(DiningTable table);
  List<DiningTableCategory> getAllCategories();
  DiningTableCategory? getCategoryById(int id);
  Future<int> saveCategory(DiningTableCategory category);
}
