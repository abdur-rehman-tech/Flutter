import '../models/server.dart';
import 'server_repository.dart';

// Concept: In-Memory Repository Implementation.
// SOLID - L (Liskov Substitution Principle): InMemoryServerRepository can seamlessly substitute ServerRepository
// anywhere in the application without breaking expectations or behavior.
// SOLID - S (Single Responsibility Principle): Manages in-memory storage, retrieval, and updates for Server entities.

class InMemoryServerRepository implements ServerRepository {
  // Concept: final list reference holding mutable data collection in memory
  final List<Server> _servers = [];

  InMemoryServerRepository({List<Server>? initialServers}) {
    if (initialServers != null) {
      _servers.addAll(initialServers);
    }
  }

  @override
  List<Server> getAllServers() {
    // Returns an unmodifiable view or copy so internal state cannot be mutated directly
    return List<Server>.unmodifiable(_servers);
  }

  @override
  Server? getServerById(String id) {
    try {
      return _servers.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  void addServer(Server server) {
    _servers.add(server);
  }

  @override
  void updateServer(Server server) {
    final index = _servers.indexWhere((s) => s.id == server.id);
    if (index != -1) {
      _servers[index] = server;
    }
  }

  @override
  void deleteServer(String id) {
    _servers.removeWhere((s) => s.id == id);
  }
}
