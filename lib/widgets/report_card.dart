import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/app_database.dart';
import 'sync_status_badge.dart';
import '../providers/reports_provider.dart';
import '../screens/report_detail_screen.dart';

class ReportCard extends StatelessWidget {
  const ReportCard({super.key, required this.report});

  final InspectionReport report;

  @override
  Widget build(BuildContext context) {
    final imagePaths =
        ReportsRepositoryHelpers.decodeImagePaths(report.localImagePaths);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ReportDetailScreen(report: report),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            report.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SyncStatusBadge(status: report.syncStatus),
                      ],
                    ),
                    const SizedBox(height: 6),
                    if (report.notes.isNotEmpty)
                      Text(
                        report.notes,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (imagePaths.isNotEmpty) ...[
                          Icon(Icons.photo_camera_outlined,
                              size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text('${imagePaths.length}',
                              style: Theme.of(context).textTheme.bodySmall),
                          const SizedBox(width: 12),
                        ],
                        if (report.latitude != null) ...[
                          Icon(Icons.location_on_outlined,
                              size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text('GPS',
                              style: Theme.of(context).textTheme.bodySmall),
                          const SizedBox(width: 12),
                        ],
                        Text(
                          DateFormat('MMM d, h:mm a').format(report.createdAt),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tiny wrapper so this widget doesn't need to import dart:convert directly.
class ReportsRepositoryHelpers {
  static List<String> decodeImagePaths(String raw) =>
      ReportsRepository.decodeImagePaths(raw);
}
