import 'server_status.dart';

// Concept: Model class representing immutable domain entity.
// Concept: const vs final:
// - `final` is used here for fields whose values are assigned at runtime when the object is instantiated,
//   and cannot be changed thereafter (immutability).
// - `const` is for compile-time constants known before runtime.
// SOLID - S (Single Responsibility Principle): This file solely defines the Server data structure.

class Server {
  final String id;
  final String name;
  final String ipAddress;
  final String description;
  final String environment; // "Dev", "UAT", "Prod"
  final bool alertsEnabled;
  final ServerStatus status;
  final double cpu; // 0 to 100
  final double ram; // 0 to 100
  final double disk; // 0 to 100

  const Server({
    required this.id,
    required this.name,
    required this.ipAddress,
    required this.description,
    required this.environment,
    required this.alertsEnabled,
    required this.status,
    required this.cpu,
    required this.ram,
    required this.disk,
  });

  // Allows creating an updated copy of the server with specific fields modified
  Server copyWith({
    String? id,
    String? name,
    String? ipAddress,
    String? description,
    String? environment,
    bool? alertsEnabled,
    ServerStatus? status,
    double? cpu,
    double? ram,
    double? disk,
  }) {
    return Server(
      id: id ?? this.id,
      name: name ?? this.name,
      ipAddress: ipAddress ?? this.ipAddress,
      description: description ?? this.description,
      environment: environment ?? this.environment,
      alertsEnabled: alertsEnabled ?? this.alertsEnabled,
      status: status ?? this.status,
      cpu: cpu ?? this.cpu,
      ram: ram ?? this.ram,
      disk: disk ?? this.disk,
    );
  }
}
