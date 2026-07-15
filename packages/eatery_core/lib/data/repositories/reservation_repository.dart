import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/data/database/native/eatery_store.dart';
import 'package:eatery_core/data/sync/mutation_hook.dart';

class ReservationRepository {
  final EateryStore _store;
  ReservationRepository(this._store);
  List<Reservation> getReservationsForDate(DateTime date) {
    final start = DateTime(
      date.year,
      date.month,
      date.day,
    ).millisecondsSinceEpoch;
    final end = start + 86400000;
    return _store
        .query(
          'SELECT * FROM reservation WHERE dateTime >= ? AND dateTime < ? ORDER BY dateTime',
          [start, end],
        )
        .map(Reservation.fromMap)
        .toList();
  }

  List<Reservation> getAllReservations() => _store
      .query('SELECT * FROM reservation ORDER BY dateTime DESC')
      .map(Reservation.fromMap)
      .toList();
  Future<int> saveReservation(Reservation r) async {
    final m = r.toMap();
    if (r.id != null) {
      _store.execute(
        'UPDATE reservation SET customerName=?,customerPhone=?,diningTableId=?,partySize=?,dateTime=?,duration=?,status=?,note=?,updatedAt=? WHERE id=?',
        [
          m['customerName'],
          m['customerPhone'],
          m['diningTableId'],
          m['partySize'],
          m['dateTime'],
          m['duration'],
          m['status'],
          m['note'],
          m['updatedAt'],
          r.id,
        ],
      );
      return r.id!;
    }
    _store.execute(
      'INSERT INTO reservation (customerName,customerPhone,diningTableId,partySize,dateTime,duration,status,note,createdBy,createdAt,updatedAt) VALUES (?,?,?,?,?,?,?,?,?,?,?)',
      [
        m['customerName'],
        m['customerPhone'],
        m['diningTableId'],
        m['partySize'],
        m['dateTime'],
        m['duration'],
        m['status'],
        m['note'],
        m['createdBy'],
        m['createdAt'],
        m['updatedAt'],
      ],
    );
    final id = _store.queryScalar('SELECT last_insert_rowid()') as int;
    notifyMutation('reservation', id, 'save', r.copyWith(id: id).toMap());
    return id;
  }

  Future<void> deleteReservation(int id) async {
    _store.execute('DELETE FROM reservation WHERE id = ?', [id]);
    notifyMutation('reservation', id, 'delete', {'id': id});
  }
}
