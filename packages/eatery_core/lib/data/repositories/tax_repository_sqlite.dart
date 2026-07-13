import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/data/repositories/tax_repository.dart';

import '../database/native/eatery_store.dart';

/// SQLite-backed implementation of [TaxRepository], powered by the native
/// libeaterystore (Zig + embedded SQLite) over dart:ffi.
class SqliteTaxRepository implements TaxRepository {
  SqliteTaxRepository({required EateryStore store}) : _store = store;

  final EateryStore _store;

  static const _columns = 'name, rate, type';

  @override
  List<TaxSlab> getAllTaxSlabs() =>
      _store.query('SELECT * FROM tax_slab').map(TaxSlab.fromMap).toList();

  @override
  TaxSlab? getTaxSlabById(int id) {
    final rows = _store.query('SELECT * FROM tax_slab WHERE id = ?', [id]);
    return rows.isEmpty ? null : TaxSlab.fromMap(rows.first);
  }

  @override
  Future<int> saveTaxSlab(TaxSlab slab) async {
    final values = <Object?>[slab.name, slab.rate, slab.type.index];

    if (slab.id != null && _exists(slab.id!)) {
      _store.execute('UPDATE tax_slab SET name=?, rate=?, type=? WHERE id=?', [
        ...values,
        slab.id,
      ]);
      return slab.id!;
    }

    _store.execute('INSERT INTO tax_slab ($_columns) VALUES (?,?,?)', values);
    final id = _store.queryScalar('SELECT last_insert_rowid()') as int;
    slab = slab.copyWith(id: id);
    return id;
  }

  bool _exists(int id) =>
      _store.queryScalar('SELECT 1 FROM tax_slab WHERE id = ?', [id]) != null;
}
