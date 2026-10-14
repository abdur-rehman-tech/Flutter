import '../models/server.dart';

// Concept: UI Interface / Abstract Class - Defines a contract for read-only server operations.
// SOLID - I (Interface Segregation Principle): Clients that only need to read data don't depend on mutating methods.
// SOLID - S (Single Responsibility Principle): Only responsible for defining server query signatures.

abstract class ServerReader {
  List<Server> getAllServers();
  Server? getServerById(String id);
}
