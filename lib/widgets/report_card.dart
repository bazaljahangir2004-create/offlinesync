import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/app_database.dart';
import '../providers/reports_provider.dart';
import '../screens/report_detail_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/sync_status_badge.dart';

class ReportCard extends StatelessWidget {
  const ReportCard({super.key, required this.report});

  final InspectionReport report;

  @override
  Widget build(BuildContext context) {
    final imagePaths =
        ReportsRepository.decodeImagePaths(report.localImagePaths);
    final statusStyle = SyncStatusStyle.fromStatus(report.syncStatus);
    final icon = pickReportIcon(report.title);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
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
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: statusStyle.bg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: statusStyle.fg, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                          const SizedBox(width: 6),
                          SyncStatusBadge(status: report.syncStatus),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        report.syncStatus == 'failed'
                            ? 'Tap to retry sync'
                            : report.notes.isNotEmpty
                                ? report.notes
                                : 'No notes added',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: report.syncStatus == 'failed'
                                  ? statusStyle.fg
                                  : Colors.grey.shade600,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (imagePaths.isNotEmpty) ...[
                            Icon(Icons.camera_alt_outlined,
                                size: 13, color: Colors.grey.shade500),
                            const SizedBox(width: 4),
                            Text('${imagePaths.length}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.grey.shade500)),
                            const SizedBox(width: 10),
                          ],
                          if (report.latitude != null) ...[
                            Icon(Icons.location_on_outlined,
                                size: 13, color: Colors.grey.shade500),
                            const SizedBox(width: 4),
                            Text('GPS',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.grey.shade500)),
                            const SizedBox(width: 10),
                          ],
                          Text(
                            DateFormat('MMM d, h:mm a')
                                .format(report.createdAt),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.grey.shade400),
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
      ),
    );
  }
}
