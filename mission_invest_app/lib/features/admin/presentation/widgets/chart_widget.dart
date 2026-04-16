import 'package:flutter/material.dart';

class ChartWidget extends StatelessWidget {
  final String title;

  const ChartWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // TODO: Implement with fl_chart
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            const SizedBox(
              height: 200,
              child: Center(child: Text('Chart placeholder')),
            ),
          ],
        ),
      ),
    );
  }
}
