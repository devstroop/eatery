import 'package:eatery/data/models/eatery_db.dart';
import 'package:eatery/data/database/eatery_db_shim.dart';
import 'package:eatery/data/database/native/store_config.dart';

class Product {
  int? id;
  String name;
  int? categoryId; // id?
  String? description;
  String? image;
  double mrpPrice;
  double? salePrice;
  int? taxSlabId;
  FoodType? foodType;
  ProductType type;
  bool isActive;
  int? stationId;
  String? stationName;

  Product({
    required this.name,
    this.categoryId,
    this.description,
    this.image,
    required this.mrpPrice,
    this.salePrice,
    this.taxSlabId,
    this.foodType,
    required this.type,
    required this.isActive,
    this.stationId,
    this.stationName,
  }) : id = kUseSqliteProductStore
           ? null
           : EateryDB.instance.productBox?.nextId();

  Product.fromMap(Map<String, dynamic> map)
    : id = map['id'],
      name = map['name'],
      categoryId = map['categoryId'],
      description = map['description'],
      image = map['image'],
      mrpPrice = map['mrpPrice'],
      salePrice = map['salePrice'],
      taxSlabId = map['taxSlabId'],
      foodType = FoodType.values
          .where((element) => element.id == map['foodType'])
          .firstOrNull,
      type = ProductType.values.singleWhere(
        (element) => element.index == map['type'],
      ),
      isActive = map['isActive'],
      stationId = map['stationId'],
      stationName = map['stationName'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'categoryId': categoryId,
      'description': description,
      'image': image,
      'mrpPrice': mrpPrice,
      'salePrice': salePrice,
      'taxSlabId': taxSlabId,
      'foodType': foodType != null ? foodType!.id : null,
      'type': type.index,
      'isActive': isActive,
      'stationId': stationId,
      'stationName': stationName,
    };
  }

  static Product fromIterable(Iterable<dynamic> iterable) {
    return Product(
      name: iterable.elementAt(1) as String,
      categoryId: iterable.elementAt(2) as int?,
      description: iterable.elementAt(3) as String?,
      image: iterable.elementAt(4) as String?,
      mrpPrice: iterable.elementAt(5) as double,
      salePrice: iterable.elementAt(6) as double?,
      taxSlabId: iterable.elementAt(7) as int?,
      foodType: FoodType.values.singleWhere(
        (element) => element.id == iterable.elementAt(8) as int,
      ),
      type: ProductType.values.singleWhere(
        (element) => element.index == iterable.elementAt(9) as int,
      ),
      isActive: iterable.elementAt(10) as bool,
      stationId: iterable.elementAt(11) as int?,
      stationName: iterable.elementAt(12) as String?,
    );
  }

  List<dynamic> toIterable() {
    return [
      this.id,
      this.name,
      this.categoryId,
      this.description,
      this.image,
      this.mrpPrice,
      this.salePrice,
      this.taxSlabId,
      this.foodType != null ? this.foodType!.id : null,
      this.type.index,
      this.isActive,
      this.stationId,
      this.stationName,
    ];
  }
}
