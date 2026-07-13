import 'package:eatery_core/data/models/eatery_db.dart';

abstract class DiningTableRepository {
  List<DiningTable> getAllTables();
  DiningTable? getTableById(int id);
  Future<int> saveTable(DiningTable table);
  Future<void> deleteTable(int id);
  List<DiningTableCategory> getAllCategories();
  DiningTableCategory? getCategoryById(int id);
  Future<int> saveCategory(DiningTableCategory category);
  Future<void> deleteCategory(int id);
}
