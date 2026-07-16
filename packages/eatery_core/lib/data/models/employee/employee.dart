import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee.freezed.dart';
part 'employee.g.dart';

@freezed
abstract class Employee with _$Employee {
  const factory Employee({
    int? id,
    required String name,
    String? photo,
    String? phone,
    String? pin,
    @Default(EmployeeRole.waiter) EmployeeRole type,
    @Default(true) bool isActive,
  }) = _Employee;

  factory Employee.fromJson(Map<String, dynamic> json) =>
      _$EmployeeFromJson(json);

  static Employee fromMap(Map<String, dynamic> map) => Employee.fromJson(map);
}

extension EmployeeX on Employee {
  Map<String, Object?> toMap() => toJson() as Map<String, Object?>;

  static Employee fromIterable(Iterable<dynamic> row) {
    return Employee.fromMap({
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
