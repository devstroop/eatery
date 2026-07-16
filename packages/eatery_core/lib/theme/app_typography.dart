import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Single source of truth for ALL text styles in the app.
///
/// Follows a modular type scale. All sizes are in logical pixels.
/// Always reference this class — never use raw `TextStyle(fontSize: ...)`.
///
/// ```dart
/// Text('Hello', style: AppTypography.titleLarge)
/// ```
abstract final class AppTypography {
  // ── Display ────────────────────────────────────────────────────
  static const TextStyle displayLarge = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.25,
  );

  // ── Headlines ──────────────────────────────────────────────────
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.35,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  // ── Titles ─────────────────────────────────────────────────────
  static const TextStyle titleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // ── Body ───────────────────────────────────────────────────────
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  // ── Labels ─────────────────────────────────────────────────────
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  // ── Component-specific tokens ─────────────────────────────────
  /// Button labels
  static const TextStyle buttonLabelSm = labelLarge;
  static const TextStyle buttonLabelMd
      = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  static const TextStyle buttonLabelLg
      = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);

  /// Form fields
  static const TextStyle fieldLabel = labelMedium;
  static const TextStyle fieldValue = bodyMedium;

  /// Selectable card
  static const TextStyle selectCardHeader    = bodyMedium;
  static const TextStyle selectCardTitle
      = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  static const TextStyle selectCardHighlight = bodySmall;

  /// Order-type button label
  static const TextStyle orderTypeButton
      = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.grey800);

  /// Badge label
  static const TextStyle badgeLabel
      = TextStyle(fontSize: 10, fontWeight: FontWeight.w500);

  /// Product card
  static const TextStyle productCardName
      = TextStyle(fontSize: 12, fontWeight: FontWeight.w600);
  static const TextStyle productCardDesc
      = TextStyle(fontSize: 10, fontWeight: FontWeight.w400);
  static const TextStyle productCardPrice
      = TextStyle(fontSize: 12, fontWeight: FontWeight.bold);
  static const TextStyle productCardPriceStrike
      = TextStyle(fontSize: 10, fontWeight: FontWeight.w600, decoration: TextDecoration.lineThrough);

  // ── Responsive helpers ─────────────────────────────────────────
  /// For screen-width dependent sizing, use `Responsive.headlineSize(context)`
  /// from `core/utils/responsive.dart` instead of these.
}
