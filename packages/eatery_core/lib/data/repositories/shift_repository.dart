import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/data/database/native/eatery_store.dart';

class ShiftRepository {
  final EateryStore _store;
  ShiftRepository(this._store);

  List<Shift> getAllShifts() => _store
      .query('SELECT * FROM shift ORDER BY startTime')
      .map(Shift.fromMap)
      .toList();
  Future<int> saveShift(Shift s) async {
    final m = s.toMap();
    if (s.id != null) {
      _store.execute(
        'UPDATE shift SET name=?,startTime=?,endTime=?,isActive=? WHERE id=?',
        [m['name'], m['startTime'], m['endTime'], m['isActive'], s.id],
      );
      return s.id!;
    }
    _store.execute(
      'INSERT INTO shift (name,startTime,endTime,isActive) VALUES (?,?,?,?)',
      [m['name'], m['startTime'], m['endTime'], m['isActive']],
    );
    return _store.queryScalar('SELECT last_insert_rowid()') as int;
  }

  Future<void> deleteShift(int id) async {
    _store.execute('DELETE FROM shift WHERE id = ?', [id]);
  }

  Future<void> clockIn(TimeEntry te) async {
    final m = te.toMap();
    _store.execute(
      'INSERT INTO time_entry (employeeId,shiftId,clockIn,breakStart,breakEnd,note,createdAt) VALUES (?,?,?,?,?,?,?)',
      [
        m['employeeId'],
        m['shiftId'],
        m['clockIn'],
        m['breakStart'],
        m['breakEnd'],
        m['note'],
        m['createdAt'],
      ],
    );
  }

  Future<void> clockOut(int entryId) async {
    _store.execute('UPDATE time_entry SET clockOut = ? WHERE id = ?', [
      DateTime.now().millisecondsSinceEpoch,
      entryId,
    ]);
  }

  List<TimeEntry> getTodaysEntries(int employeeId) {
    final start = DateTime.now()
        .subtract(const Duration(hours: 24))
        .millisecondsSinceEpoch;
    return _store
        .query(
          'SELECT * FROM time_entry WHERE employeeId = ? AND clockIn > ? ORDER BY clockIn',
          [employeeId, start],
        )
        .map(TimeEntry.fromMap)
        .toList();
  }
}
