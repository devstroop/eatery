import 'package:eatery/data/models/eatery_db.dart';
import 'package:eatery/data/database/eatery_db_shim.dart';
import 'package:eatery/data/database/native/store_config.dart';

class Staff {
  int? id;
  String name;
  String? photo;
  String? phone;
  StaffType type;
  bool isActive;

  Staff(
      {
      required this.name,
      this.photo,
      this.phone,
      required this.type,
      required this.isActive}) : id = kUseSqliteStaffStore ? null : EateryDB.instance.staffBox?.nextId();

  Staff.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        photo = map['photo'],
        phone = map['phone'],
        type = StaffType.values.singleWhere((element) => element.id == map['type']),
        isActive = map['isActive'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'photo': photo,
      'phone': phone,
      'type': type.id,
      'isActive': isActive
    };
  }

  static Staff fromIterable(Iterable<dynamic> row) {
    return Staff.fromMap({
      'id': row.elementAt(0),
      'name': row.elementAt(1),
      'photo': row.elementAt(2),
      'phone': row.elementAt(3),
      'type': row.elementAt(4),
      'isActive': row.elementAt(5)
    }
    );
  }

  List<dynamic> toIterable() {
    var map = toMap();
    return [
      map['id'],
      map['name'],
      map['photo'],
      map['phone'],
      map['type'],
      map['isActive']
    ];
  }
}
