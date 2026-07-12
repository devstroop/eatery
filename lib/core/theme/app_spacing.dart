import 'package:flutter/material.dart';

/// Single source of truth for ALL spacing in the app.
///
/// Follows a 4px base unit scale. Always use these — never raw `SizedBox(height: 13)`.
///
/// ```dart
/// SizedBox(height: AppSpacing.md)
/// Padding(padding: AppSpacing.pagePadding)
/// ```
abstract final class AppSpacing {
  // ── Unit scale ─────────────────────────────────────────────────
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  // ── Common SizedBox shortcuts ─────────────────────────────────
  static const SizedBox gapXs = SizedBox(height: xs);
  static const SizedBox gapSm = SizedBox(height: sm);
  static const SizedBox gapMd = SizedBox(height: md);
  static const SizedBox gapLg = SizedBox(height: lg);
  static const SizedBox gapXl = SizedBox(height: xl);
  static const SizedBox gapXxl = SizedBox(height: xxl);

  // ── Page-level padding ────────────────────────────────────────
  static const EdgeInsets pageMobile = EdgeInsets.all(12);
  static const EdgeInsets pageTablet = EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 20,
  );
  static const EdgeInsets pageDesktop = EdgeInsets.symmetric(
    horizontal: 32,
    vertical: 24,
  );

  // ── Component padding ────────────────────────────────────────
  static const EdgeInsets cardPadding = EdgeInsets.all(12);
  static const EdgeInsets tilePadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 12,
  );
  static const EdgeInsets fieldPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 4,
  );
}
