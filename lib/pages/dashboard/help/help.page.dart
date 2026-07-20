import "package:flutter/material.dart";
import "package:eatery_core/theme/app_typography.dart";
import "package:eatery_core/theme/app_colors.dart";
import "package:eatery_core/theme/app_spacing.dart";
import "package:eatery/components/eatery_core_widgets/widgets.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class HelpPage extends ConsumerWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppPageShell(
      title: "Help",
      color: AppColors.primary,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section(
            "Getting Started",
            "Create your restaurant profile, add products, and set up staff to start taking orders.",
          ),
          _section(
            "Creating Orders",
            "Select a table or order type, browse the menu, add items to the cart, and checkout.",
          ),
          _section(
            "Managing Products",
            "Add kitchen dishes and inventory items. Group them into categories for easy browsing.",
          ),
          _section(
            "Employees & Access",
            "Each employee logs in with their own PIN. Admins can manage employees from Settings.",
          ),
          _section(
            "Reports",
            "Generate X and Z reports to track daily sales, taxes, and payment breakdowns.",
          ),
          _section(
            "Sync & Multi-Device",
            "Run the admin app as a sync host. Waiter, KDS, and Display apps connect automatically via mDNS.",
          ),
        ],
      ),
    );
  }

  Widget _section(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapXs,
          Text(body, style: AppTypography.bodyMedium),
          const Divider(height: 24),
        ],
      ),
    );
  }
}
