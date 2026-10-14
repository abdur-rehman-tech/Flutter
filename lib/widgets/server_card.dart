import 'package:flutter/material.dart';
import '../models/server.dart';
import '../theme/app_theme.dart';
import 'status_chip.dart';
import 'usage_bar.dart';

// Concept: Stateless vs Stateful:
// ServerCard is a StatelessWidget rendering server information passed to it.
// SOLID - S (Single Responsibility Principle): Displays a summary card representation of a Server.

class ServerCard extends StatelessWidget {
  final Server server;
  final VoidCallback onTap;

  const ServerCard({
    super.key,
    required this.server,
    required this.onTap,
  });

  Color _getEnvColor(String env) {
    switch (env) {
      case 'Prod':
        return const Color(0xFFEF4444);
      case 'UAT':
        return const Color(0xFFF59E0B);
      case 'Dev':
      default:
        return const Color(0xFF3B82F6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final envColor = _getEnvColor(server.environment);

    // Concept: child vs children:
    // Card has a child (InkWell), InkWell has a child (Padding), Padding has child (Column),
    // and Column has 'children' (a list of widgets forming the visual hierarchy).
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row: Server name, environment badge, status chip
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.dns_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      server.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: envColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: envColor.withValues(alpha: 0.5)),
                    ),
                    child: Text(
                      server.environment,
                      style: TextStyle(
                        color: envColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  StatusChip(status: server.status),
                ],
              ),
              const SizedBox(height: 6),

              // IP Address & Alert status row
              Row(
                children: [
                  const Icon(Icons.network_ping, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    server.ipAddress,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.8),
                          fontFamily: 'monospace',
                        ),
                  ),
                  const Spacer(),
                  if (server.alertsEnabled)
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.notifications_active, size: 14, color: Colors.amber),
                        SizedBox(width: 2),
                        Text(
                          'Alerts On',
                          style: TextStyle(fontSize: 10, color: Colors.amber, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Mini usage bars
              UsageBar(label: 'CPU', percentage: server.cpu),
              const SizedBox(height: 6),
              UsageBar(label: 'RAM', percentage: server.ram),

              // Optional disk usage toggled by ValueNotifier in settings
              ValueListenableBuilder<bool>(
                valueListenable: AppTheme.showDiskUsageNotifier,
                builder: (context, showDisk, _) {
                  if (!showDisk) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: UsageBar(label: 'Disk', percentage: server.disk),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
