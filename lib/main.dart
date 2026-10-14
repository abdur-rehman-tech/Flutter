import 'package:flutter/material.dart';
import 'models/server.dart';
import 'models/server_status.dart';
import 'repositories/in_memory_server_repository.dart';
import 'repositories/server_repository.dart';
import 'routes/app_routes.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

// Concept: main entry point of the Flutter application.
//
// SOLID Principles applied:
// - S (Single Responsibility): main.dart is solely responsible for bootstrapping the app and wiring root dependencies.
// - O (Open/Closed): Repository implementation can be changed without modifying HomeScreen or any other view.
// - L (Liskov Substitution): InMemoryServerRepository is passed where ServerRepository is expected.
// - I (Interface Segregation): Abstract interfaces (ServerReader, ServerWriter) separate contracts.
// - D (Dependency Inversion): HomeScreen accepts abstract `ServerRepository`, not concrete `InMemoryServerRepository`.

void main() {
  // Ensure Flutter engine bindings are initialized before running app
  WidgetsFlutterBinding.ensureInitialized();

  // Concept: Dependency Inversion:
  // Create ONE InMemoryServerRepository instance and type it as ServerRepository (the abstract class)
  final ServerRepository repository = InMemoryServerRepository(
    initialServers: [
      const Server(
        id: 'srv-001',
        name: 'web-server-01',
        ipAddress: '192.168.1.10',
        description: 'Primary Nginx reverse proxy and SSL termination endpoint.',
        environment: 'Prod',
        alertsEnabled: true,
        status: ServerStatus.up,
        cpu: 34.5,
        ram: 62.0,
        disk: 45.8,
      ),
      const Server(
        id: 'srv-002',
        name: 'db-server-01',
        ipAddress: '192.168.1.15',
        description: 'PostgreSQL primary cluster with automated WAL archiving.',
        environment: 'Prod',
        alertsEnabled: true,
        status: ServerStatus.warning,
        cpu: 78.4,
        ram: 84.1,
        disk: 88.0,
      ),
      const Server(
        id: 'srv-003',
        name: 'mail-server',
        ipAddress: '192.168.1.20',
        description: 'Postfix and Dovecot corporate mail transfer agent.',
        environment: 'Prod',
        alertsEnabled: false,
        status: ServerStatus.down,
        cpu: 96.2,
        ram: 94.0,
        disk: 72.5,
      ),
      const Server(
        id: 'srv-004',
        name: 'backup-nas',
        ipAddress: '192.168.1.50',
        description: 'TrueNAS ZFS storage pool with nightly automated snapshots.',
        environment: 'Prod',
        alertsEnabled: true,
        status: ServerStatus.up,
        cpu: 18.2,
        ram: 45.6,
        disk: 79.3,
      ),
      const Server(
        id: 'srv-005',
        name: 'monitoring-server',
        ipAddress: '192.168.1.99',
        description: 'Prometheus metrics collector, Grafana server, Alertmanager.',
        environment: 'UAT',
        alertsEnabled: true,
        status: ServerStatus.up,
        cpu: 42.0,
        ram: 58.3,
        disk: 38.1,
      ),
      const Server(
        id: 'srv-006',
        name: 'dev-box',
        ipAddress: '192.168.1.120',
        description: 'Developer sandbox environment for feature branch testing.',
        environment: 'Dev',
        alertsEnabled: false,
        status: ServerStatus.warning,
        cpu: 68.7,
        ram: 74.2,
        disk: 52.0,
      ),
    ],
  );

  runApp(ServerMonitorApp(repository: repository));
}

// Concept: Stateless vs Stateful:
// ServerMonitorApp is a StatelessWidget that configures MaterialApp and observes AppTheme.themeNotifier.
class ServerMonitorApp extends StatelessWidget {
  // Concept: Dependency Inversion: HomeScreen receives abstract ServerRepository
  final ServerRepository repository;

  const ServerMonitorApp({
    super.key,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    // Concept: Runtime theme change using ValueListenableBuilder + ValueNotifier:
    // When themeNotifier.value changes in SettingsScreen, only this builder rebuilds with the new ThemeMode.
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeNotifier,
      builder: (context, currentMode, _) {
        // Concept: MaterialApp + home + Scaffold
        return MaterialApp(
          // Concept: debugShowCheckedModeBanner: false removes the debug banner in top right
          debugShowCheckedModeBanner: false,
          title: 'Server Monitor Dashboard',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentMode,
          // Concept: Dependency Inversion - Passing abstract repository to HomeScreen
          home: HomeScreen(repository: repository),
          // Concept: Named routing table registered centrally
          routes: AppRoutes.routes,
        );
      },
    );
  }
}
