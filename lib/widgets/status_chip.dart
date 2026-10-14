import 'package:flutter/material.dart';
import '../models/server_status.dart';

// Concept: Stateless vs Stateful:
// StatusChip is a StatelessWidget because its appearance depends solely on input parameters,
// and it holds no internal mutable state.
// SOLID - S (Single Responsibility Principle): Displays a server status badge.

class StatusChip extends StatelessWidget {
  final ServerStatus status;

  // Concept: const constructor for compile-time optimization
  const StatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String label;
    final IconData icon;

    switch (status) {
      case ServerStatus.up:
        color = const Color(0xFF16A34A); // Green
        label = 'UP';
        icon = Icons.check_circle_outline;
        break;
      case ServerStatus.down:
        color = const Color(0xFFDC2626); // Red
        label = 'DOWN';
        icon = Icons.error_outline;
        break;
      case ServerStatus.warning:
        color = const Color(0xFFD97706); // Orange / Amber
        label = 'WARNING';
        icon = Icons.warning_amber_rounded;
        break;
    }

    // Concept: child vs children:
    // Container has a single 'child' (Row), which in turn has multiple 'children' (Icon and Text).
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        // Modern Dart color API: withValues(alpha: ...) replaces deprecated withOpacity
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.6), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
