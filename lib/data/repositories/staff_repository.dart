import 'package:eatery/data/models/eatery_db.dart';
import 'package:eatery/data/database/eatery_database.dart';

/// Repository for [Staff] CRUD operations.
/// Created to provide a swap point for the SQLite-backed implementation.
class StaffRepository {
  StaffRepository({required EateryDatabase db}) : _db = db;
  final EateryDatabase _db;

  List<Staff> getAllStaff() => _db.staffBox.values.toList();

  Staff? getStaffById(int id) {
    try {
      return _db.staffBox.values.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<int> saveStaff(Staff staff) async {
    if (staff.id != null && _db.staffBox.containsKey(staff.id)) {
      await staff.save();
      return staff.id!;
    }
    return await _db.staffBox.add(staff);
  }

  bool isStaffNameTaken(String name) {
    return _db.staffBox.values.any(
      (s) => s.name.toLowerCase().trim() == name.toLowerCase().trim(),
    );
  }

  bool isStaffPhoneTaken(String phone) {
    return _db.staffBox.values.any((s) => s.phone == phone);
  }

  Future<void> clearAll() => _db.staffBox.clear();

  Future<void> addAll(Iterable<Staff> staff) =>
      _db.staffBox.addAll(staff.toList());
}
