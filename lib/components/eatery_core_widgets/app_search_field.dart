import 'package:flutter/material.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery_core/theme/app_spacing.dart';

/// Search field with desktop keyboard shortcut hints.
///
/// On desktop, shows ⌘K/F hint. On mobile, behaves as a normal search field.
class AppSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmitted;
  final String hint;
  final bool autofocus;
  final FocusNode? focusNode;

  const AppSearchField({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.hint = 'Search...',
    this.autofocus = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        onSubmitted: (_) => onSubmitted?.call(),
        autofocus: autofocus,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.search, size: 20),
          suffixIcon: _buildShortcutHint(context),
          filled: true,
          fillColor: AppColors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: BorderSide(color: AppColors.grey200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: BorderSide(color: AppColors.grey200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget? _buildShortcutHint(BuildContext context) {
    // Platform-aware shortcut hint — only on desktop
    if (Theme.of(context).platform == TargetPlatform.android ||
        Theme.of(context).platform == TargetPlatform.iOS) {
      return null;
    }
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.grey300),
        ),
        child: Text(
          MediaQuery.of(context).size.width > 900 ? '⌘K' : '⌘F',
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.grey500,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}
