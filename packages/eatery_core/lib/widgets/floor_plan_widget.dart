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

class _TableWidget extends StatelessWidget {
  final DiningTable table;
  final double size;
  final VoidCallback? onTap;

  const _TableWidget({required this.table, required this.size, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isCircle = table.shape == 1;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: table.status.color.withValues(alpha: 0.2),
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircle ? null : BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(color: table.status.color, width: 2),
        ),
        child: Center(
          child: Text(
            table.name,
            style: AppTypography.labelSmall.copyWith(
              color: table.status.color,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _DraggableTable extends StatelessWidget {
  final DiningTable table;
  final double tableSize;
  final void Function(DiningTable table)? onTableTap;
  final void Function(Offset newPos)? onMoved;

  const _DraggableTable({
    required this.table,
    required this.tableSize,
    this.onTableTap,
    this.onMoved,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanEnd: (details) {
        if (onMoved != null) {
          final renderBox = context.findRenderObject() as RenderBox;
          final localPos = renderBox.localToGlobal(Offset.zero);
          onMoved!(localPos);
        }
      },
      child: _TableWidget(
        table: table,
        size: tableSize,
        onTap: onTableTap != null ? () => onTableTap!(table) : null,
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.grey300.withValues(alpha: 0.5)
      ..strokeWidth = 0.5;

    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
