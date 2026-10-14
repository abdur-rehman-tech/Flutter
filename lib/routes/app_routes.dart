import 'package:flutter/material.dart';
import '../screens/settings_screen.dart';
import '../screens/help_screen.dart';

// Concept: Routing Architecture - Direct vs Named Routing
//
// 1. DIRECT ROUTING:
//    - Syntax: `Navigator.push(context, MaterialPageRoute(builder: (_) => ServerDetailScreen(server: server)))`
//    - Used when passing strongly-typed complex objects, constructors with parameters, or receiving typed results.
//    - Flexible and type-safe directly in code.
//
// 2. NAMED ROUTING:
//    - Syntax: `Navigator.pushNamed(context, AppRoutes.settings)`
//    - Centralizes string-based routes in a table (`routes: AppRoutes.routes`).
//    - Excellent for common static screens like settings, help, about, and web-like deep-linking.
//
// SOLID - S (Single Responsibility Principle): Centralizes application route constants and route builder table.

class AppRoutes {
  static const String settings = '/settings';
  static const String help = '/help';

  // Named route registry map for MaterialApp(routes: ...)
  static Map<String, WidgetBuilder> get routes => {
        settings: (context) => const SettingsScreen(),
        help: (context) => const HelpScreen(),
      };
}
