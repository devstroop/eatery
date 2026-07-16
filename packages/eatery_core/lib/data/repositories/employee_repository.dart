import 'package:eatery_core/data/models/eatery_db.dart';
import '../database/native/eatery_store.dart';

class EmployeeRepository {
  EmployeeRepository({required EateryStore store}) : _db = store;
  final EateryStore _db;
  List<Employee> getAllEmployees() =>
      _db.query('SELECT * FROM employee').map(_toEmployee).toList();
  Employee? getEmployeeById(int id) {
    final r = _db.query('SELECT * FROM employee WHERE id = ?', [id]);
    return r.isEmpty ? null : _toEmployee(r.first);
  }

  Employee? getEmployeeByPhone(String phone) {
    final r = _db.query('SELECT * FROM employee WHERE phone = ? LIMIT 1', [
      phone,
    ]);
    return r.isEmpty ? null : _toEmployee(r.first);
  }

  Future<int> saveEmployee(Employee employee) async {
    final v = [
      employee.name,
      employee.photo,
      employee.phone,
      employee.type.id,
      employee.isActive ? 1 : 0,
      employee.pin,
    ];
    if (employee.id != null) {
      _db.execute(
        'UPDATE employee SET name=?,photo=?,phone=?,type=?,isActive=?,pin=? WHERE id=?',
        [...v, employee.id],
      );
      return employee.id!;
    }
    _db.execute(
      'INSERT INTO employee (name,photo,phone,type,isActive,pin) VALUES (?,?,?,?,?,?)',
      v,
    );
    final id = _db.queryScalar('SELECT last_insert_rowid()') as int;
    employee = employee.copyWith(id: id);
    return id;
  }

  Future<void> deleteEmployee(int id) async {
    _db.execute('DELETE FROM employee WHERE id = ?', [id]);
  }

  bool isEmployeeNameTaken(String name) => _db.query(
    'SELECT id FROM employee WHERE lower(trim(name))=?',
    [name.toLowerCase().trim()],
  ).isNotEmpty;
  bool isEmployeePhoneTaken(String phone) =>
      _db.query('SELECT id FROM employee WHERE phone=?', [phone]).isNotEmpty;
  Future<void> clearAll() async => _db.execute('DELETE FROM employee');
  Future<void> addAll(List<Employee> list) async {
    for (final s in list) {
      _db.execute(
        'INSERT INTO employee (name,photo,phone,type,isActive,pin) VALUES (?,?,?,?,?,?)',
        [s.name, s.photo, s.phone, s.type.id, s.isActive ? 1 : 0, s.pin],
      );
    }
  }

  Employee _toEmployee(Map<String, Object?> r) => Employee(
    name: r['name'] as String,
    photo: r['photo'] as String?,
    phone: r['phone'] as String?,
    pin: r['pin'] as String?,
    type: EmployeeRole.values.firstWhere((e) => e.id == (r['type'] as int)),
    isActive: (r['isActive'] as int) == 1,
    id: r['id'] as int,
  );
}
