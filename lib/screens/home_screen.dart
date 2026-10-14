import 'dart:math';
import 'package:flutter/material.dart';
import '../models/server.dart';
import '../models/server_status.dart';
import '../repositories/server_repository.dart';
import '../routes/app_routes.dart';
import '../widgets/server_card.dart';
import 'add_server_screen.dart';
import 'server_detail_screen.dart';

// Concept: Stateless vs Stateful:
// HomeScreen is a StatefulWidget because it manages dynamic state:
// the list of servers, simulating real-time telemetry updates, and reacting to additions/deletions.
//
// SOLID - D (Dependency Inversion Principle): HomeScreen depends on the abstract ServerRepository,
// NEVER directly on InMemoryServerRepository.
// SOLID - S (Single Responsibility Principle): Coordinates dashboard rendering, summary metrics,
// and navigation events.

class HomeScreen extends StatefulWidget {
  // Concept: const vs final:
  // `final ServerRepository repository;` is a runtime abstraction injected into the widget constructor.
  final ServerRepository repository;

  const HomeScreen({
    super.key,
    required this.repository,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Concept: final list initialized at runtime holding local copy of servers for display
  late List<Server> _servers;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _loadServers();
  }

  void _loadServers() {
    _servers = List<Server>.from(widget.repository.getAllServers());
  }

  // Simulates real-time sysadmin monitoring telemetry updates
  void _simulateMonitoringRefresh() {
    // Concept: setState - Tells Flutter to re-run build() because internal state has changed.
    setState(() {
      final updatedList = <Server>[];
      for (final server in _servers) {
        // Random CPU, RAM, Disk between 10.0 and 99.0
        final newCpu = 10.0 + _random.nextDouble() * 88.0;
        final newRam = 15.0 + _random.nextDouble() * 80.0;
        final newDisk = (server.disk + (_random.nextDouble() * 2 - 1)).clamp(5.0, 98.0);

        // Derive server status based on telemetry simulation
        ServerStatus newStatus;
        if (newCpu > 90 || newRam > 92) {
          newStatus = ServerStatus.down;
        } else if (newCpu > 70 || newRam > 75) {
          newStatus = ServerStatus.warning;
        } else {
          newStatus = ServerStatus.up;
        }

        final updated = server.copyWith(
          cpu: double.parse(newCpu.toStringAsFixed(1)),
          ram: double.parse(newRam.toStringAsFixed(1)),
          disk: double.parse(newDisk.toStringAsFixed(1)),
          status: newStatus,
        );

        widget.repository.updateServer(updated);
        updatedList.add(updated);
      }
      _servers = updatedList;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Telemetry refreshed from active servers'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  // Summary counts
  int get _totalCount => _servers.length;
  int get _upCount => _servers.where((s) => s.status == ServerStatus.up).length;
  int get _downCount => _servers.where((s) => s.status == ServerStatus.down).length;
  int get _warningCount => _servers.where((s) => s.status == ServerStatus.warning).length;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Concept: Scaffold - Implements the basic Material Design visual layout structure
    // Concept: MaterialApp + home + Scaffold
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.monitor_heart, color: Colors.teal),
            SizedBox(width: 8),
            Text(
              'Server Monitor',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          // Refresh button simulating telemetry updates
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Simulate Telemetry Refresh',
            onPressed: _simulateMonitoringRefresh,
          ),
          // Concept: Named routing - Navigator.pushNamed to '/settings'
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.settings);
            },
          ),
          // Concept: PopupMenuButton providing Help entry navigating via NAMED route '/help'
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'help') {
                // Concept: Named routing - navigates to AppRoutes.help ('/help')
                Navigator.pushNamed(context, AppRoutes.help);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'help',
                child: Row(
                  children: [
                    Icon(Icons.help_outline, size: 20),
                    SizedBox(width: 8),
                    Text('Help & Docs'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      // Concept: child vs children:
      // Scaffold body has a single child (Column), which contains multiple 'children'
      // (Summary banner, divider, and ListView.builder/Empty state).
      body: Column(
        children: [
          // Summary row at top: total servers, Up count, Down count, Warning count
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
              border: Border(
                bottom: BorderSide(
                  color: theme.dividerColor.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryBadge(
                  label: 'TOTAL',
                  count: _totalCount,
                  color: theme.colorScheme.primary,
                  icon: Icons.storage,
                ),
                _buildSummaryBadge(
                  label: 'UP',
                  count: _upCount,
                  color: const Color(0xFF16A34A),
                  icon: Icons.check_circle,
                ),
                _buildSummaryBadge(
                  label: 'DOWN',
                  count: _downCount,
                  color: const Color(0xFFDC2626),
                  icon: Icons.cancel,
                ),
                _buildSummaryBadge(
                  label: 'WARN',
                  count: _warningCount,
                  color: const Color(0xFFD97706),
                  icon: Icons.warning,
                ),
              ],
            ),
          ),

          // Main list area or empty state
          Expanded(
            child: _servers.isEmpty
                ? Center(
                    // Empty-state message when there are no servers
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.dns_outlined,
                          size: 72,
                          color: theme.disabledColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No servers being monitored',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.hintColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap the + button below to add your first server.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.hintColor,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 80),
                    itemCount: _servers.length,
                    itemBuilder: (context, index) {
                      final server = _servers[index];
                      return ServerCard(
                        server: server,
                        onTap: () {
                          // Concept: DIRECT routing with MaterialPageRoute:
                          // Passes the server model directly through constructor.
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ServerDetailScreen(server: server),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),

      // Concept: FloatingActionButton to add a server
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add Server'),
        onPressed: () async {
          // Concept: DIRECT routing to AddServerScreen awaiting pop result
          final Server? newServer = await Navigator.push<Server>(
            context,
            MaterialPageRoute(
              builder: (_) => const AddServerScreen(),
            ),
          );

          // If a new server was returned, save into repository and call setState
          if (newServer != null) {
            widget.repository.addServer(newServer);
            // Concept: setState - Triggers UI rebuild with updated server list
            setState(() {
              _loadServers();
            });

            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Server "${newServer.name}" added successfully'),
                backgroundColor: Colors.green.shade700,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildSummaryBadge({
    required String label,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color.withValues(alpha: 0.8),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
