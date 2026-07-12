import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../theme/app_shadows.dart';
import 'app_button.dart';
import '../../core/utils/responsive.dart';

/// Responsive dialog/modal — on mobile shows a bottom sheet,
/// on desktop shows a centered dialog.
///
/// ```dart
/// AppDialog.show(
///   context,
///   title: 'Confirm',
///   content: 'Are you sure?',
///   onConfirm: () {},
/// )
/// ```
class AppDialog {
  /// Shows a confirmation dialog.
  /// Pass [icon] and [iconColor] to show an icon next to the title
  /// (mirrors [showMessageDialog] functionality).
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    String? content,
    IconData? icon,
    Color? iconColor,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool destructive = false,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: iconColor, size: 28),
                  const SizedBox(width: 8),
                  Text(title, style: AppTypography.titleMedium),
                ],
              )
            : Text(title, style: AppTypography.titleMedium),
        content: content != null
            ? Text(content, style: AppTypography.bodyMedium)
            : null,
        actions: [
          TextButton(
            onPressed: () {
              onCancel?.call();
              Navigator.pop(ctx, false);
            },
            child: Text(cancelLabel),
          ),
          AppButton.primary(
            label: confirmLabel,
            onPressed: () {
              onConfirm?.call();
              Navigator.pop(ctx, true);
            },
          ),
        ],
      ),
    );
  }

  /// Shows a bottom sheet on mobile, dialog on desktop.
  static Future<T?> showAdaptive<T>(
    BuildContext context, {
    required String title,
    required Widget child,
    List<Widget>? actions,
  }) {
    if (Responsive.isDesktop(context)) {
      return showDialog<T>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(title, style: AppTypography.titleMedium),
          content: SizedBox(width: 480, child: child),
          actions: actions,
        ),
      );
    }

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, scrollCtrl) => SingleChildScrollView(
            controller: scrollCtrl,
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.grey300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(title, style: AppTypography.titleMedium),
                const SizedBox(height: AppSpacing.lg),
                child,
                if (actions != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: actions,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
