import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/data/database/eatery_db_shim.dart';
import 'package:eatery_core/data/database/native/store_config.dart';

class TaxSlab {
  int? id;
  String name;
  double rate;
  TaxType type;

  TaxSlab({required this.name, required this.rate, required this.type})
    : id = kUseSqliteTaxStore ? null : EateryDB.instance.taxSlabBox?.nextId();

  TaxSlab.fromMap(Map<String, dynamic> map)
    : id = map['id'],
      name = map['name'],
      rate = map['rate'],
      type = TaxType.values.singleWhere(
        (element) => element.index == map['type'],
      );

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'rate': rate, 'type': type.index};
  }

  static TaxSlab fromIterable(Iterable<dynamic> row) {
    return TaxSlab.fromMap({
      'id': row.elementAt(0),
      'name': row.elementAt(1),
      'rate': row.elementAt(2),
      'type': row.elementAt(3),
    });
  }

  List<dynamic> toIterable() {
    var map = toMap();
    return [map['id'], map['name'], map['rate'], map['type']];
  }
}
