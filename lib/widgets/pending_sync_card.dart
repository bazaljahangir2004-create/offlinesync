import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/connectivity_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/sync_provider.dart';

String _formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(0)} KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}

/// Shows how many reports are waiting to sync and roughly how much
/// data that represents - and surfaces the Wi-Fi-only toggle right
/// where it matters, so the user understands why something might be
/// intentionally not syncing yet.
class PendingSyncCard extends ConsumerWidget {
  const PendingSyncCard({super.key, required this.pendingCount});

  final int pendingCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (pendingCount == 0) return const SizedBox.shrink();

    final wifiOnlyAsync = ref.watch(wifiOnlySyncProvider);
    final wifiOnly = wifiOnlyAsync.value ?? false;
    final connectionKind = ref.watch(connectionKindProvider).value;
    final isWaitingForWifi = wifiOnly && connectionKind != ConnectionKind.wifi;

    return FutureBuilder<int>(
      future: ref.read(syncServiceProvider).estimatePendingBytes(),
      builder: (context, snapshot) {
        final sizeLabel =
            snapshot.hasData ? _formatBytes(snapshot.data!) : '...';

        return Container(
          margin: const EdgeInsets.fromLTRB(18, 0, 18, 4),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color:
                isWaitingForWifi ? Colors.orange.shade50 : Colors.blue.shade50,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(
                isWaitingForWifi
                    ? Icons.wifi_tethering_off_rounded
                    : Icons.cloud_upload_outlined,
                color: isWaitingForWifi
                    ? Colors.orange.shade700
                    : Colors.blue.shade700,
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$pendingCount report${pendingCount == 1 ? '' : 's'} pending sync',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: isWaitingForWifi
                            ? Colors.orange.shade900
                            : Colors.blue.shade900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isWaitingForWifi
                          ? 'Waiting for Wi-Fi - $sizeLabel will upload then'
                          : '~$sizeLabel will upload automatically',
                      style: TextStyle(
                        fontSize: 12,
                        color: isWaitingForWifi
                            ? Colors.orange.shade800
                            : Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// A settings sheet with the Wi-Fi-only sync toggle. Opened from the
/// home screen's settings icon.
class SettingsSheet extends ConsumerWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wifiOnlyAsync = ref.watch(wifiOnlySyncProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
              alignment: Alignment.center,
            ),
            Text(
              'Sync settings',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            wifiOnlyAsync.when(
              data: (wifiOnly) => SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Sync on Wi-Fi only'),
                subtitle: const Text(
                  'Avoid using mobile data to upload photos and reports',
                ),
                value: wifiOnly,
                onChanged: (value) async {
                  await ref.read(wifiOnlySyncProvider.notifier).setValue(value);
                  if (value) {
                    ref.read(syncServiceProvider).syncAllPending();
                  }
                },
              ),
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: LinearProgressIndicator(),
              ),
              error: (_, __) => const Text('Could not load settings'),
            ),
          ],
        ),
      ),
    );
  }
}
