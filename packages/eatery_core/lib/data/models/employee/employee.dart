import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee.freezed.dart';
part 'employee.g.dart';

@freezed
abstract class Employee with _$Employee {
  const factory Employee({
    int? id,
    required String name,
    String? email,
    String? photo,
    String? phone,
    String? pin,
    int? pinUpdatedAt,
    int? lastLoginAt,
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
      'email': row.elementAt(2),
      'photo': row.elementAt(3),
      'phone': row.elementAt(4),
      'pin': row.elementAt(5),
      'pinUpdatedAt': row.elementAt(6),
      'lastLoginAt': row.elementAt(7),
      'type': row.elementAt(8),
      'isActive': row.elementAt(9),
    });
  }

  List<dynamic> toIterable() {
    var map = toMap();
    return [
      map['id'],
      map['name'],
      map['email'],
      map['photo'],
      map['phone'],
      map['pin'],
      map['pinUpdatedAt'],
      map['lastLoginAt'],
      map['type'],
      map['isActive'],
    ];
  }
}
