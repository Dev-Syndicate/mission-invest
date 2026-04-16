import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CertificatePage extends ConsumerWidget {
  final String missionId;

  const CertificatePage({super.key, required this.missionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Generate certificate from mission data
    return Scaffold(
      appBar: AppBar(
        title: const Text('Certificate'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Screenshot and share certificate
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.emoji_events, size: 64, color: Colors.amber),
                  const SizedBox(height: 16),
                  Text(
                    'Mission Complete!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Congratulations on completing your mission!'),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text('Mission: [Title]'),
                  const Text('Amount Saved: \u20B9[Amount]'),
                  const Text('Days Taken: [Days]'),
                  const Text('Completed: [Date]'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
