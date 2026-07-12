import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../../core/utils/responsive.dart';
import 'app_empty_state.dart';

/// Responsive data table — on mobile renders as cards, on desktop as a
/// proper table with scrollable columns.
///
/// ```dart
/// AppTableView(
///   columns: const ['Name', 'Price', 'Qty'],
///   rows: products.map((p) => [p.name, '\$${p.mrpPrice}', '10']).toList(),
///   onRowTap: (row) => print(row),
/// )
/// ```
class AppTableView extends StatelessWidget {
  final List<String> columns;
  final List<List<String>> rows;
  final void Function(int index)? onRowTap;
  final void Function(int index)? onRowDelete;
  final String? emptyTitle;
  final String? emptySubtitle;
  final IconData? emptyIcon;
  final bool loading;
  final Widget? header;

  const AppTableView({
    super.key,
    required this.columns,
    required this.rows,
    this.onRowTap,
    this.onRowDelete,
    this.emptyTitle,
    this.emptySubtitle,
    this.emptyIcon,
    this.loading = false,
    this.header,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (rows.isEmpty) {
      return AppEmptyState(
        icon: emptyIcon ?? Icons.inbox_outlined,
        title: emptyTitle ?? 'No data',
        subtitle: emptySubtitle,
      );
    }

    if (Responsive.isDesktop(context)) {
      return _DesktopTable(
        columns: columns,
        rows: rows,
        onRowTap: onRowTap,
        onRowDelete: onRowDelete,
        header: header,
      );
    }

    return _MobileCardList(
      columns: columns,
      rows: rows,
      onRowTap: onRowTap,
      onRowDelete: onRowDelete,
      header: header,
    );
  }
}

class _DesktopTable extends StatelessWidget {
  final List<String> columns;
  final List<List<String>> rows;
  final void Function(int)? onRowTap;
  final void Function(int)? onRowDelete;
  final Widget? header;

  const _DesktopTable({
    required this.columns,
    required this.rows,
    this.onRowTap,
    this.onRowDelete,
    this.header,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (header != null) ...[header!, AppSpacing.gapMd],
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: SingleChildScrollView(
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(AppColors.grey50),
                dataRowColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.hovered))
                    return AppColors.grey50;
                  return AppColors.white;
                }),
                columnSpacing: AppSpacing.xl,
                horizontalMargin: AppSpacing.lg,
                columns: columns
                    .map(
                      (col) => DataColumn(
                        label: Text(
                          col,
                          style: AppTypography.labelMedium.copyWith(
                            color: AppColors.grey600,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                rows: rows.asMap().entries.map((entry) {
                  final i = entry.key;
                  final row = entry.value;
                  return DataRow(
                    onSelectChanged: onRowTap != null
                        ? (_) => onRowTap!(i)
                        : null,
                    cells: [
                      for (var j = 0; j < row.length; j++)
                        DataCell(
                          Text(
                            row[j],
                            style: j == 0
                                ? AppTypography.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w500,
                                  )
                                : AppTypography.bodyMedium,
                          ),
                        ),
                      if (onRowDelete != null)
                        DataCell(
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              size: 18,
                              color: AppColors.grey400,
                            ),
                            onPressed: () => onRowDelete!(i),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MobileCardList extends StatelessWidget {
  final List<String> columns;
  final List<List<String>> rows;
  final void Function(int)? onRowTap;
  final void Function(int)? onRowDelete;
  final Widget? header;

  const _MobileCardList({
    required this.columns,
    required this.rows,
    this.onRowTap,
    this.onRowDelete,
    this.header,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (header != null) header!,
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.sm),
            itemCount: rows.length,
            itemBuilder: (context, i) {
              final row = rows[i];
              return Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: InkWell(
                  onTap: onRowTap != null ? () => onRowTap!(i) : null,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var j = 0; j < row.length; j++)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: AppSpacing.xs,
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        child: Text(
                                          columns[j],
                                          style: AppTypography.labelSmall
                                              .copyWith(
                                                color: AppColors.grey500,
                                              ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          row[j],
                                          style: AppTypography.bodySmall,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (onRowDelete != null)
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              size: 18,
                              color: AppColors.grey400,
                            ),
                            onPressed: () => onRowDelete!(i),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
