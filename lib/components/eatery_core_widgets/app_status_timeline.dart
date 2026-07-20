import 'package:flutter/material.dart';
import 'package:eatery_core/data/models/eatery_db.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/theme/app_spacing.dart';
import 'package:eatery_core/theme/app_typography.dart';

/// A vertical timeline widget that visualizes [OrderStatusHistory] transitions.
///
/// Each step shows: status badge → timestamp → staff name → reason (if voided).
///
/// ```dart
/// AppStatusTimeline(transitions: order.statusHistory)
/// ```
class AppStatusTimeline extends StatelessWidget {
  /// The status transitions to display, in chronological order.
  final List<OrderStatusHistory> transitions;

  /// Optional map of employeeId → displayName for resolving staff names.
  final Map<int, String>? employeeNames;

  const AppStatusTimeline({
    super.key,
    required this.transitions,
    this.employeeNames,
  });

  @override
  Widget build(BuildContext context) {
    if (transitions.isEmpty) {
      return const SizedBox.shrink();
    }

    final sorted = List<OrderStatusHistory>.from(transitions)
      ..sort((a, b) => a.changedAt.compareTo(b.changedAt));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text('Status History', style: AppTypography.titleSmall),
        ),
        ...List.generate(sorted.length, (i) {
          final entry = sorted[i];
          final isLast = i == sorted.length - 1;
          return _TimelineStep(
            entry: entry,
            isLast: isLast,
            employeeNames: employeeNames,
          );
        }),
      ],
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final OrderStatusHistory entry;
  final bool isLast;
  final Map<int, String>? employeeNames;

  const _TimelineStep({
    required this.entry,
    required this.isLast,
    this.employeeNames,
  });

  @override
  Widget build(BuildContext context) {
    final fromStatus = OrderStatus.fromId(entry.fromStatus);
    final toStatus = OrderStatus.fromId(entry.toStatus);
    final dotColor = OrderStatus.colorFor(toStatus);
    final formattedTime = _formatTimestamp(entry.changedAt);
    final changedBy = entry.changedByEmployeeId;
    final staffName = changedBy != null
        ? (employeeNames?[changedBy] ?? 'Employee #$changedBy')
        : null;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline gutter: dot + connector line
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 2, color: AppColors.timelineLine),
                  ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.sm,
                bottom: isLast ? 0 : AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _statusLabel(fromStatus, toStatus),
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formattedTime,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                  if (staffName != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      staffName,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.grey600,
                      ),
                    ),
                  ],
                  if (entry.reason != null && entry.reason!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Reason: ${entry.reason}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.error,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(OrderStatus from, OrderStatus to) {
    if (from == to) return to.name;
    if (to == OrderStatus.voided) {
      return '${from.name} → Voided';
    }
    return '${from.name} → ${to.name}';
  }

  String _formatTimestamp(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final amPm = dt.hour >= 12 ? 'PM' : 'AM';
    final min = dt.minute.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    return '$month/$day $hour:$min $amPm';
  }
}
