import 'package:flutter/material.dart';

/// Single source of truth for ALL colors in the app.
///
/// Usage:
/// ```dart
/// Text('Hello', style: TextStyle(color: AppColors.grey600))
/// Container(color: AppColors.primary)
/// ```
///
/// **DO NOT** use raw `Color(0x...)` or `Colors.xxx` anywhere else.
/// Always reference this class.
abstract final class AppColors {
  // ── Brand ──────────────────────────────────────────────────────
  static const Color primary = Color(0xFF30A8CF);
  static const Color primaryLight = Color(0xFF5BC0E5);
  static const Color primaryDark = Color(0xFF227A96);

  static const Color secondary = Color(0xFF4AC3A1);
  static const Color secondary2 = Color(0xFF74B952);
  static const Color accent = Color(0xFF705EE0);

  // ── Semantic ───────────────────────────────────────────────────
  static const Color success = Color(0xFF4AC3A1);
  static const Color warning = Color(0xFFF5A142);
  static const Color error = Color(0xFFEF6850);
  static const Color info = Color(0xFF2F5EC2);

  // ── Menu tile colors ──────────────────────────────────────────
  static const Color menuPrimary = Color(0xFF30A8CF);
  static const Color menuCategories = Color(0xFFD98049);
  static const Color menuKitchen = Color(0xFF4AC3A1);
  static const Color menuInventory = Color(0xFF705EE0);
  static const Color menuCustomers = Color(0xFF2FC289);
  static const Color menuStaff = Color(0xFFC2592F);
  static const Color menuDining = Color(0xFFEF6850);
  static const Color menuOrders = Color(0xFFF5A142);
  static const Color menuPayments = Color(0xFF2F5EC2);
  static const Color menuData = Color(0xFFEF9050);
  static const Color menuSettings = Color(0xFF222222);

  // ── Neutrals ──────────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey50 = Color(0xFFF8F9FA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFD5D5D5);
  static const Color grey400 = Color(0xFFA5A5A5);
  static const Color grey500 = Color(0xFF858585);
  static const Color grey600 = Color(0xFF666666);
  static const Color grey700 = Color(0xFF454545);
  static const Color grey800 = Color(0xFF2F2F2F);
  static const Color grey900 = Color(0xFF151515);
  static const Color black = Color(0xFF000000);

  // ── Shadcn-style semantic tokens ──────────────────────────────
  static const Color background = white;
  static const Color foreground = grey900;
  static const Color card = white;
  static const Color cardForeground = grey900;
  static const Color popover = white;
  static const Color popoverForeground = grey900;
  static const Color muted = grey100;
  static const Color mutedForeground = grey500;
  static const Color border = grey200;
  static const Color input = grey200;
  static const Color ring = primary;
  static const Color destructive = Color(0xFFEF6850);
  static const Color destructiveForeground = white;

  // ── Legacy aliases (temporary — remove after full migration) ──
  static Color get white900 => grey100;
  static Color get white800 => grey300;
  static Color get white600 => grey400;
  static Color get white500 => grey500;
  static Color get black900 => grey900;
  static Color get black800 => grey800;
  static Color get black600 => grey700;
  static Color get black500 => grey600;
  static Color get cyan => primary;
  static Color get green => success;
  static Color get yellow => warning;
  static Color get red => error;
}
