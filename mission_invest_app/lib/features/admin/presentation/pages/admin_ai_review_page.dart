import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminAiReviewPage extends ConsumerWidget {
  const AdminAiReviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Review')),
      body: const Center(child: Text('TODO: AI log review table')),
    );
  }
}
