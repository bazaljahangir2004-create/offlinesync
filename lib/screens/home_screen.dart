import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_database.dart';
import '../providers/reports_provider.dart';
import '../providers/connectivity_provider.dart';
import '../providers/sync_provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/pending_sync_card.dart';
import 'create_report_screen.dart';
import '../widgets/report_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(reportsStreamProvider);
    final isOnline = ref.watch(isOnlineProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: reportsAsync.when(
          data: (reports) {
            final syncedCount =
                reports.where((r) => r.syncStatus == 'synced').length;
            final pendingCount = reports.length - syncedCount;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _Header(
                    greeting: _greeting(),
                    isOnline: isOnline,
                    totalCount: reports.length,
                    syncedCount: syncedCount,
                    onSignOut: () => ref.read(authServiceProvider).signOut(),
                    onSettings: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => const SettingsSheet(),
                      );
                    },
                    onSyncNow: isOnline
                        ? () {
                            ref.read(syncServiceProvider).syncAllPending();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Syncing...')),
                            );
                          }
                        : null,
                  ),
                ),
                SliverToBoxAdapter(
                  child: PendingSyncCard(pendingCount: pendingCount),
                ),
                if (reports.isEmpty)
                  const SliverFillRemaining(child: _EmptyState())
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(18, 4, 18, 100),
                    sliver: SliverList.builder(
                      itemCount: reports.length,
                      itemBuilder: (context, index) {
                        final InspectionReport report = reports[index];
                        return ReportCard(report: report);
                      },
                    ),
                  ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kAppAccent,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CreateReportScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New report'),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.greeting,
    required this.isOnline,
    required this.totalCount,
    required this.syncedCount,
    required this.onSignOut,
    required this.onSyncNow,
    required this.onSettings,
  });

  final String greeting;
  final bool isOnline;
  final int totalCount;
  final int syncedCount;
  final VoidCallback onSignOut;
  final VoidCallback? onSyncNow;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey.shade500),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Site inspections',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              _CircleIconButton(
                icon: isOnline ? Icons.wifi_rounded : Icons.wifi_off_rounded,
                color: isOnline ? Colors.green : Colors.grey,
                bg: isOnline ? Colors.green.shade50 : Colors.grey.shade100,
                onTap: onSyncNow ??
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Offline - reports will sync automatically once you\'re back online',
                          ),
                        ),
                      );
                    },
              ),
              const SizedBox(width: 8),
              _CircleIconButton(
                icon: Icons.settings_outlined,
                color: Colors.grey.shade700,
                bg: Colors.grey.shade100,
                onTap: onSettings,
              ),
              const SizedBox(width: 8),
              _CircleIconButton(
                icon: Icons.logout_rounded,
                color: Colors.grey.shade700,
                bg: Colors.grey.shade100,
                onTap: onSignOut,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  value: '$totalCount',
                  label: 'Total reports',
                  bg: Theme.of(context).colorScheme.surfaceContainerLow,
                  valueColor: Theme.of(context).colorScheme.onSurface,
                  labelColor: Colors.grey.shade600,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  value: '$syncedCount',
                  label: 'Synced',
                  bg: Colors.green.shade50,
                  valueColor: Colors.green.shade700,
                  labelColor: Colors.green.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.bg,
    required this.valueColor,
    required this.labelColor,
  });

  final String value;
  final String label;
  final Color bg;
  final Color valueColor;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: labelColor),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.color,
    required this.bg,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final Color bg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bg,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 38,
          height: 38,
          child: Icon(icon, size: 17, color: color),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: kAppAccent.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child:
                  Icon(Icons.assignment_outlined, size: 40, color: kAppAccent),
            ),
            const SizedBox(height: 20),
            Text(
              'Start your first report',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Capture a site inspection - works fully offline and syncs automatically when you\'re back online.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
