import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../../core/utils/responsive.dart';

/// Consistent page layout wrapper used by every screen in the app.
///
/// Automatically constrains content on desktop while allowing full-width
/// on mobile. Provides a standard AppBar with back navigation.
///
/// ```dart
/// AppPageShell(
///   title: 'Products',
///   color: KColors.tertiary,
///   actions: [IconButton(...)],
///   child: ListView(...),
/// )
/// ```
class AppPageShell extends StatelessWidget {
  final String title;
  final Color? color;
  final List<Widget>? actions;
  final Widget child;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool showBack;
  final bool resizeToAvoidBottomInset;
  final bool fullWidth;
  final Color? backgroundColor;

  const AppPageShell({
    super.key,
    required this.title,
    this.color,
    this.actions,
    required this.child,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.showBack = true,
    this.resizeToAvoidBottomInset = true,
    this.fullWidth = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.grey200,
      appBar: AppBar(
        backgroundColor: color ?? AppColors.primary,
        foregroundColor: AppColors.white,
        title: Text(title),
        leading: showBack
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        actions: actions,
      ),
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: isDesktop && !fullWidth
          ? Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: child,
              ),
            )
          : child,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
