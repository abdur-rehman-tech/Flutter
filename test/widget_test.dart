import 'package:flutter_test/flutter_test.dart';
import 'package:server_monitor_dashboard/main.dart';
import 'package:server_monitor_dashboard/models/server.dart';
import 'package:server_monitor_dashboard/models/server_status.dart';
import 'package:server_monitor_dashboard/repositories/in_memory_server_repository.dart';

void main() {
  testWidgets('Server Monitor Dashboard smoke test', (WidgetTester tester) async {
    final repo = InMemoryServerRepository(
      initialServers: [
        const Server(
          id: 'test-1',
          name: 'test-server',
          ipAddress: '192.168.1.1',
          description: 'A test server',
          environment: 'Dev',
          alertsEnabled: true,
          status: ServerStatus.up,
          cpu: 50.0,
          ram: 40.0,
          disk: 30.0,
        ),
      ],
    );

    await tester.pumpWidget(ServerMonitorApp(repository: repo));

    // Verify app title and server name are displayed
    expect(find.text('Server Monitor'), findsOneWidget);
    expect(find.text('test-server'), findsOneWidget);
    expect(find.text('192.168.1.1'), findsOneWidget);
  });
}
