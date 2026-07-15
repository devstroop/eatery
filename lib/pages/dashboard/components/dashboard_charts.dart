import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/eatery_core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:eatery_core/services/chart_service.dart';

final _chartDataProvider = FutureProvider.autoDispose<
    (
      List<ChartDataPoint> revenue,
      List<ChartDataPoint> orderCount,
      Map<String, double> payments,
    )>((ref) async {
  final isolate = await ref.watch(eateryStoreIsolateProvider.future);
  if (isolate == null) throw Exception('Store not available');
  final svc = ChartService(isolate);
  final results = await Future.wait([
    svc.dailyRevenue(7),
    svc.dailyOrderCount(7),
    svc.paymentBreakdown(7),
  ]);
  return (
    results[0] as List<ChartDataPoint>,
    results[1] as List<ChartDataPoint>,
    results[2] as Map<String, double>,
  );
});

class DashboardCharts extends ConsumerWidget {
  const DashboardCharts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charts = ref.watch(_chartDataProvider);
    return charts.when(
      data: (data) => Column(
        children: [
          _RevenueLineChart(data.$1),
          const SizedBox(height: 24),
          _OrderVolumeBarChart(data.$2),
          const SizedBox(height: 24),
          _PaymentPieChart(data.$3),
        ],
      ),
      loading: () => const SizedBox(
        height: 300,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => SizedBox(
        height: 100,
        child: Center(child: Text('Charts unavailable: $e')),
      ),
    );
  }
}

class _RevenueLineChart extends StatelessWidget {
  final List<ChartDataPoint> data;
  const _RevenueLineChart(this.data);

  @override
  Widget build(BuildContext context) {
    final maxY = data.fold(0.0, (a, b) => a > b.value ? a : b.value);
    final spots = data.asMap().entries.map((e) =>
      FlSpot(e.key.toDouble(), e.value.value)
    ).toList();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Revenue (7 days)', style: AppTypography.titleMedium),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: AppColors.grey200,
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 48,
                        getTitlesWidget: (v, _) => Text(
                          '\$${(v as int).toString()}',
                          style: AppTypography.bodySmall,
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) {
                          final i = v.toInt();
                          if (i < 0 || i >= data.length) return const Text('');
                          return Text(
                            '${data[i].date.month}/${data[i].date.day}',
                            style: AppTypography.bodySmall,
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: AppColors.primary,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (_, __, ___, ____) =>
                          FlDotCirclePainter(
                            radius: 4,
                            color: AppColors.primary,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppColors.primary.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                  minY: 0,
                  maxY: maxY > 0 ? maxY * 1.2 : 100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderVolumeBarChart extends StatelessWidget {
  final List<ChartDataPoint> data;
  const _OrderVolumeBarChart(this.data);

  @override
  Widget build(BuildContext context) {
    final maxY = data.fold<int>(0, (a, b) => a > b.value.toInt() ? a : b.value.toInt());

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Orders (7 days)', style: AppTypography.titleMedium),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY > 0 ? maxY * 1.3 : 5,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        getTitlesWidget: (v, _) => Text(
                          '${v.toInt()}',
                          style: AppTypography.bodySmall,
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) {
                          final i = v.toInt();
                          if (i < 0 || i >= data.length) return const Text('');
                          return Text(
                            '${data[i].date.month}/${data[i].date.day}',
                            style: AppTypography.bodySmall,
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: AppColors.grey200,
                      strokeWidth: 1,
                    ),
                  ),
                  barGroups: data.asMap().entries.map((e) =>
                    BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: e.value.value,
                          color: AppColors.info,
                          width: 20,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentPieChart extends StatelessWidget {
  final Map<String, double> data;
  const _PaymentPieChart(this.data);

  static const _modeLabels = {
    'mode_0': 'Cash',
    'mode_1': 'Card',
    'mode_2': 'UPI',
    'mode_3': 'Wallet',
    'mode_4': 'Other',
  };

  static const _modeColors = {
    'mode_0': Color(0xFF27AE60),
    'mode_1': Color(0xFF2980B9),
    'mode_2': Color(0xFFF39C12),
    'mode_3': Color(0xFF8E44AD),
    'mode_4': Color(0xFF95A5A6),
  };

  @override
  Widget build(BuildContext context) {
    final total = data.values.fold(0.0, (a, b) => a + b);
    if (total == 0) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Payment Breakdown', style: AppTypography.titleMedium),
              const SizedBox(height: 16),
              const Center(child: Text('No payment data yet')),
            ],
          ),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Payment Breakdown', style: AppTypography.titleMedium),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sections: data.entries.map((e) {
                          final pct = total > 0 ? e.value / total * 100 : 0.0;
                          return PieChartSectionData(
                            value: e.value,
                            title: '${pct.toStringAsFixed(0)}%',
                            color: _modeColors[e.key] ?? AppColors.grey500,
                            radius: 60,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList(),
                        sectionsSpace: 2,
                        centerSpaceRadius: 30,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: data.entries.map((e) {
                      final pct = total > 0 ? e.value / total * 100 : 0.0;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: _modeColors[e.key] ?? AppColors.grey500,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${_modeLabels[e.key] ?? e.key}: '
                              '\$${e.value.toStringAsFixed(0)} (${
                                pct.toStringAsFixed(1)}%)',
                              style: AppTypography.bodySmall,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
