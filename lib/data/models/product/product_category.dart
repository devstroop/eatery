import 'package:eatery/data/models/eatery_db.dart';
import 'package:eatery/data/database/eatery_db_shim.dart';
import 'package:eatery/data/database/native/store_config.dart';

class ProductCategory {
  int? id;
  String name;
  String? description;
  String? image;

  ProductCategory({required this.name, this.description, this.image})
    : id = kUseSqliteProductStore
          ? null
          : EateryDB.instance.productCategoryBox?.nextId();

  ProductCategory.fromMap(Map<String, dynamic> map)
    : id = map['id'],
      name = map['name'],
      description = map['description'],
      image = map['image'];

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'description': description, 'image': image};
  }

  static ProductCategory fromIterable(Iterable<dynamic> row) {
    return ProductCategory.fromMap({
      'id': row.elementAt(0),
      'name': row.elementAt(1),
      'description': row.elementAt(2),
      'image': row.elementAt(3),
    });
  }

  List<dynamic> toIterable() {
    return [name, description, image];
  }
}
