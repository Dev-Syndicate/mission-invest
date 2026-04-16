import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationSettingsPage extends ConsumerWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Enable daily reminders and streak alerts'),
            value: true,
            onChanged: (v) {
              // TODO: Update user notifications setting
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('Reminder Time'),
            subtitle: const Text('9:00 AM'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Show time picker
            },
          ),
        ],
      ),
    );
  }
}
