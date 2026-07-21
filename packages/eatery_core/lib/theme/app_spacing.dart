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

  // ── Border radius (shadcn/ui-style) ──────────────────────────
  static const double radiusSm = 4;
  static const double radiusMd = 8;
  static const double radiusLg = 12;
  static const double radiusXl = 16;
  static const double radiusFull = 9999;

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
  // ── [code-token] 2026-07-22 ──
  // Action: Fixed cardPadding 12→16 to match plan §1.4
  // Status: done
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);
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

  // ── Button ─────────────────────────────────────────────────────
  static const double buttonHeightSm = 36;
  static const double buttonHeightMd = 48;
  static const double buttonHeightLg = 56;
  static const double buttonRadius = radiusLg;

  static const EdgeInsets buttonPaddingSm = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  );
  static const EdgeInsets buttonPaddingLg = EdgeInsets.symmetric(
    horizontal: 32,
    vertical: 16,
  );

  // ── Icon ───────────────────────────────────────────────────────
  static const double iconSizeSm = 16;
  static const double iconSizeMd = 24;
  static const double iconSizeLg = 32;
  static const double iconGapSm = 6;
  static const double iconGapMd = 8;
  static const double iconGapLg = 12;

  // ── Card ───────────────────────────────────────────────────────
  static const double cardRadius = radiusLg;

  // ── SelectCard ─────────────────────────────────────────────────
  static const double selectCardRadius = 6;
  static const double selectCardRadioSize = 24;
  static const double selectCardRadioInner = 10;
  static const double selectCardRadioOffset = 7;

  // ── Input field ────────────────────────────────────────────────
  static const double fieldHeight = 48;

  // ── TextField ──────────────────────────────────────────────────
  static const double fieldRadius = radiusLg;
  static const double fieldLabelGap = xs;

  // ── BottomSheet grip ───────────────────────────────────────────
  static const double bottomSheetGripWidth = 60;
  static const double bottomSheetGripHeight = 5;
  static const double bottomSheetGripRadius = 2;
  static const EdgeInsets bottomSheetGripMargin = EdgeInsets.fromLTRB(
    0,
    8,
    0,
    16,
  );

  // ── Category chip ──────────────────────────────────────────────
  static const EdgeInsets categoryChipPadding = EdgeInsets.symmetric(
    horizontal: 8,
  );
  static const EdgeInsets categoryChipImagePadding = EdgeInsets.symmetric(
    vertical: 6,
    horizontal: 6,
  );
  static const double categoryChipRadius = radiusLg;

  // ── Notification ───────────────────────────────────────────────
  static const double notificationHeight = 70;
  static const double notificationRadius = radiusMd;

  // ── Badge ──────────────────────────────────────────────────────
  static const EdgeInsets badgePadding = EdgeInsets.all(6);

  // ── Order-type button ──────────────────────────────────────────
  static const double orderTypeButtonGap = 6;

  // ── Product card ───────────────────────────────────────────────
  static const double cardGapY = 9;
  static const double cardBadgeOffset = 12;
  static const double productCardRadius = 6;
  static const double productCardMargin = 9;
  static const double productCardInfoPad = 6;
  static const double productCardIconSize = 18;
  static const double productCardCartHSym = 1;
  static const double productCardCartVSym = 0.5;
  static const double productCardQtyGap = 4;
}
