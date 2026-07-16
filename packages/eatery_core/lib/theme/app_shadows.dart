import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Single source of truth for ALL shadows in the app.
///
/// ```dart
/// Container(decoration: BoxDecoration(boxShadow: AppShadows.sm))
/// ```
abstract final class AppShadows {
  /// Subtle shadow — cards, containers
  static const List<BoxShadow> sm = [
    BoxShadow(color: Color(0x14000000), blurRadius: 4, offset: Offset(0, 1)),
  ];

  /// Medium shadow — raised cards, dialogs
  static const List<BoxShadow> md = [
    BoxShadow(color: Color(0x22000000), blurRadius: 8, offset: Offset(0, 2)),
  ];

  /// Large shadow — floating elements, modals
  static const List<BoxShadow> lg = [
    BoxShadow(color: Color(0x33000000), blurRadius: 16, offset: Offset(0, 4)),
  ];

  /// No shadow
  static const List<BoxShadow> none = [];

  // ── Component-specific shadows ─────────────────────────────────
  /// Elevated card (ProductCard, etc.)
  static const List<BoxShadow> cardElevated = [
    BoxShadow(
      color: AppColors.shadowBase,
      blurRadius: 6,
      offset: Offset(0, 4),
      spreadRadius: 1,
    ),
  ];

  /// Notification card
  static const List<BoxShadow> notification = [
    BoxShadow(color: AppColors.shadowDark, blurRadius: 4, offset: Offset(0, 2)),
  ];
}
