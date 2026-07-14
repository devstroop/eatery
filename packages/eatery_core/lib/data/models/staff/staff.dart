import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'staff.freezed.dart';
part 'staff.g.dart';

@freezed
abstract class Staff with _$Staff {
  const factory Staff({
    int? id,
    required String name,
    String? photo,
    String? phone,
    String? pin,
    @Default(StaffType.waiter) StaffType type,
    @Default(true) bool isActive,
  }) = _Staff;

  factory Staff.fromJson(Map<String, dynamic> json) => _$StaffFromJson(json);

  static Staff fromMap(Map<String, dynamic> map) => Staff.fromJson(map);
}

extension StaffX on Staff {
  Map<String, Object?> toMap() => toJson() as Map<String, Object?>;

  static Staff fromIterable(Iterable<dynamic> row) {
    return Staff.fromMap({
      'id': row.elementAt(0),
      'name': row.elementAt(1),
      'photo': row.elementAt(2),
      'phone': row.elementAt(3),
      'type': row.elementAt(4),
      'isActive': row.elementAt(5),
      'pin': row.elementAt(6),
    });
  }

  List<dynamic> toIterable() {
    var map = toMap();
    return [
      map['id'],
      map['name'],
      map['photo'],
      map['phone'],
      map['type'],
      map['isActive'],
      map['pin'],
    ];
  }
}
