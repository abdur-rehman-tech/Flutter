import '../models/server.dart';

// Concept: UI Interface / Abstract Class - Defines a contract for write/mutation operations.
// SOLID - I (Interface Segregation Principle): Clients needing mutations depend on these methods.
// SOLID - S (Single Responsibility Principle): Only responsible for defining server modification signatures.

abstract class ServerWriter {
  void addServer(Server server);
  void updateServer(Server server);
  void deleteServer(String id);
}
