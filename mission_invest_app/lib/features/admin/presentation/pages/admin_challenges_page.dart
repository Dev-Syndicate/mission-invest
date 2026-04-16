import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminChallengesPage extends ConsumerWidget {
  const AdminChallengesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Challenges')),
      body: const Center(child: Text('TODO: Challenge management')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Show create challenge dialog
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
