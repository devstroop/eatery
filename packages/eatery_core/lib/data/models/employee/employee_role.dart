import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum EmployeeRole {
  @JsonValue(0)
  waiter,
  @JsonValue(1)
  chef,
  @JsonValue(2)
  driver,
  @JsonValue(3)
  other,
  @JsonValue(4)
  admin,
  @JsonValue(5)
  manager,
}

extension EmployeeRoleExtension on EmployeeRole {
  int get id {
    switch (this) {
      case EmployeeRole.waiter:
        return 0;
      case EmployeeRole.chef:
        return 1;
      case EmployeeRole.driver:
        return 2;
      case EmployeeRole.other:
        return 3;
      case EmployeeRole.admin:
        return 4;
      case EmployeeRole.manager:
        return 5;
    }
  }

  String get name {
    switch (this) {
      case EmployeeRole.waiter:
        return 'Waiter';
      case EmployeeRole.chef:
        return 'Chef';
      case EmployeeRole.driver:
        return 'Driver';
      case EmployeeRole.other:
        return 'Other';
      case EmployeeRole.admin:
        return 'Admin';
      case EmployeeRole.manager:
        return 'Manager';
    }
  }
}
