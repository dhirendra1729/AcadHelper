import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  final String text;
  final String summary;

  const ResultCard({
    super.key, 
    required this.text, 
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.summarize, color: Colors.blueAccent),
                SizedBox(width: 8),
                Text(
                  'AI Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 25),
            Text(
              summary,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 20),
            const ExpansionTile(
              title: Text('Original Text'),
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Full extracted text will be shown here if needed.',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
