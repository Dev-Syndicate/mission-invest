import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminTemplatesPage extends ConsumerWidget {
  const AdminTemplatesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mission Templates')),
      body: const Center(child: Text('TODO: Template CRUD')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Show create template dialog
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
