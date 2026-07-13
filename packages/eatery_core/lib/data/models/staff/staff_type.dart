enum StaffType { waiter, chef, driver, other }

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
    }
  }
}
