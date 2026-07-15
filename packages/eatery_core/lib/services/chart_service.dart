import 'package:eatery_core/data/database/native/eatery_store_isolate.dart';

class ChartDataPoint {
  final DateTime date;
  final double value;
  ChartDataPoint(this.date, this.value);
}

class ChartService {
  final EateryStoreIsolate _store;

  ChartService(this._store);

  Future<List<ChartDataPoint>> dailyRevenue(int days) async {
    final startMs = DateTime.now()
        .subtract(Duration(days: days - 1))
        .millisecondsSinceEpoch;
    final rows = await _store.query(
      'SELECT CAST(createdAt / 86400000 AS INTEGER) as day, '
      'COALESCE(SUM(grandTotal), 0) as total '
      'FROM orders '
      'WHERE createdAt >= ? AND status != 5 '
      'GROUP BY day ORDER BY day',
      [startMs],
    );
    return _toChartDataPoints(rows, days);
  }

  Future<List<ChartDataPoint>> dailyOrderCount(int days) async {
    final startMs = DateTime.now()
        .subtract(Duration(days: days - 1))
        .millisecondsSinceEpoch;
    final rows = await _store.query(
      'SELECT CAST(createdAt / 86400000 AS INTEGER) as day, '
      'COUNT(*) as count '
      'FROM orders '
      'WHERE createdAt >= ? AND status != 5 '
      'GROUP BY day ORDER BY day',
      [startMs],
    );
    return _toChartDataPoints(rows, days);
  }

  Future<Map<String, double>> paymentBreakdown(
    int days,
  ) async {
    final startMs = DateTime.now()
        .subtract(Duration(days: days - 1))
        .millisecondsSinceEpoch;
    final rows = await _store.query(
      'SELECT mode, COALESCE(SUM(amount), 0) as total '
      'FROM payment '
      'WHERE date >= ? '
      'GROUP BY mode',
      [startMs],
    );
    return {
      for (final r in rows) 'mode_${r['mode']}': (r['total'] as num).toDouble(),
    };
  }

  List<ChartDataPoint> _toChartDataPoints(
    List<Map<String, Object?>> rows,
    int days,
  ) {
    final today = DateTime.now();
    final dayMap = <int, double>{};
    for (final r in rows) {
      final day = r['day'] as int;
      dayMap[day] = (r.values.last as num).toDouble();
    }
    return List.generate(days, (i) {
      final d = today.subtract(Duration(days: days - 1 - i));
      final epochDay = d.millisecondsSinceEpoch ~/ 86400000;
      return ChartDataPoint(d, dayMap[epochDay] ?? 0);
    });
  }
}
