import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/data/database/native/eatery_store.dart';

/// Tracks the currently authenticated employee.
///
/// null = unauthenticated.
final authSessionProvider = StateProvider<Employee?>((ref) => null);

/// Verifies an employee's PIN against the stored hash.
///
/// Supports both SHA-256 hashed PINs and legacy plaintext PINs for
/// backward compatibility. All new PIN insertions should hash first.
///
/// Updates [lastLoginAt] on success. Returns the matching [Employee], or null
/// on failure.
Employee? authenticateEmployee(EateryStore store, String loginId, String pin) {
  var employee = _findByPhone(store, loginId);
  employee ??= _findByName(store, loginId);
  if (employee == null) return null;
  if (employee.pin == null) return null;
  if (!verifyPin(pin, employee.pin!)) return null;

  final now = DateTime.now().millisecondsSinceEpoch;
  store.execute(
    'UPDATE employee SET lastLoginAt = ? WHERE id = ?',
    [now, employee.id],
  );
  return employee.copyWith(lastLoginAt: now);
}

Employee? _findByPhone(EateryStore store, String phone) {
  final rows = store.query('SELECT * FROM employee WHERE phone = ? LIMIT 1', [
    phone,
  ]);
  if (rows.isEmpty) return null;
  return Employee.fromMap(rows.first);
}

Employee? _findByName(EateryStore store, String name) {
  final rows = store.query(
    'SELECT * FROM employee WHERE lower(trim(name)) = ? LIMIT 1',
    [name.toLowerCase().trim()],
  );
  if (rows.isEmpty) return null;
  return Employee.fromMap(rows.first);
}
