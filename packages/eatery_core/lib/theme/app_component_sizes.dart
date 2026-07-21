// ── [code-token] 2026-07-22 ──
// Action: Created component size token file per plan §1.4
// Status: done
// Next: code-component consumes these in AppButton, AppTextField, AppCard

/// Component-specific dimension tokens.
///
/// Separate from [AppSpacing] because these represent fixed
/// component dimensions, not spacing scale values.
///
/// ```dart
/// SizedBox(height: AppComponentSizes.buttonHeightMd)
/// ```
abstract final class AppComponentSizes {
  // ── Button ─────────────────────────────────────────────────────
  static const double buttonHeightSm = 36;
  static const double buttonHeightMd = 48;
  static const double buttonHeightLg = 56;

  // ── Input ──────────────────────────────────────────────────────
  static const double fieldHeight = 48;

  // ── Card ───────────────────────────────────────────────────────
  static const double cardMinHeight = 120;
}
