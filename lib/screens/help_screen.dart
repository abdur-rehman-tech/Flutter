import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Concept: Stateless vs Stateful:
// HelpScreen is a StatefulWidget because WebViewController holds lifecycle and state for the webview.
// Concept: WebView widget - embedding external interactive web content inside Flutter.
// SOLID - S (Single Responsibility Principle): Displays the Grafana monitoring documentation help page.

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            // Gracefully handle network/load errors
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse('https://grafana.com/docs/'));
  }

  @override
  Widget build(BuildContext context) {
    // Concept: Scaffold + AppBar widget tree
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Documentation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload Documentation',
            onPressed: () => _controller.reload(),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
