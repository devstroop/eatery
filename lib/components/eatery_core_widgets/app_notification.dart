import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/theme/app_spacing.dart';
import 'package:eatery_core/theme/app_shadows.dart';
import 'package:eatery_core/theme/app_typography.dart';

/// A notification card used for in-app alerts and messages.
///
/// All visual properties derive from design tokens.
///
/// ```dart
/// AppNotification(
///   message: 'Order #42 is ready',
///   header: 'Kitchen',
///   showTimestamp: true,
///   onTap: () {},
/// )
/// ```
class AppNotification extends StatelessWidget {
  final String message;
  final bool showTimestamp;
  final String? header;
  final Widget? leading;
  final VoidCallback? onTap;

  const AppNotification({
    super.key,
    required this.message,
    this.showTimestamp = false,
    this.header,
    this.leading,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: AppSpacing.notificationHeight,
        decoration: BoxDecoration(
          color: AppColors.notificationBg,
          boxShadow: AppShadows.notification,
          borderRadius: BorderRadius.circular(AppSpacing.notificationRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (leading != null)
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                child: leading,
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 16, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          header ?? 'Assistant',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.white.withValues(alpha: 0.7),
                          ),
                        ),
                        if (showTimestamp)
                          Text(
                            DateFormat.jm().format(DateTime.now()),
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.white.withValues(alpha: 0.7),
                            ),
                          ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              message,
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
