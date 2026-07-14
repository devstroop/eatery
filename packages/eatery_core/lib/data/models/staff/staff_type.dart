import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum StaffType {
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
}

extension StaffTypeExtension on StaffType {
  int get id {
    switch (this) {
      case StaffType.waiter:
        return 0;
      case StaffType.chef:
        return 1;
      case StaffType.driver:
        return 2;
      case StaffType.other:
        return 3;
      case StaffType.admin:
        return 4;
    }
  }

  String get name {
    switch (this) {
      case StaffType.waiter:
        return 'Waiter';
      case StaffType.chef:
        return 'Chef';
      case StaffType.driver:
        return 'Driver';
      case StaffType.other:
        return 'Other';
      case StaffType.admin:
        return 'Admin';
    }
  }
}
