import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eatery_core/eatery_core.dart';

/// Possible device roles.
enum DeviceRole {
  admin(
    'admin',
    'I\'m Staff',
    'Full POS & restaurant management',
    Icons.admin_panel_settings,
    AppColors.primary,
  ),
  kds(
    'kds',
    'Kitchen Display',
    'Real-time order feed for chefs',
    Icons.kitchen,
    AppColors.menuKitchen,
  ),
  display(
    'display',
    'Customer Display',
    'Order status for diners',
    Icons.tv,
    AppColors.secondary,
  );

  final String value;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const DeviceRole(
    this.value,
    this.title,
    this.subtitle,
    this.icon,
    this.color,
  );
}

/// Full-screen role picker shown on first launch when no [device_role] is set.
///
/// Three cards matching the app's visual language using [SelectableCard].
class RolePickerPage extends ConsumerWidget {
  const RolePickerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo / branding
                Image.asset('assets/logo.png', height: 48),
                AppSpacing.gapLg,
                Text(
                  'Welcome to Eatery',
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.grey900,
                  ),
                ),
                AppSpacing.gapSm,
                Text(
                  'Choose how this device will be used',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.grey600,
                  ),
                ),
                AppSpacing.gapXxl,
                // Role cards
                for (final role in DeviceRole.values) ...[
                  _RoleCard(role: role),
                  AppSpacing.gapMd,
                ],
                AppSpacing.gapLg,
                Text(
                  'You can change this later in Settings.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends ConsumerWidget {
  final DeviceRole role;

  const _RoleCard({required this.role});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        elevation: 0,
        child: InkWell(
          onTap: () => _selectRole(context, ref, role),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(color: AppColors.white600),
            ),
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                // Icon circle
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: role.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Icon(role.icon, color: role.color, size: 28),
                ),
                const SizedBox(width: AppSpacing.lg),
                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        role.title,
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.grey900,
                        ),
                      ),
                      AppSpacing.gapXs,
                      Text(
                        role.subtitle,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Chevron
                Icon(Icons.chevron_right, color: AppColors.grey400),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _selectRole(BuildContext context, WidgetRef ref, DeviceRole role) {
    ref.read(roleProvider.notifier).setRole(role.value);
    switch (role) {
      case DeviceRole.admin:
        context.goNamed('login');
      case DeviceRole.kds:
        context.goNamed('kds');
      case DeviceRole.display:
        context.goNamed('display');
    }
  }
}
