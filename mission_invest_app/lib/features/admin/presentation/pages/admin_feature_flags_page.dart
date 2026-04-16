import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminFeatureFlagsPage extends ConsumerWidget {
  const AdminFeatureFlagsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feature Flags')),
      body: const Center(child: Text('TODO: Feature flag toggles')),
    );
  }
}
