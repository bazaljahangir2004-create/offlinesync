import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/app_database.dart';
import '../providers/reports_provider.dart';
import '../providers/sync_provider.dart';
import '../widgets/sync_status_badge.dart';
import 'create_report_screen.dart';

class ReportDetailScreen extends ConsumerWidget {
  const ReportDetailScreen({super.key, required this.report});

  final InspectionReport report;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localPaths =
        ReportsRepository.decodeImagePaths(report.localImagePaths);
    final uploadedUrls =
        ReportsRepository.decodeImagePaths(report.uploadedImageUrls);

    // Prefer showing the uploaded (cloud) version once synced, since
    // local files could later be cleared - but fall back to local
    // paths for drafts/syncing/failed reports.
    final bool isSynced = report.syncStatus == 'synced';

    return Scaffold(
      appBar: AppBar(
        title: Text(report.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit report',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CreateReportScreen(existingReport: report),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('MMMM d, yyyy - h:mm a').format(report.createdAt),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey.shade600),
              ),
              SyncStatusBadge(status: report.syncStatus),
            ],
          ),
          const SizedBox(height: 16),
          if (report.notes.isNotEmpty) ...[
            Text('Notes', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 6),
            Text(report.notes, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 20),
          ],
          if (localPaths.isNotEmpty) ...[
            Text('Photos', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            SizedBox(
              height: 140,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: localPaths.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final imageUrl = isSynced && index < uploadedUrls.length
                      ? uploadedUrls[index]
                      : null;

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: imageUrl != null
                        ? Image.network(
                            imageUrl,
                            width: 140,
                            height: 140,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return SizedBox(
                                width: 140,
                                height: 140,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: progress.expectedTotalBytes != null
                                        ? progress.cumulativeBytesLoaded /
                                            progress.expectedTotalBytes!
                                        : null,
                                  ),
                                ),
                              );
                            },
                          )
                        : Image.file(
                            File(localPaths[index]),
                            width: 140,
                            height: 140,
                            fit: BoxFit.cover,
                          ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
          if (report.latitude != null && report.longitude != null) ...[
            Text('Location', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined),
                  const SizedBox(width: 8),
                  Text(
                    '${report.latitude!.toStringAsFixed(5)}, '
                    '${report.longitude!.toStringAsFixed(5)}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
          if (report.syncStatus == 'failed') ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sync failed',
                    style: TextStyle(
                      color: Colors.red.shade800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (report.lastSyncError != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      report.lastSyncError!,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  FilledButton.tonalIcon(
                    onPressed: () async {
                      await ref.read(syncServiceProvider).syncOneReport(report);
                      if (context.mounted) Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Retry sync'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
