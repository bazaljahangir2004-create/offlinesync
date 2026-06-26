import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_database.dart';
import '../providers/reports_provider.dart';
import '../providers/connectivity_provider.dart';
import '../providers/sync_provider.dart';
import '../providers/auth_provider.dart';
import 'create_report_screen.dart';
import '../widgets/report_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(reportsStreamProvider);
    final isOnlineAsync = ref.watch(isOnlineProvider);
    final isOnline = isOnlineAsync.value ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Site Inspections'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              children: [
                Icon(
                  isOnline ? Icons.wifi : Icons.wifi_off,
                  size: 18,
                  color: isOnline ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.sync),
                  tooltip: 'Sync now',
                  onPressed: isOnline
                      ? () {
                          ref.read(syncServiceProvider).syncAllPending();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Syncing...')),
                          );
                        }
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'No internet connection - will sync automatically when back online',
                              ),
                            ),
                          );
                        },
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: 'Sign out',
                  onPressed: () => ref.read(authServiceProvider).signOut(),
                ),
              ],
            ),
          ),
        ],
      ),
      body: reportsAsync.when(
        data: (reports) {
          if (reports.isEmpty) {
            return const _EmptyState();
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final InspectionReport report = reports[index];
              return ReportCard(report: report);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CreateReportScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Report'),
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
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.assignment_outlined,
                size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No reports yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap "New Report" to create your first site inspection - works fully offline.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
