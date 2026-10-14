import 'package:flutter/material.dart';

// Concept: Stateless vs Stateful:
// UsageBar is a StatelessWidget that renders a label, LinearProgressIndicator, and percentage text.
// SOLID - S (Single Responsibility Principle): Displays a resource metric progress bar.

class UsageBar extends StatelessWidget {
  final String label;
  final double percentage; // 0 to 100

  const UsageBar({
    super.key,
    required this.label,
    required this.percentage,
  });

  Color _getBarColor(double value) {
    if (value > 85) {
      return const Color(0xFFDC2626); // Red above 85%
    } else if (value > 60) {
      return const Color(0xFFF59E0B); // Orange/Amber above 60%
    } else {
      return const Color(0xFF10B981); // Green otherwise
    }
  }

  @override
  Widget build(BuildContext context) {
    // Clamp to valid range [0.0, 1.0] for progress indicator
    final double clampedValue = (percentage.clamp(0.0, 100.0)) / 100.0;
    final Color barColor = _getBarColor(percentage);

    // Concept: Widget tree - Composition of Column -> Row -> Text & LinearProgressIndicator
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: barColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: clampedValue,
            minHeight: 6,
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade800
                : Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
          ),
        ),
      ],
    );
  }
}
