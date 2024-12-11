import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  Future<void> loadTestJson() async {
    try {
      // final testString = await rootBundle.loadString('assets/json/reciter.json');
      // print("Test JSON String: $testString"); // Should print the test data
    } catch (e) {
      // print("Error loading test JSON: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Load the test JSON file when the widget is built
    loadTestJson();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test JSON Loading'),
      ),
      body: const Center(
        child: Text('Check console for JSON loading test results.'),
      ),
    );
  }
}
