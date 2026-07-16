import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/data/sync/mutation_hook.dart';

import '../database/native/eatery_store.dart';
import 'employee_repository.dart';

/// SQLite-backed implementation of [EmployeeRepository], powered by the native
/// libeaterystore (Zig + embedded SQLite) over dart:ffi.
class SqliteEmployeeRepository implements EmployeeRepository {
  SqliteEmployeeRepository({required EateryStore store}) : _store = store;

  final EateryStore _store;

  static const _columns = 'name, email, photo, phone, pin, pinUpdatedAt, lastLoginAt, type, isActive';

  @override
  List<Employee> getAllEmployees() =>
      _store.query('SELECT * FROM employee').map(_toEmployee).toList();

  @override
  Employee? getEmployeeById(int id) {
    final rows = _store.query('SELECT * FROM employee WHERE id = ?', [id]);
    return rows.isEmpty ? null : _toEmployee(rows.first);
  }

  @override
  Employee? getEmployeeByPhone(String phone) {
    final rows = _store.query(
      'SELECT * FROM employee WHERE phone = ? LIMIT 1',
      [phone],
    );
    return rows.isEmpty ? null : _toEmployee(rows.first);
  }

  @override
  Future<int> saveEmployee(Employee employee) async {
    final values = <Object?>[
      employee.name,
      employee.email,
      employee.photo,
      employee.phone,
      employee.pin,
      employee.pinUpdatedAt,
      employee.lastLoginAt,
      employee.type.id,
      employee.isActive ? 1 : 0,
    ];

    final int id;
    if (employee.id != null && _exists(employee.id!)) {
      id = employee.id!;
      _store.execute(
        'UPDATE employee SET name=?, email=?, photo=?, phone=?, pin=?, pinUpdatedAt=?, lastLoginAt=?, type=?, isActive=? WHERE id=?',
        [...values, id],
      );
    } else {
      _store.execute(
        'INSERT INTO employee ($_columns) VALUES (?,?,?,?,?,?,?,?,?)',
        values,
      );
      id = _store.queryScalar('SELECT last_insert_rowid()') as int;
      employee = employee.copyWith(id: id);
    }
    notifyMutation('employee', id, 'save', employee.toMap());
    return id;
  }

  @override
  bool isEmployeeNameTaken(String name) {
    final n = name.toLowerCase().trim();
    final rows = _store.query(
      'SELECT id FROM employee WHERE lower(trim(name)) = ?',
      [n],
    );
    return rows.isNotEmpty;
  }

  @override
  bool isEmployeePhoneTaken(String phone) {
    final rows = _store.query('SELECT id FROM employee WHERE phone = ?', [
      phone,
    ]);
    return rows.isNotEmpty;
  }

  @override
  Future<void> deleteEmployee(int id) async {
    _store.execute('DELETE FROM employee WHERE id = ?', [id]);
    notifyMutation('employee', id, 'delete', {'id': id});
  }

  @override
  Future<void> clearAll() async {
    _store.execute('DELETE FROM employee');
  }

  @override
  Future<void> addAll(Iterable<Employee> employeeList) async {
    for (final s in employeeList) {
      _store.execute('INSERT INTO employee ($_columns) VALUES (?,?,?,?,?,?,?,?,?)', [
        s.name,
        s.email,
        s.photo,
        s.phone,
        s.pin,
        s.pinUpdatedAt,
        s.lastLoginAt,
        s.type.id,
        s.isActive ? 1 : 0,
      ]);
      final id = _store.queryScalar('SELECT last_insert_rowid()') as int;
      notifyMutation('employee', id, 'save', s.toMap());
    }
  }

  bool _exists(int id) =>
      _store.queryScalar('SELECT 1 FROM employee WHERE id = ?', [id]) != null;

  Employee _toEmployee(Map<String, Object?> row) {
    final type = EmployeeRole.values.firstWhere(
      (e) => e.id == (row['type'] as int),
    );
    return Employee(
      name: row['name'] as String,
      email: row['email'] as String?,
      photo: row['photo'] as String?,
      phone: row['phone'] as String?,
      pin: row['pin'] as String?,
      pinUpdatedAt: row['pinUpdatedAt'] as int?,
      lastLoginAt: row['lastLoginAt'] as int?,
      type: type,
      isActive: (row['isActive'] as int) == 1,
      id: row['id'] as int,
    );
  }
}
