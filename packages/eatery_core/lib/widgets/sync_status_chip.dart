import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/eatery_core.dart';

/// A small chip that displays the current sync connection status.
///
/// Shows a coloured dot + label. Tapping opens the [SyncHostSettingsSheet]
/// on leaf devices (where the address can be changed).
class SyncStatusChip extends ConsumerWidget {
  const SyncStatusChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(syncStatusProvider);
    if (status == null) return const SizedBox.shrink();

    final (color, label) = switch (status.connectionState) {
      HostConnectionState.connected => (Colors.green, 'Synced'),
      HostConnectionState.connecting => (Colors.orange, 'Connecting…'),
      HostConnectionState.reconnecting => (Colors.orange, 'Reconnecting…'),
      HostConnectionState.disconnected => (Colors.red, 'Offline'),
    };

    final role = status.role;
    if (role == SyncRole.host) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => SyncHostSettingsSheet.show(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color.withValues(alpha: 0.9),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
