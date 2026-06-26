import 'package:flutter/material.dart';

class SyncStatusBadge extends StatelessWidget {
  const SyncStatusBadge({super.key, required this.status});

  final String status;

  ({Color bg, Color fg, IconData icon, String label}) get _style {
    switch (status) {
      case 'synced':
        return (
          bg: Colors.green.shade50,
          fg: Colors.green.shade700,
          icon: Icons.cloud_done_outlined,
          label: 'Synced',
        );
      case 'syncing':
        return (
          bg: Colors.blue.shade50,
          fg: Colors.blue.shade700,
          icon: Icons.cloud_sync_outlined,
          label: 'Syncing',
        );
      case 'failed':
        return (
          bg: Colors.red.shade50,
          fg: Colors.red.shade700,
          icon: Icons.cloud_off_outlined,
          label: 'Failed',
        );
      default: // 'draft'
        return (
          bg: Colors.orange.shade50,
          fg: Colors.orange.shade800,
          icon: Icons.cloud_queue_outlined,
          label: 'Draft',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = _style;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: s.bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(s.icon, size: 13, color: s.fg),
          const SizedBox(width: 4),
          Text(
            s.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: s.fg,
            ),
          ),
        ],
      ),
    );
  }
}
