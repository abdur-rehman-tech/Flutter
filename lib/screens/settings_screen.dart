import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// Concept: Stateless vs Stateful:
// SettingsScreen is a StatefulWidget demonstrating local UI state paired with global ValueNotifier triggers.
// SOLID - S (Single Responsibility Principle): Displays and modifies application preferences.

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    // Concept: Scaffold - Standard Material layout visual structure.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Appearance',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          // Concept: ValueListenableBuilder - Rebuilds only when AppTheme.themeNotifier changes.
          // Concept: SwitchListTile - Material switch tied to runtime theme toggle.
          ValueListenableBuilder<ThemeMode>(
            valueListenable: AppTheme.themeNotifier,
            builder: (context, currentMode, _) {
              final isDarkMode = currentMode == ThemeMode.dark;
              return SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: Text(isDarkMode
                    ? 'Active (high contrast dark theme)'
                    : 'Inactive (clean light theme)'),
                secondary: Icon(
                  isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: isDarkMode ? Colors.amber : Colors.blueGrey,
                ),
                value: isDarkMode,
                onChanged: (bool value) {
                  // Concept: Runtime theme change - Mutating ValueNotifier.value triggers listener rebuilds.
                  AppTheme.themeNotifier.value =
                      value ? ThemeMode.dark : ThemeMode.light;
                },
              );
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Dashboard Preferences',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          // Concept: CheckboxListTile - Material checkbox controlling optional card metrics
          ValueListenableBuilder<bool>(
            valueListenable: AppTheme.showDiskUsageNotifier,
            builder: (context, showDisk, _) {
              return CheckboxListTile(
                title: const Text('Show Disk usage on cards'),
                subtitle: const Text('Render third progress bar in server summary list'),
                secondary: const Icon(Icons.storage_outlined),
                value: showDisk,
                onChanged: (bool? newValue) {
                  if (newValue != null) {
                    AppTheme.showDiskUsageNotifier.value = newValue;
                  }
                },
              );
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Server Monitor Dashboard v1.0.0\nBuilt for Mobile Computing Course.\nUses Pure setState and ValueNotifier.',
                  style: TextStyle(fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
