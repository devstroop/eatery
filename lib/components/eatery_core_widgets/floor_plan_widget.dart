import 'package:flutter/material.dart';
import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/theme/app_spacing.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/theme/app_typography.dart';

/// A scrollable floor plan that positions dining tables on a canvas
/// using their [DiningTable.posX] / [DiningTable.posY] coordinates.
class FloorPlanWidget extends StatelessWidget {
  final List<DiningTable> tables;
  final void Function(DiningTable table)? onTableTap;
  final void Function(DiningTable table, Offset newPos)? onTableMoved;

  static const double _tableSize = 60;
  static const double _canvasSize = 1200;

  const FloorPlanWidget({
    super.key,
    required this.tables,
    this.onTableTap,
    this.onTableMoved,
  });

  @override
  Widget build(BuildContext context) {
    final positioned = tables
        .where((t) => t.posX != null && t.posY != null)
        .toList();
    final unpositioned = tables
        .where((t) => t.posX == null || t.posY == null)
        .toList();

    return Column(
      children: [
        if (positioned.isNotEmpty)
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: SizedBox(
                  width: _canvasSize,
                  height: _canvasSize,
                  child: Stack(
                    children: [
                      // Grid background
                      CustomPaint(
                        size: const Size(_canvasSize, _canvasSize),
                        painter: _GridPainter(),
                      ),
                      // Tables
                      ...positioned.map(
                        (t) => Positioned(
                          left: t.posX!,
                          top: t.posY!,
                          child: onTableMoved != null
                              ? _DraggableTable(
                                  table: t,
                                  tableSize: _tableSize,
                                  onTableTap: onTableTap,
                                  onMoved: (offset) => onTableMoved!(t, offset),
                                )
                              : _TableWidget(
                                  table: t,
                                  size: _tableSize,
                                  onTap: onTableTap != null
                                      ? () => onTableTap!(t)
                                      : null,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        if (positioned.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 64, color: AppColors.grey400),
                  AppSpacing.gapLg,
                  Text(
                    'No tables positioned yet',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.grey600,
                    ),
                  ),
                  AppSpacing.gapSm,
                  Text(
                    'Edit a table to set its position on the floor plan',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (unpositioned.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            color: AppColors.grey100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unplaced tables (${unpositioned.length})',
                  style: AppTypography.labelLarge,
                ),
                AppSpacing.gapXs,
                Wrap(
                  spacing: 8,
                  children: unpositioned
                      .map((t) => Chip(label: Text(t.name), onDeleted: () {}))
                      .toList(),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Painter for the grid background.
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.grey200
      ..strokeWidth = 0.5;

    const gridSize = 60.0;
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter oldDelegate) => false;
}

/// Static table widget on the floor plan.
class _TableWidget extends StatelessWidget {
  final DiningTable table;
  final double size;
  final VoidCallback? onTap;

  const _TableWidget({required this.table, required this.size, this.onTap});

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(table.status);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: statusColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: statusColor, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              table.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: statusColor,
              ),
            ),
            if (table.orderId != null)
              Icon(Icons.restaurant, size: 16, color: statusColor),
          ],
        ),
      ),
    );
  }

  Color _statusColor(DiningTableStatus status) {
    switch (status) {
      case DiningTableStatus.available:
        return AppColors.success;
      case DiningTableStatus.occupied:
        return AppColors.warning;
      case DiningTableStatus.reserved:
        return AppColors.info;
      case DiningTableStatus.inactive:
        return AppColors.grey600;
    }
  }
}

/// Draggable version of the table widget for edit mode.
class _DraggableTable extends StatelessWidget {
  final DiningTable table;
  final double tableSize;
  final void Function(DiningTable table)? onTableTap;
  final void Function(Offset offset)? onMoved;

  const _DraggableTable({
    required this.table,
    required this.tableSize,
    this.onTableTap,
    this.onMoved,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        final newPos = Offset(
          (table.posX ?? 0) + details.delta.dx,
          (table.posY ?? 0) + details.delta.dy,
        );
        onMoved?.call(newPos);
      },
      onTap: () => onTableTap?.call(table),
      child: _TableWidget(
        table: table,
        size: tableSize,
        onTap: () => onTableTap?.call(table),
      ),
    );
  }
}
