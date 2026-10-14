import 'package:flutter/material.dart';
import '../models/server.dart';
import '../widgets/status_chip.dart';
import '../widgets/usage_bar.dart';

// Concept: Stateless vs Stateful:
// ServerDetailScreen is a StatelessWidget because all details are supplied via its constructor
// and the view renders static display information without local mutation.
// SOLID - S (Single Responsibility Principle): Displays comprehensive details for a single server instance.

class ServerDetailScreen extends StatelessWidget {
  // Concept: const vs final:
  // `final Server server;` is a runtime instance passed into the constructor.
  final Server server;

  const ServerDetailScreen({
    super.key,
    required this.server,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Concept: child vs children:
    // Scaffold has a 'body' child (SafeArea), SafeArea has child (ListView), ListView has 'children' list.
    return Scaffold(
      appBar: AppBar(
        title: Text(server.name),
        // Concept: Navigator.pop - Back navigation returning to caller screen
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header card with Status & Environment
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Icon(
                        Icons.dns,
                        size: 32,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            server.name,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'ID: ${server.id}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                    StatusChip(status: server.status),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Server Metadata Card using RichText / Text.rich
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Server Configuration',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(height: 24),

                    // Concept: Text.rich / RichText with TextSpan:
                    // Combines different text styles inline (bold label + normal/colored value)
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'IP Address: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          TextSpan(
                            text: server.ipAddress,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Environment: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          TextSpan(
                            text: server.environment,
                            style: TextStyle(
                              color: server.environment == 'Prod'
                                  ? Colors.red
                                  : server.environment == 'UAT'
                                      ? Colors.amber.shade700
                                      : Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Alert Notifications: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          TextSpan(
                            text: server.alertsEnabled ? 'Enabled' : 'Disabled',
                            style: TextStyle(
                              color: server.alertsEnabled ? Colors.green : Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Concept: RichText for server description
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Description:\n',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          TextSpan(
                            text: server.description.isEmpty
                                ? 'No description provided.'
                                : server.description,
                            style: TextStyle(
                              fontStyle: server.description.isEmpty
                                  ? FontStyle.italic
                                  : FontStyle.normal,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Live Metrics Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resource Utilization',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Concept: UsageBar widgets (LinearProgressIndicator color rules:
                    // >85 red, >60 orange, otherwise green)
                    UsageBar(label: 'CPU Usage', percentage: server.cpu),
                    const SizedBox(height: 16),
                    UsageBar(label: 'RAM Usage', percentage: server.ram),
                    const SizedBox(height: 16),
                    UsageBar(label: 'Disk Space', percentage: server.disk),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
