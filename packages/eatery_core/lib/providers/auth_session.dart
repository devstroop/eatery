import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/data/database/native/eatery_store.dart';

/// Tracks the currently authenticated staff member.
///
/// null = unauthenticated.
final authSessionProvider = StateProvider<Staff?>((ref) => null);

/// Verifies a staff member's PIN against the stored hash.
///
/// Supports both SHA-256 hashed PINs and legacy plaintext PINs for
/// backward compatibility. All new PIN insertions should hash first.
///
/// Returns the matching [Staff] on success, null on failure.
Staff? authenticateStaff(EateryStore store, String loginId, String pin) {
  var staff = _findByPhone(store, loginId);
  staff ??= _findByName(store, loginId);
  if (staff == null) return null;
  if (staff.pin == null) return null;
  if (verifyPin(pin, staff.pin!)) return staff;
  return null;
}

Staff? _findByPhone(EateryStore store, String phone) {
  final rows = store.query('SELECT * FROM staff WHERE phone = ? LIMIT 1', [
    phone,
  ]);
  if (rows.isEmpty) return null;
  return Staff.fromMap(rows.first);
}

Staff? _findByName(EateryStore store, String name) {
  final rows = store.query(
    'SELECT * FROM staff WHERE lower(trim(name)) = ? LIMIT 1',
    [name.toLowerCase().trim()],
  );
  if (rows.isEmpty) return null;
  return Staff.fromMap(rows.first);
}
