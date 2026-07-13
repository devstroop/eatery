import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eatery_core/eatery_core.dart';

/// A bottom sheet that displays and allows changing the sync host address.
class SyncHostSettingsSheet extends ConsumerStatefulWidget {
  const SyncHostSettingsSheet({super.key});

  /// Shows the sheet from [context].
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (_) => const SyncHostSettingsSheet(),
    );
  }

  @override
  ConsumerState<SyncHostSettingsSheet> createState() =>
      _SyncHostSettingsSheetState();
}

class _SyncHostSettingsSheetState
    extends ConsumerState<SyncHostSettingsSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final store = ref.read(eateryStoreProvider);
    final config = SyncHostConfig(store);
    _controller = TextEditingController(text: config.getHostAddress());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final address = _controller.text.trim();
    if (address.isEmpty) return;
    final store = ref.read(eateryStoreProvider);
    SyncHostConfig(store).setHostAddress(address);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sync host set to $address — restart to apply')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Sync Host', style: theme.textTheme.titleLarge),
          AppSpacing.gapMd,
          Text(
            'Enter the IP address or hostname of the admin device running '
            'the sync server. Changes take effect after restart.',
            style: theme.textTheme.bodySmall,
          ),
          AppSpacing.gapSm,
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Host Address',
              hintText: '192.168.1.100',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.url,
            autofocus: true,
          ),
          AppSpacing.gapMd,
          ElevatedButton(onPressed: _save, child: const Text('Save')),
        ],
      ),
    );
  }
}
