import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import 'app_button.dart';
import '../utils/responsive.dart';

enum MessageType { success, error, warning, info }

extension MessageTypeExtension on MessageType {
  String get value {
    switch (this) {
      case MessageType.success:
        return 'Success';
      case MessageType.error:
        return 'Error';
      case MessageType.warning:
        return 'Warning';
      case MessageType.info:
        return 'Info';
    }
  }

  IconData get icon {
    switch (this) {
      case MessageType.success:
        return Icons.check_circle;
      case MessageType.error:
        return Icons.error;
      case MessageType.warning:
        return Icons.warning;
      case MessageType.info:
        return Icons.info;
    }
  }

  Color get color {
    switch (this) {
      case MessageType.success:
        return AppColors.success;
      case MessageType.error:
        return AppColors.error;
      case MessageType.warning:
        return AppColors.warning;
      case MessageType.info:
        return AppColors.info;
    }
  }
}

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

  /// Convenience: shows a message dialog with icon based on [MessageType].
  /// Replaces [showMessageDialog].
  static Future<bool?> showMessage(
    BuildContext context, {
    required String message,
    required MessageType type,
    VoidCallback? onConfirm,
  }) {
    return show(
      context,
      icon: type.icon,
      iconColor: type.color,
      title: type.value,
      content: message,
      confirmLabel: 'OK',
      onConfirm: onConfirm,
    );
  }

  /// Convenience: shows a confirmation dialog.
  /// Replaces [showConfirmationDialog].
  static Future<bool?> showConfirmation(
    BuildContext context, {
    required String title,
    required String content,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return show(
      context,
      title: title,
      content: content,
      confirmLabel: 'Confirm',
      cancelLabel: 'Cancel',
      onConfirm: onConfirm,
      onCancel: onCancel,
    );
  }

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
                  AppSpacing.gapSm,
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
          if (destructive)
            AppButton.destructive(
              label: confirmLabel,
              onPressed: () {
                onConfirm?.call();
                Navigator.pop(ctx, true);
              },
            )
          else
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
