import 'server_reader.dart';
import 'server_writer.dart';

// Concept: Abstract Class / Repository Pattern.
// SOLID - O (Open/Closed Principle): ServerRepository is abstract; new implementations (e.g. SQLite, REST API, Firebase)
// can be added in the future without modifying any UI or screen logic.
// SOLID - I (Interface Segregation Principle): Combines ServerReader and ServerWriter interfaces cleanly.
// SOLID - D (Dependency Inversion Principle): High-level UI screens depend on this abstract abstraction, not on a concrete implementation.
// SOLID - S (Single Responsibility Principle): Defines repository abstraction layer for servers.

abstract class ServerRepository implements ServerReader, ServerWriter {}
