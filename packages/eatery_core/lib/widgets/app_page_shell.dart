import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../utils/responsive.dart';

/// Consistent page layout wrapper used by every screen in the app.
///
/// Uses a pure custom header — no native [AppBar]. On mobile the header
/// fills the full width. On tablet/desktop it's constrained to 720px and
/// centered, aligned with the content area.
///
/// ### Responsive action bar
///
/// Use [bottomAction] for form submit buttons (Save, Confirm, etc.).
/// On **mobile** it renders as a pinned [BottomAppBar] for thumb reach.
/// On **tablet / desktop** it moves into the header actions (top-right).
///
/// ### Custom title
///
/// Pass a [titleWidget] (e.g. a logo image) instead of [title] for
/// non-text headers. [subtitle] renders below the title on all breakpoints.
///
/// ```dart
/// AppPageShell(
///   title: 'Add Customer',
///   subtitle: 'New customer',
///   bottomAction: AppButton.primary(label: 'Save', onPressed: ...),
///   child: Form(...),
/// )
/// ```
class AppPageShell extends StatelessWidget {
  final String title;

  /// Optional widget replacing the text title — use for logos or rich headers.
  final Widget? titleWidget;

  final String? subtitle;
  final Color? color;
  final List<Widget>? actions;
  final Widget child;
  final Widget? floatingActionButton;

  /// Primary action button for the page (e.g. Save, Confirm).
  ///
  /// Renders as a pinned [BottomAppBar] on mobile, or in the header actions
  /// on tablet / desktop.
  final Widget? bottomAction;

  /// Raw bottom navigation bar — passed through to [Scaffold] on all
  /// breakpoints. Use for context info bars, not single action buttons.
  final Widget? bottomNavigationBar;
  final bool showBack;
  final bool resizeToAvoidBottomInset;
  final bool fullWidth;
  final Color? backgroundColor;
  final double contentMaxWidth;
  final double headerHeight;

  const AppPageShell({
    super.key,
    required this.title,
    this.titleWidget,
    this.subtitle,
    this.color,
    this.actions,
    required this.child,
    this.floatingActionButton,
    this.bottomAction,
    this.bottomNavigationBar,
    this.showBack = true,
    this.resizeToAvoidBottomInset = true,
    this.fullWidth = false,
    this.backgroundColor,
    this.contentMaxWidth = 720,
    this.headerHeight = 56,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final headerColor = color ?? AppColors.primary;
    final safeTop = MediaQuery.of(context).padding.top;
    final maxW = contentMaxWidth;
    final hHeight = subtitle != null
        ? (headerHeight * 1.21).ceilToDouble()
        : headerHeight;

    // ── Header actions: merged explicit + bottomAction (tablet/desktop) ──
    final headerActions = <Widget>[
      ...?actions,
      if (!isMobile && bottomAction != null) bottomAction!,
    ];

    // ── Bottom bar: bottomAction on mobile, or raw bar ──────────────────
    final bottomBar = isMobile && bottomAction != null
        ? BottomAppBar(
            color: AppColors.white,
            child: SizedBox(width: double.infinity, child: bottomAction!),
          )
        : bottomNavigationBar;

    // ── Title area ───────────────────────────────────────────────────────
    final titleArea =
        titleWidget ??
        (subtitle != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    subtitle!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              )
            : Text(
                title,
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.white,
                ),
              ));

    // ── Header row widget (shared by both breakpoints) ──────────────────
    Widget headerRow() {
      return SizedBox(
        height: hHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            children: [
              if (showBack)
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.white),
                  onPressed: () => Navigator.maybePop(context),
                ),
              Expanded(child: titleArea),
              if (headerActions.isNotEmpty)
                Row(mainAxisSize: MainAxisSize.min, children: headerActions),
            ],
          ),
        ),
      );
    }

    // ── Header: full-width on mobile, constrained on tablet+ ────────────
    final header = Container(
      color: headerColor,
      padding: EdgeInsets.only(top: safeTop),
      child: isMobile
          ? headerRow()
          : Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxW),
                child: headerRow(),
              ),
            ),
    );

    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.grey200,
      body: Column(
        children: [
          header,
          Expanded(
            child: !isMobile && !fullWidth
                ? Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxW),
                      child: child,
                    ),
                  )
                : child,
          ),
        ],
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }
}
