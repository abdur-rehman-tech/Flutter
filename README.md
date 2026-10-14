# Server Monitor Dashboard 🖥️

A Flutter mobile application designed for sysadmins and DevOps engineers to monitor server health, observe CPU/RAM/Disk metrics, register new nodes, inspect configuration details, and access documentation.

Built for a **Mobile Computing Course**, emphasizing foundational Flutter concepts, clean architectural separation, and SOLID design principles.

---

## 🛠️ How to Run the App

### Prerequisites
- Flutter SDK 3.x+ installed and added to your `PATH`
- Android Studio / Android Emulator, physical Android device, or Chrome

### Steps
1. Navigate to the project root directory:
   ```bash
   cd /path/to/Flutter
   ```
2. Get project dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run
   ```
   *(Select your target device/emulator when prompted)*

4. Run tests:
   ```bash
   flutter test
   ```

5. Verify static analysis:
   ```bash
   flutter analyze
   ```

---

## 🏗️ Architecture & State Management

- **Beginner Level Constraints**: Exclusively uses `setState` and `ValueNotifier<T>`.
- **Zero Third-Party State Management**: No Provider, Bloc, Riverpod, or GetX.
- **In-Memory Persistence**: Data persists in memory via `InMemoryServerRepository` (no database dependencies).
- **Packages**: `webview_flutter` for the Help & Documentation screen.

---

## 📂 Project Structure

```
lib/
├── main.dart
├── models/
│   ├── server.dart                   # Server domain model with copyWith
│   └── server_status.dart            # ServerStatus enum (up, down, warning)
├── repositories/
│   ├── server_reader.dart            # Read-only repository interface
│   ├── server_writer.dart            # Write/mutate repository interface
│   ├── server_repository.dart        # Combined abstract repository interface
│   └── in_memory_server_repository.dart # Concrete in-memory implementation
├── screens/
│   ├── home_screen.dart              # Dashboard, summary badges, live telemetry refresh
│   ├── add_server_screen.dart        # Form with validation, radio tiles, checkbox
│   ├── server_detail_screen.dart     # Detailed inspection, RichText, metric bars
│   ├── settings_screen.dart          # Dark mode toggle via ValueNotifier
│   └── help_screen.dart              # WebView displaying Grafana documentation
├── widgets/
│   ├── server_card.dart              # Server list item card
│   ├── status_chip.dart              # Color-coded UP/DOWN/WARNING badge
│   └── usage_bar.dart                # LinearProgressIndicator with color rules
├── routes/
│   └── app_routes.dart               # Named route registry & comparison notes
└── theme/
    └── app_theme.dart                # Light & dark Material 3 themes + ValueNotifier
```

---

## 🧩 Concepts Checklist & File Mapping

| Concept | Description | File Where Used |
| :--- | :--- | :--- |
| **Stateless vs Stateful** | `StatelessWidget` for static/derived UI; `StatefulWidget` for mutable local state | [`lib/widgets/status_chip.dart`](file:///home/rehman/Documents/Flutter/lib/widgets/status_chip.dart), [`lib/screens/home_screen.dart`](file:///home/rehman/Documents/Flutter/lib/screens/home_screen.dart) |
| **Widget Tree** | Hierarchical composition of nested UI components | [`lib/screens/server_detail_screen.dart`](file:///home/rehman/Documents/Flutter/lib/screens/server_detail_screen.dart), [`lib/widgets/usage_bar.dart`](file:///home/rehman/Documents/Flutter/lib/widgets/usage_bar.dart) |
| **child vs children** | Single widget container (`child`) vs multi-widget list (`children`) | [`lib/widgets/server_card.dart`](file:///home/rehman/Documents/Flutter/lib/widgets/server_card.dart), [`lib/screens/home_screen.dart`](file:///home/rehman/Documents/Flutter/lib/screens/home_screen.dart) |
| **MaterialApp + home + Scaffold** | Standard Material application root, home screen, and screen structure | [`lib/main.dart`](file:///home/rehman/Documents/Flutter/lib/main.dart), [`lib/screens/home_screen.dart`](file:///home/rehman/Documents/Flutter/lib/screens/home_screen.dart) |
| **debugShowCheckedModeBanner** | Set to `false` to remove the debug banner | [`lib/main.dart`](file:///home/rehman/Documents/Flutter/lib/main.dart) |
| **TextField / Multiline Text Box** | Single-line validated inputs and `maxLines: 5` multiline notes box | [`lib/screens/add_server_screen.dart`](file:///home/rehman/Documents/Flutter/lib/screens/add_server_screen.dart) |
| **RichText / Text.rich + TextSpan** | Multiple font weights and inline styles for key-value details | [`lib/screens/server_detail_screen.dart`](file:///home/rehman/Documents/Flutter/lib/screens/server_detail_screen.dart) |
| **Radio Button (`RadioListTile` / `RadioGroup`)** | Mutually exclusive selection for target Environment (Dev, UAT, Prod) | [`lib/screens/add_server_screen.dart`](file:///home/rehman/Documents/Flutter/lib/screens/add_server_screen.dart) |
| **Checkbox (`CheckboxListTile`)** | Boolean toggle for server alert notifications | [`lib/screens/add_server_screen.dart`](file:///home/rehman/Documents/Flutter/lib/screens/add_server_screen.dart) |
| **WebView Widget** | `WebViewController` + `WebViewWidget` loading live documentation | [`lib/screens/help_screen.dart`](file:///home/rehman/Documents/Flutter/lib/screens/help_screen.dart) |
| **Navigator.push & Navigator.pop** | Pushing new routes onto the navigation stack and returning result values | [`lib/screens/home_screen.dart`](file:///home/rehman/Documents/Flutter/lib/screens/home_screen.dart), [`lib/screens/add_server_screen.dart`](file:///home/rehman/Documents/Flutter/lib/screens/add_server_screen.dart) |
| **Direct vs Named Routing** | Direct routing for passing objects vs centralized named routes for common views | [`lib/routes/app_routes.dart`](file:///home/rehman/Documents/Flutter/lib/routes/app_routes.dart), [`lib/screens/home_screen.dart`](file:///home/rehman/Documents/Flutter/lib/screens/home_screen.dart) |
| **Runtime Theme Change** | `ValueNotifier<ThemeMode>` + `ValueListenableBuilder` to toggle light/dark | [`lib/theme/app_theme.dart`](file:///home/rehman/Documents/Flutter/lib/theme/app_theme.dart), [`lib/main.dart`](file:///home/rehman/Documents/Flutter/lib/main.dart), [`lib/screens/settings_screen.dart`](file:///home/rehman/Documents/Flutter/lib/screens/settings_screen.dart) |
| **Separate File per Screen (SRP)** | Every screen, widget, model, and repository lives in its own dedicated file | Full codebase under [`lib/`](file:///home/rehman/Documents/Flutter/lib/) |
| **const vs final** | `const` for compile-time constants; `final` for runtime immutable references | [`lib/models/server.dart`](file:///home/rehman/Documents/Flutter/lib/models/server.dart), [`lib/screens/home_screen.dart`](file:///home/rehman/Documents/Flutter/lib/screens/home_screen.dart) |

---

## 🏛️ SOLID Principles Implementation

- **S (Single Responsibility Principle)**: Each file has one clear responsibility (models only hold data, widgets only render, repositories only handle data persistence).
- **O (Open/Closed Principle)**: `ServerRepository` is an abstract interface. A new SQLite or REST API repository can be created without modifying any UI screen or widget.
- **L (Liskov Substitution Principle)**: `InMemoryServerRepository` implements `ServerRepository` and can be substituted anywhere without breaking behavior or contracts.
- **I (Interface Segregation Principle)**: Read operations (`ServerReader`) and mutation operations (`ServerWriter`) are segregated into distinct interfaces before being combined into `ServerRepository`.
- **D (Dependency Inversion Principle)**: `HomeScreen` and `ServerMonitorApp` depend strictly on the abstract `ServerRepository`, never directly on the concrete `InMemoryServerRepository`.
