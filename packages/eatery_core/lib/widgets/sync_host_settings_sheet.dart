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
  bool _discovering = false;

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

  Future<void> _discover() async {
    setState(() => _discovering = true);
    try {
      final hosts = await MdnsService.discoverHosts(timeout: const Duration(seconds: 4));
      if (!mounted) return;
      if (hosts.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No sync hosts found on the network')),
        );
      } else {
        _controller.text = hosts.first.ip;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Found host "${hosts.first.name}" at ${hosts.first.ip}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Discovery failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _discovering = false);
    }
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
            'the sync server, or tap Discover to find one automatically.',
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
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _discovering ? null : _discover,
                  icon: _discovering
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.search),
                  label: Text(_discovering ? 'Scanning…' : 'Discover'),
                ),
              ),
              AppSpacing.gapSm,
              Expanded(
                child: ElevatedButton(onPressed: _save, child: const Text('Save')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
