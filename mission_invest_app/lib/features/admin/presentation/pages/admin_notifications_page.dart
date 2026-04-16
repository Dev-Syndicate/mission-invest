import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminNotificationsPage extends ConsumerWidget {
  const AdminNotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Broadcast Notifications')),
      body: const Center(child: Text('TODO: Broadcast compose form')),
    );
  }
}
