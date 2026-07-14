import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/data/sync/mutation_hook.dart';

import '../database/native/eatery_store.dart';
import 'staff_repository.dart';

/// SQLite-backed implementation of [StaffRepository], powered by the native
/// libeaterystore (Zig + embedded SQLite) over dart:ffi.
class SqliteStaffRepository implements StaffRepository {
  SqliteStaffRepository({required EateryStore store}) : _store = store;

  final EateryStore _store;

  static const _columns = 'name, photo, phone, type, isActive, pin';

  @override
  List<Staff> getAllStaff() =>
      _store.query('SELECT * FROM staff').map(_toStaff).toList();

  @override
  Staff? getStaffById(int id) {
    final rows = _store.query('SELECT * FROM staff WHERE id = ?', [id]);
    return rows.isEmpty ? null : _toStaff(rows.first);
  }

  @override
  Staff? getStaffByPhone(String phone) {
    final rows = _store.query(
      'SELECT * FROM staff WHERE phone = ? LIMIT 1',
      [phone],
    );
    return rows.isEmpty ? null : _toStaff(rows.first);
  }

  @override
  Future<int> saveStaff(Staff staff) async {
    final values = <Object?>[
      staff.name,
      staff.photo,
      staff.phone,
      staff.type.id,
      staff.isActive ? 1 : 0,
      staff.pin,
    ];

    final int id;
    if (staff.id != null && _exists(staff.id!)) {
      id = staff.id!;
      _store.execute(
        'UPDATE staff SET name=?, photo=?, phone=?, type=?, isActive=?, pin=? WHERE id=?',
        [...values, id],
      );
    } else {
      _store.execute('INSERT INTO staff ($_columns) VALUES (?,?,?,?,?,?)', values);
      id = _store.queryScalar('SELECT last_insert_rowid()') as int;
      staff = staff.copyWith(id: id);
    }
    notifyMutation('staff', id, 'save', staff.toMap());
    return id;
  }

  @override
  bool isStaffNameTaken(String name) {
    final n = name.toLowerCase().trim();
    final rows = _store.query(
      'SELECT id FROM staff WHERE lower(trim(name)) = ?',
      [n],
    );
    return rows.isNotEmpty;
  }

  @override
  bool isStaffPhoneTaken(String phone) {
    final rows = _store.query('SELECT id FROM staff WHERE phone = ?', [phone]);
    return rows.isNotEmpty;
  }

  @override
  Future<void> deleteStaff(int id) async {
    _store.execute('DELETE FROM staff WHERE id = ?', [id]);
    notifyMutation('staff', id, 'delete', {'id': id});
  }

  @override
  Future<void> clearAll() async {
    _store.execute('DELETE FROM staff');
  }

  @override
  Future<void> addAll(Iterable<Staff> staffList) async {
    for (final s in staffList) {
      _store.execute('INSERT INTO staff ($_columns) VALUES (?,?,?,?,?,?)', [
        s.name,
        s.photo,
        s.phone,
        s.type.id,
        s.isActive ? 1 : 0,
        s.pin,
      ]);
      final id = _store.queryScalar('SELECT last_insert_rowid()') as int;
      notifyMutation('staff', id, 'save', s.toMap());
    }
  }

  bool _exists(int id) =>
      _store.queryScalar('SELECT 1 FROM staff WHERE id = ?', [id]) != null;

  Staff _toStaff(Map<String, Object?> row) {
    final type = StaffType.values.firstWhere(
      (e) => e.id == (row['type'] as int),
    );
    return Staff(
      name: row['name'] as String,
      photo: row['photo'] as String?,
      phone: row['phone'] as String?,
      pin: row['pin'] as String?,
      type: type,
      isActive: (row['isActive'] as int) == 1,
      id: row['id'] as int);
  }
}
