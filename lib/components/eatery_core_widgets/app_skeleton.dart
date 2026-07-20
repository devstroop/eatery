import 'package:flutter/material.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:eatery_core/theme/app_spacing.dart';

/// Loading skeleton placeholders for shimmer effects.
///
/// ```dart
/// // Single line
/// AppSkeleton.line(width: 200)
///
/// // Card skeleton
/// AppSkeleton.card()
///
/// // Custom
/// AppSkeleton(width: 100, height: 100, borderRadius: 8)
/// ```
class AppSkeleton extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const AppSkeleton({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 4,
  });

  factory AppSkeleton.line({
    double width = double.infinity,
    double height = 14,
    double borderRadius = 4,
  }) => AppSkeleton(width: width, height: height, borderRadius: borderRadius);

  factory AppSkeleton.card({
    double width = double.infinity,
    double height = 120,
    double borderRadius = 12,
  }) => AppSkeleton(width: width, height: height, borderRadius: borderRadius);

  factory AppSkeleton.avatar({double size = 40, double borderRadius = 20}) =>
      AppSkeleton(width: size, height: size, borderRadius: borderRadius);

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller.drive(
        Tween(begin: 0.4, end: 0.8).chain(CurveTween(curve: Curves.easeInOut)),
      ),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: AppColors.grey200,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
      ),
    );
  }
}

/// Convenience widget for a list of skeleton cards.
class AppSkeletonList extends StatelessWidget {
  final int count;
  final double itemHeight;

  const AppSkeletonList({super.key, this.count = 5, this.itemHeight = 80});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      padding: const EdgeInsets.all(AppSpacing.md),
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: AppSkeleton(height: itemHeight, borderRadius: 12),
      ),
    );
  }
}
