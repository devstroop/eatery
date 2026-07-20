import 'package:flutter/material.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/theme/app_spacing.dart';
import 'package:eatery_core/theme/app_typography.dart';

/// The type of notification banner, which determines the status-colored border.
enum NotificationType { orderReady, orderStatusChanged, syncFailed, info }

/// A slide-down banner shown via [Overlay.insert] — no scaffold dependency.
///
/// Can be shown from any role at any widget depth.
///
/// ```dart
/// AppNotificationBanner.show(
///   context,
///   type: NotificationType.orderReady,
///   message: 'Order #42 — Table 3 is ready!',
///   onTap: () => router.pushNamed('viewOrder', pathParameters: {'id': '42'}),
///   autoDismiss: Duration(seconds: 5),
/// );
/// ```
class AppNotificationBanner {
  const AppNotificationBanner._();

  /// Shows a slide-down notification banner using [Overlay.insert].
  ///
  /// Returns a [VoidCallback] that can be called to dismiss the banner early.
  static VoidCallback show(
    BuildContext context, {
    required NotificationType type,
    required String message,
    String? subtitle,
    VoidCallback? onTap,
    Duration autoDismiss = const Duration(seconds: 5),
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => _BannerWidget(
        type: type,
        message: message,
        subtitle: subtitle,
        onTap: onTap,
        autoDismiss: autoDismiss,
        onDismiss: () => entry.remove(),
      ),
    );

    overlay.insert(entry);
    return () => entry.remove();
  }
}

class _BannerWidget extends StatefulWidget {
  final NotificationType type;
  final String message;
  final String? subtitle;
  final VoidCallback? onTap;
  final Duration autoDismiss;
  final VoidCallback onDismiss;

  const _BannerWidget({
    required this.type,
    required this.message,
    this.subtitle,
    this.onTap,
    required this.autoDismiss,
    required this.onDismiss,
  });

  @override
  State<_BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<_BannerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    if (widget.autoDismiss > Duration.zero) {
      Future.delayed(widget.autoDismiss, _dismiss);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismiss() {
    _controller.reverse().then((_) {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = switch (widget.type) {
      NotificationType.orderReady => AppColors.statusPreparing,
      NotificationType.orderStatusChanged => AppColors.statusPending,
      NotificationType.syncFailed => AppColors.error,
      NotificationType.info => AppColors.info,
    };

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Material(
          color: Colors.transparent,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GestureDetector(
                onTap: () {
                  widget.onTap?.call();
                  _dismiss();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.notificationBg,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border(
                      left: BorderSide(color: borderColor, width: 4),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: borderColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.message,
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (widget.subtitle != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                widget.subtitle!,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.white.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: _dismiss,
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: AppColors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
