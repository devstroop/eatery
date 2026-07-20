import 'package:flutter/material.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/theme/app_typography.dart';

/// A step indicator + content area + button shell for multi-step forms.
///
/// Replaces the Body1–Body6 pattern in [CreateCompanyPage] and similar flows.
/// Supports conditional step skipping via [hiddenSteps].
///
/// ```dart
/// AppMultiStepForm(
///   steps: const ['Company', 'Auth', 'Taxation', 'Currency', 'Plan', 'Summary'],
///   currentStep: index,
///   totalSteps: 6,
///   hiddenSteps: {3},  // skip taxation-registration when no tax
///   onStepChanged: (i) => setState(() => index = i),
///   onNext: () => _validateAndAdvance(),
///   onBack: index > 0 ? () => setState(() => index--) : null,
///   isNextEnabled: true,
///   nextLabel: index == lastStep ? 'Submit' : 'Next',
///   child: bodies[index],
/// )
/// ```
class AppMultiStepForm extends StatelessWidget {
  /// Labels for each conceptual step (e.g. ['Company', 'Auth', ...]).
  /// The visible steps are derived by removing [hiddenSteps].
  final List<String> steps;

  /// The currently active step index (0-based, accounting for hidden steps).
  final int currentStep;

  /// Indices into [steps] that should be visually skipped.
  /// The [currentStep] is already adjusted to skip these.
  final Set<int> hiddenSteps;

  /// Called when the user taps a step dot or navigates.
  final ValueChanged<int> onStepChanged;

  /// Called when "Next" / "Submit" is pressed.
  final VoidCallback? onNext;

  /// Called when "Submit" is pressed on the last visible step.
  /// If null, [onNext] is called instead.
  final VoidCallback? onSubmit;

  /// Called when "Back" is pressed. If null, the back button is hidden.
  final VoidCallback? onBack;

  /// Whether the next/submit button is enabled.
  final bool isNextEnabled;

  /// Label for the forward button — defaults to 'Next' or 'Submit' on last step.
  final String? nextLabel;

  /// The content widget for the current step.
  final Widget child;

  /// Optional color for active step indicators.
  final Color? activeColor;

  const AppMultiStepForm({
    super.key,
    required this.steps,
    required this.currentStep,
    this.hiddenSteps = const {},
    required this.onStepChanged,
    this.onNext,
    this.onSubmit,
    this.onBack,
    this.isNextEnabled = true,
    this.nextLabel,
    required this.child,
    this.activeColor,
  });

  /// Returns the list of visible step labels (hidden steps excluded).
  List<String> get visibleSteps {
    final result = <String>[];
    for (int i = 0; i < steps.length; i++) {
      if (!hiddenSteps.contains(i)) {
        result.add(steps[i]);
      }
    }
    return result;
  }

  /// Returns the total number of visible steps.
  int get visibleStepCount => visibleSteps.length;

  /// Returns whether [currentStep] is the last visible step.
  bool get isLastStep => currentStep >= visibleStepCount - 1;

  /// Maps a visible step index back to the original [steps] index.
  int visibleToOriginal(int visibleIndex) {
    int original = -1;
    int found = -1;
    for (int i = 0; i < steps.length; i++) {
      if (!hiddenSteps.contains(i)) {
        found++;
        if (found == visibleIndex) {
          original = i;
          break;
        }
      }
    }
    return original;
  }

  @override
  Widget build(BuildContext context) {
    final visible = visibleSteps;
    final color = activeColor ?? AppColors.primary;

    return Column(
      children: [
        // Step indicator dots
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(visible.length, (i) {
              final isActive = i == currentStep;
              final isCompleted = i < currentStep;
              return _StepDot(
                label: visible[i],
                isActive: isActive,
                isCompleted: isCompleted,
                activeColor: color,
                isLast: i == visible.length - 1,
                onTap: () => onStepChanged(i),
              );
            }),
          ),
        ),
        const Divider(height: 1),
        // Content area
        Expanded(child: child),
        const Divider(height: 1),
        // Navigation buttons
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (onBack != null)
                Expanded(
                  child: OutlinedButton(
                    onPressed: onBack,
                    child: const Text('Back'),
                  ),
                ),
              if (onBack != null) const SizedBox(width: 16),
              Expanded(
                child: FilledButton(
                  onPressed: isNextEnabled
                      ? (isLastStep ? (onSubmit ?? onNext) : onNext)
                      : null,
                  child: Text(nextLabel ?? (isLastStep ? 'Submit' : 'Next')),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A single step indicator dot in the [AppMultiStepForm] header.
class _StepDot extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isCompleted;
  final Color activeColor;
  final bool isLast;
  final VoidCallback onTap;

  const _StepDot({
    required this.label,
    required this.isActive,
    required this.isCompleted,
    required this.activeColor,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dotColor = isCompleted
        ? AppColors.statusCompleted
        : (isActive ? activeColor : AppColors.grey300);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: isActive ? 14 : 10,
              height: isActive ? 14 : 10,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.statusCompleted
                    : (isActive ? activeColor : Colors.transparent),
                shape: BoxShape.circle,
                border: Border.all(color: dotColor, width: isActive ? 2.5 : 2),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 8, color: AppColors.white)
                  : null,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: isActive ? activeColor : AppColors.grey500,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
