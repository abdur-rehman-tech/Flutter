import 'package:flutter/material.dart';

// Concept: ValueNotifier - A simple, lightweight, built-in change notifier for a single value.
// Concept: Runtime theme change without external state management libraries (No Provider/Bloc/Riverpod).
// SOLID - S (Single Responsibility Principle): Only responsible for application-level themes and theme state.

class AppTheme {
  // Global ValueNotifier to toggle ThemeMode at runtime
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.light);

  // Optional: Global ValueNotifier to toggle showing disk usage on server cards
  static final ValueNotifier<bool> showDiskUsageNotifier =
      ValueNotifier<bool>(true);

  // Concept: const vs final:
  // `final` runtime ThemeData objects configured with Material 3 and modern color seed.
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF0F766E), // Teal/Cyber-blue inspired sysadmin seed
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 2,
    ),
    cardTheme: CardThemeData(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF14B8A6),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF0F172A), // Modern Slate dark
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 2,
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
