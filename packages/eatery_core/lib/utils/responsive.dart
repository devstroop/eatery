import 'package:flutter/material.dart';

/// Centralized responsive breakpoints & layout utilities.
///
/// Usage:
/// ```dart
/// if (Responsive.isDesktop(context)) ...
/// final cols = Responsive.gridColumns(context);
/// final gap  = Responsive.spacing(context);
/// ```
class Responsive {
  Responsive._();

  // ── Breakpoints ──────────────────────────────────────────────
  static const double mobileMax = 600;
  static const double tabletMax = 900;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileMax;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileMax &&
      MediaQuery.of(context).size.width < tabletMax;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletMax;

  // ── Grid columns ─────────────────────────────────────────────
  static int gridColumns(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w >= 1200) return 4;
    if (w >= tabletMax) return 3;
    if (w >= mobileMax) return 2;
    return 1;
  }

  // ── Spacing scale ────────────────────────────────────────────
  static double spacing(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w >= 1200) return 24;
    if (w >= tabletMax) return 20;
    if (w >= mobileMax) return 16;
    return 12;
  }

  // ── Typography ───────────────────────────────────────────────
  static double headlineSize(BuildContext context) => isDesktop(context)
      ? 32
      : isTablet(context)
      ? 28
      : 24;

  static double titleSize(BuildContext context) => isDesktop(context)
      ? 20
      : isTablet(context)
      ? 18
      : 16;

  static double bodySize(BuildContext context) => isDesktop(context)
      ? 16
      : isTablet(context)
      ? 14
      : 12;

  // ── Layout widgets ───────────────────────────────────────────
  /// Wraps [child] in a centered [ConstrainedBox] on desktop, plain on mobile.
  static Widget desktopConstrained({
    required BuildContext context,
    required Widget child,
    double maxWidth = 480,
  }) {
    if (!isDesktop(context)) return child;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
