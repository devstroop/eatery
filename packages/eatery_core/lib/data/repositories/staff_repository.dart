import 'package:eatery_core/data/models/eatery_db.dart';
import '../database/native/eatery_store.dart';

class StaffRepository {
  StaffRepository({required EateryStore store}) : _db = store;
  final EateryStore _db;
  List<Staff> getAllStaff() =>
      _db.query('SELECT * FROM staff').map(_toStaff).toList();
  Staff? getStaffById(int id) {
    final r = _db.query('SELECT * FROM staff WHERE id = ?', [id]);
    return r.isEmpty ? null : _toStaff(r.first);
  }

  Staff? getStaffByPhone(String phone) {
    final r = _db.query('SELECT * FROM staff WHERE phone = ? LIMIT 1', [phone]);
    return r.isEmpty ? null : _toStaff(r.first);
  }

  Future<int> saveStaff(Staff staff) async {
    final v = [
      staff.name,
      staff.photo,
      staff.phone,
      staff.type.id,
      staff.isActive ? 1 : 0,
      staff.pin,
    ];
    if (staff.id != null) {
      _db.execute(
        'UPDATE staff SET name=?,photo=?,phone=?,type=?,isActive=?,pin=? WHERE id=?',
        [...v, staff.id],
      );
      return staff.id!;
    }
    _db.execute(
      'INSERT INTO staff (name,photo,phone,type,isActive,pin) VALUES (?,?,?,?,?,?)',
      v,
    );
    final id = _db.queryScalar('SELECT last_insert_rowid()') as int;
    staff = staff.copyWith(id: id);
    return id;
  }

  Future<void> deleteStaff(int id) async {
    _db.execute('DELETE FROM staff WHERE id = ?', [id]);
  }

  bool isStaffNameTaken(String name) => _db.query(
    'SELECT id FROM staff WHERE lower(trim(name))=?',
    [name.toLowerCase().trim()],
  ).isNotEmpty;
  bool isStaffPhoneTaken(String phone) =>
      _db.query('SELECT id FROM staff WHERE phone=?', [phone]).isNotEmpty;
  Future<void> clearAll() async => _db.execute('DELETE FROM staff');
  Future<void> addAll(List<Staff> list) async {
    for (final s in list)
      _db.execute(
        'INSERT INTO staff (name,photo,phone,type,isActive,pin) VALUES (?,?,?,?,?,?)',
        [s.name, s.photo, s.phone, s.type.id, s.isActive ? 1 : 0, s.pin],
      );
  }

  Staff _toStaff(Map<String, Object?> r) => Staff(
    name: r['name'] as String,
    photo: r['photo'] as String?,
    phone: r['phone'] as String?,
    pin: r['pin'] as String?,
    type: StaffType.values.firstWhere((e) => e.id == (r['type'] as int)),
    isActive: (r['isActive'] as int) == 1,
    id: r['id'] as int,
  );
}
