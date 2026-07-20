import 'package:flutter/material.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/theme/app_spacing.dart';
import 'package:eatery_core/theme/app_typography.dart';

/// A selectable card with radio-style selection.
///
/// Uses [groupValue] + [value] + [onChanged] pattern like Flutter's [Radio].
/// All visual properties derive from design tokens.
///
/// ```dart
/// AppSelectCard(
///   header: 'Plan',
///   title: 'Free',
///   highlights: ['5 users', '1 GB storage'],
///   footer: 'Free forever',
///   value: plan,
///   groupValue: selectedPlan,
///   onChanged: (v) => setState(() => selectedPlan = v),
/// )
/// ```
class AppSelectCard<T> extends StatelessWidget {
  final String header;
  final String title;
  final List<String>? highlights;
  final String footer;
  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;
  final Widget? child;

  const AppSelectCard({
    super.key,
    required this.header,
    required this.title,
    this.highlights,
    required this.footer,
    required this.value,
    this.groupValue,
    this.onChanged,
    this.child,
  });

  bool get _selected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChanged != null ? () => onChanged!(value) : null,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(AppSpacing.selectCardRadius),
          border: Border.all(
            color: _selected
                ? AppColors.selectCardRadioOuter
                : AppColors.selectCardRadioUnselectedBorder,
            width: _selected ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(header, style: AppTypography.selectCardHeader),
                  _selected
                      ? SizedBox(
                          width: AppSpacing.selectCardRadioSize,
                          height: AppSpacing.selectCardRadioSize,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                  width: AppSpacing.selectCardRadioSize,
                                  height: AppSpacing.selectCardRadioSize,
                                  decoration: BoxDecoration(
                                    color: AppColors.selectCardRadioOuter,
                                    borderRadius: BorderRadius.all(
                                      Radius.elliptical(
                                        AppSpacing.selectCardRadioSize,
                                        AppSpacing.selectCardRadioSize,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: AppSpacing.selectCardRadioOffset,
                                left: AppSpacing.selectCardRadioOffset,
                                child: Container(
                                  width: AppSpacing.selectCardRadioInner,
                                  height: AppSpacing.selectCardRadioInner,
                                  decoration: BoxDecoration(
                                    color: AppColors.selectCardRadioInner,
                                    borderRadius: BorderRadius.all(
                                      Radius.elliptical(
                                        AppSpacing.selectCardRadioInner,
                                        AppSpacing.selectCardRadioInner,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          width: AppSpacing.selectCardRadioSize,
                          height: AppSpacing.selectCardRadioSize,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.selectCardRadioUnselectedBorder,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.elliptical(
                                AppSpacing.selectCardRadioSize,
                                AppSpacing.selectCardRadioSize,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
              SizedBox(height: AppSpacing.md),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTypography.selectCardTitle,
              ),
              SizedBox(height: AppSpacing.md),
              if (highlights != null)
                Wrap(
                  spacing: AppSpacing.iconGapSm,
                  runSpacing: AppSpacing.iconGapSm,
                  children: [
                    for (var highlight in highlights!)
                      Container(
                        padding: AppSpacing.badgePadding,
                        decoration: BoxDecoration(
                          color: AppColors.selectCardRadioOuter.withValues(
                            alpha: 0.2,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.elliptical(4, 4),
                          ),
                        ),
                        child: Text(
                          highlight,
                          style: AppTypography.selectCardHighlight.copyWith(
                            color: AppColors.selectCardRadioOuter,
                          ),
                        ),
                      ),
                  ],
                ),
              SizedBox(height: AppSpacing.md),
              if (child != null && _selected) child!,
              if (child != null && _selected) SizedBox(height: AppSpacing.md),
              Text(footer, style: AppTypography.selectCardHeader),
            ],
          ),
        ),
      ),
    );
  }
}
