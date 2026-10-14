import 'package:flutter/material.dart';
import '../models/server.dart';
import '../models/server_status.dart';

// Concept: Stateless vs Stateful:
// AddServerScreen is a StatefulWidget because it manages ephemeral form state,
// text controllers, radio selection, checkbox selection, and form validation.
// SOLID - S (Single Responsibility Principle): Handles new server input data collection and validation.

class AddServerScreen extends StatefulWidget {
  const AddServerScreen({super.key});

  @override
  State<AddServerScreen> createState() => _AddServerScreenState();
}

class _AddServerScreenState extends State<AddServerScreen> {
  // Concept: FormKey for validation
  final _formKey = GlobalKey<FormState>();

  // Concept: TextEditingController for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  // Concept: State variables tracking selections
  String _selectedEnvironment = 'Dev'; // Dev / UAT / Prod
  bool _alertsEnabled = true;

  @override
  void dispose() {
    _nameController.dispose();
    _ipController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // Simple IP Address validator
  String? _validateIp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'IP address is required';
    }
    final trimmed = value.trim();
    final parts = trimmed.split('.');
    if (parts.length != 4) {
      return 'Enter a valid IPv4 format (e.g., 192.168.1.10)';
    }
    for (final part in parts) {
      final number = int.tryParse(part);
      if (number == null || number < 0 || number > 255) {
        return 'Each octet must be between 0 and 255';
      }
    }
    return null;
  }

  void _saveServer() {
    // Concept: Form validation
    if (_formKey.currentState?.validate() ?? false) {
      // Build new server instance with fresh default metrics
      final newServer = Server(
        id: 'srv-${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        ipAddress: _ipController.text.trim(),
        description: _descController.text.trim(),
        environment: _selectedEnvironment,
        alertsEnabled: _alertsEnabled,
        status: ServerStatus.up,
        cpu: 25.0,
        ram: 35.0,
        disk: 45.0,
      );

      // Concept: Navigator.pop with returned value
      // Passes the newly created Server instance back to the awaiting caller screen
      Navigator.pop(context, newServer);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Concept: Scaffold + AppBar widget tree
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Server'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Concept: TextField - Single line text input with validation
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Server Name *',
                    hintText: 'e.g. auth-service-01',
                    prefixIcon: Icon(Icons.dns),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Server name is required';
                    }
                    if (value.trim().length < 3) {
                      return 'Name must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Concept: TextField - IP address text input with validation
                TextFormField(
                  controller: _ipController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'IP Address *',
                    hintText: 'e.g. 192.168.1.100',
                    prefixIcon: Icon(Icons.network_check),
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateIp,
                ),
                const SizedBox(height: 16),

                // Concept: Multiline TextField (maxLines: 5) - acts as rich/long text box for descriptions
                TextFormField(
                  controller: _descController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Description / Notes',
                    hintText: 'Enter server purpose, hardware specs, or maintenance notes...',
                    alignLabelWithHint: true,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 80),
                      child: Icon(Icons.description_outlined),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Concept: Radio button (RadioListTile) - Environment selection
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: Text(
                            'Target Environment',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        RadioGroup<String>(
                          groupValue: _selectedEnvironment,
                          onChanged: (String? value) {
                            if (value != null) {
                              // Concept: setState - Triggers UI rebuild when radio selection changes
                              setState(() {
                                _selectedEnvironment = value;
                              });
                            }
                          },
                          child: Column(
                            children: const [
                              RadioListTile<String>(
                                title: Text('Development (Dev)'),
                                subtitle: Text('Internal testing and staging tests'),
                                value: 'Dev',
                              ),
                              RadioListTile<String>(
                                title: Text('User Acceptance Testing (UAT)'),
                                subtitle: Text('Pre-production client validation'),
                                value: 'UAT',
                              ),
                              RadioListTile<String>(
                                title: Text('Production (Prod)'),
                                subtitle: Text('Live mission-critical services'),
                                value: 'Prod',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Concept: Checkbox (CheckboxListTile) - Toggle alert notifications
                Card(
                  child: CheckboxListTile(
                    title: const Text('Enable alerts for this server'),
                    subtitle: const Text('Send notifications when CPU/RAM exceed safe thresholds'),
                    secondary: const Icon(Icons.notifications_active_outlined),
                    value: _alertsEnabled,
                    onChanged: (bool? value) {
                      if (value != null) {
                        // Concept: setState - Triggers UI rebuild when checkbox toggles
                        setState(() {
                          _alertsEnabled = value;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Concept: Save button executing validation and Navigator.pop
                FilledButton.icon(
                  onPressed: _saveServer,
                  icon: const Icon(Icons.save_rounded),
                  label: const Text(
                    'Save Server',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
