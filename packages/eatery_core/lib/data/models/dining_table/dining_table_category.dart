import 'package:eatery_core/data/database/eatery_db_shim.dart';
import 'package:eatery_core/data/database/native/store_config.dart';

class DiningTableCategory {
  int? id;
  String name;
  String? description;
  bool isActive;

  DiningTableCategory({
    required this.name,
    this.description,
    this.isActive = false,
  }) : id = kUseSqliteDiningTableStore
           ? null
           : EateryDB.instance.diningTableCategoryBox?.nextId();

  DiningTableCategory.fromMap(Map<String, dynamic> map)
    : id = map['id'],
      name = map['name'],
      description = map['description'],
      isActive = map['isActive'] == 1 ? true : false;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isActive': isActive ? 1 : 0,
    };
  }

  static DiningTableCategory fromIterable(Iterable<dynamic> row) {
    return DiningTableCategory.fromMap({
      'id': row.elementAt(0),
      'name': row.elementAt(1),
      'description': row.elementAt(2),
      'image': row.elementAt(3),
      'isActive': row.elementAt(4),
    });
  }

  Iterable<dynamic> toIterable() {
    var map = toMap();
    return [
      map['id'],
      map['name'],
      map['description'],
      map['image'],
      map['isActive'],
    ];
  }
}
