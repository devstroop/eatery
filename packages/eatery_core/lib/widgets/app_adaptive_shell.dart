import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';

/// Destination for adaptive navigation.
class AppNavDestination {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final Widget page;
  final List<AppNavDestination>? children;

  const AppNavDestination({
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.page,
    this.children,
  });
}

/// Adaptive scaffold that switches navigation pattern based on screen width.
///
/// - **Mobile** (< 600px): Bottom Navigation Bar
/// - **Tablet** (600-900px): Navigation Rail + content
/// - **Desktop** (> 900px): Persistent drawer + content
///
/// ```dart
/// AppAdaptiveShell(
///   destinations: [
///     AppNavDestination(icon: Icons.home, label: 'Dashboard', page: HomePage()),
///     AppNavDestination(icon: Icons.receipt, label: 'Orders', page: OrdersPage()),
///   ],
/// )
/// ```
class AppAdaptiveShell extends StatefulWidget {
  final List<AppNavDestination> destinations;
  final int initialIndex;
  final String? title;
  final Widget? Function(BuildContext)? header;

  const AppAdaptiveShell({
    super.key,
    required this.destinations,
    this.initialIndex = 0,
    this.title,
    this.header,
  });

  @override
  State<AppAdaptiveShell> createState() => _AppAdaptiveShellState();
}

class _AppAdaptiveShellState extends State<AppAdaptiveShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);

    if (isDesktop) return _desktopLayout();
    if (isTablet) return _tabletLayout();
    return _mobileLayout();
  }

  // ── Mobile: Bottom Navigation ─────────────────────────────────
  Widget _mobileLayout() {
    return Scaffold(
      body: widget.destinations[_currentIndex].page,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: widget.destinations
            .map(
              (d) => NavigationDestination(
                icon: Icon(d.icon),
                selectedIcon: d.activeIcon != null ? Icon(d.activeIcon) : null,
                label: d.label,
              ),
            )
            .toList(),
      ),
    );
  }

  // ── Tablet: Navigation Rail ────────────────────────────────────
  Widget _tabletLayout() {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _currentIndex,
            onDestinationSelected: (i) => setState(() => _currentIndex = i),
            labelType: NavigationRailLabelType.all,
            leading: widget.header?.call(context),
            destinations: widget.destinations
                .map(
                  (d) => NavigationRailDestination(
                    icon: Icon(d.icon),
                    selectedIcon: d.activeIcon != null
                        ? Icon(d.activeIcon)
                        : null,
                    label: Text(d.label),
                  ),
                )
                .toList(),
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(child: widget.destinations[_currentIndex].page),
        ],
      ),
    );
  }

  // ── Desktop: Persistent Drawer ─────────────────────────────────
  Widget _desktopLayout() {
    return Scaffold(
      body: Row(
        children: [
          // Persistent sidebar
          SizedBox(
            width: 260,
            child: Material(
              color: AppColors.white,
              child: Column(
                children: [
                  // Header
                  if (widget.header != null)
                    widget.header!.call(context) ?? const SizedBox.shrink(),
                  // Navigation items
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.sm,
                      ),
                      itemCount: widget.destinations.length,
                      itemBuilder: (context, i) {
                        final d = widget.destinations[i];
                        final selected = i == _currentIndex;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                          child: Material(
                            color: selected
                                ? AppColors.primary.withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusMd,
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusMd,
                              ),
                              onTap: () => setState(() => _currentIndex = i),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.sm,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      d.activeIcon ?? d.icon,
                                      size: 22,
                                      color: selected
                                          ? AppColors.primary
                                          : AppColors.grey500,
                                    ),
                                    const SizedBox(width: AppSpacing.md),
                                    Text(
                                      d.label,
                                      style: AppTypography.bodyMedium.copyWith(
                                        fontWeight: selected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        color: selected
                                            ? AppColors.primary
                                            : AppColors.grey700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const VerticalDivider(width: 1, thickness: 1),
          // Content
          Expanded(child: widget.destinations[_currentIndex].page),
        ],
      ),
    );
  }
}
