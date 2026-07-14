import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:eatery_core/widgets/app_page_shell.dart';
import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/providers/database_provider.dart';
import 'package:eatery_core/providers/company_provider.dart';
import 'package:eatery_core/providers/auth_session.dart';
import 'package:eatery_core/services/report_service.dart';
import 'package:eatery/references.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportsPage extends ConsumerStatefulWidget {
  const ReportsPage({super.key});

  @override
  ConsumerState<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends ConsumerState<ReportsPage> {
  DateTime _start = DateTime.now().subtract(const Duration(days: 1));
  DateTime _end = DateTime.now();
  ComplianceReport? _report;
  bool _loading = false;

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: this.context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      initialDateRange: DateTimeRange(start: _start, end: _end),
    );
    if (picked != null) {
      setState(() {
        _start = picked.start;
        _end = picked.end;
      });
    }
  }

  void _generateXReport() => _generateReport('x');
  void _generateZReport() => _generateReport('z');

  void _generateReport(String type) {
    setState(() => _loading = true);
    try {
      final store = ref.read(eateryStoreProvider);
      final staff = ref.read(authSessionProvider);
      final service = ReportService(store);
      final report = service.generateReport(
        reportType: type == 'z' ? 'daily' : 'midday',
        periodStart: _start,
        periodEnd: _end,
        generatedBy: staff?.name ?? 'Unknown',
      );
      setState(() {
        _report = report;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(this.context).showSnackBar(
        SnackBar(content: Text('Report failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency = ref.read(companyProvider.notifier).currency?.symbol ?? '';

    return AppPageShell(
      title: 'Sales Reports',
      color: AppColors.primary,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Date range selector
          Card(
            child: ListTile(
              title: Text(
                '${DateFormat.yMMMd().format(_start)} - ${DateFormat.yMMMd().format(_end)}',
              ),
              trailing: const Icon(Icons.date_range),
              onTap: _pickDateRange,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AppButton.primary(
                  label: 'X-Report',
                  onPressed: _loading ? null : _generateXReport,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton.primary(
                  label: 'Z-Report',
                  onPressed: _loading ? null : _generateZReport,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_loading)
            const Center(child: CircularProgressIndicator()),
          if (_report != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_report!.reportType == 'daily' ? 'Z' : 'X'}-Report',
                      style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Report #${_report!.reportNumber}',
                      style: AppTypography.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Generated: ${DateFormat.yMMMd().add_jm().format(_report!.generatedAt)}',
                      style: AppTypography.bodySmall,
                    ),
                    const Divider(height: 24),
                    _row('Gross Sales', '$currency${_report!.grossSales.toStringAsFixed(2)}'),
                    _row('Net Sales', '$currency${_report!.netSales.toStringAsFixed(2)}'),
                    _row('Tax Collected', '$currency${_report!.taxCollected.toStringAsFixed(2)}'),
                    _row('Transactions', '${_report!.transactionCount}'),
                    _row('Avg Ticket', '$currency${_report!.averageTicket.toStringAsFixed(2)}'),
                    _row('Discounts', '-$currency${_report!.totalDiscounts.toStringAsFixed(2)}'),
                    if (_report!.voidCount > 0) ...[
                      _row('Voids', '${_report!.voidCount} (-$currency${_report!.voidAmount.toStringAsFixed(2)})'),
                    ],
                    const Divider(height: 24),
                    if (_report!.paymentBreakdownJson != null) ...[
                      Text('Payment Breakdown',
                          style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...() {
                        final breakdown = jsonDecode(_report!.paymentBreakdownJson!) as Map<String, dynamic>;
                        return breakdown.entries.map((e) =>
                          _row(e.key, '$currency${(e.value as num).toStringAsFixed(2)}'),
                        );
                      }(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyMedium),
          Text(value, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
