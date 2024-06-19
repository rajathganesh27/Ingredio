import 'package:flutter/material.dart';

class ResponseScreen extends StatelessWidget {
  final String responseText;

  const ResponseScreen({Key? key, required this.responseText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Response'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildResponseWidgets(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildResponseWidgets() {
    List<Widget> widgets = [];
    List<String> lines = responseText.split('\n');

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i].trim();
      if (line.isNotEmpty) {
        if (line.startsWith('Name:') ||
            line.startsWith('Ingredients:') ||
            line.startsWith('Additional Info:') ||
            line.startsWith('Score:')) {
          // Add subheading
          widgets.add(
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
              child: Text(
                line,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
          );
        } else {
          // Add content
          widgets.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                line,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          );
        }
      }
    }

    return widgets;
  }
}
