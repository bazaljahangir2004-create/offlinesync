import 'package:flutter/material.dart';

/// Centralizes the visual language for sync status: color + icon,
/// used by both the badge and the report card's leading tile.
class SyncStatusStyle {
  const SyncStatusStyle({
    required this.bg,
    required this.fg,
    required this.icon,
    required this.label,
  });

  final Color bg;
  final Color fg;
  final IconData icon;
  final String label;

  static SyncStatusStyle fromStatus(String status) {
    switch (status) {
      case 'synced':
        return SyncStatusStyle(
          bg: Colors.green.shade50,
          fg: Colors.green.shade700,
          icon: Icons.cloud_done_rounded,
          label: 'Synced',
        );
      case 'syncing':
        return SyncStatusStyle(
          bg: Colors.blue.shade50,
          fg: Colors.blue.shade700,
          icon: Icons.cloud_sync_rounded,
          label: 'Syncing',
        );
      case 'failed':
        return SyncStatusStyle(
          bg: Colors.red.shade50,
          fg: Colors.red.shade700,
          icon: Icons.cloud_off_rounded,
          label: 'Failed',
        );
      default: // draft
        return SyncStatusStyle(
          bg: Colors.amber.shade50,
          fg: Colors.amber.shade800,
          icon: Icons.cloud_queue_rounded,
          label: 'Draft',
        );
    }
  }
}

/// Picks a leading icon for a report card based on simple keyword
/// matching against the title - purely cosmetic, gives the list
/// visual variety without needing the user to pick a category.
IconData pickReportIcon(String title) {
  final t = title.toLowerCase();
  if (t.contains('warehouse') || t.contains('storage')) {
    return Icons.warehouse_rounded;
  }
  if (t.contains('school') || t.contains('class')) {
    return Icons.school_rounded;
  }
  if (t.contains('roof')) return Icons.roofing_rounded;
  if (t.contains('site') || t.contains('construction')) {
    return Icons.construction_rounded;
  }
  if (t.contains('office')) return Icons.business_rounded;
  if (t.contains('factory') || t.contains('plant')) {
    return Icons.factory_rounded;
  }
  return Icons.assignment_rounded;
}

const kAppAccent = Color(0xFF1F8A5C);
