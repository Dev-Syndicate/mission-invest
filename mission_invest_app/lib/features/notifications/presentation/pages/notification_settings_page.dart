import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../home/presentation/providers/home_provider.dart';
import '../../../../repositories/user_repository.dart';
import '../../../../shared/widgets/app_loading.dart';

class NotificationSettingsPage extends ConsumerWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: userAsync.when(
        loading: () => const Center(child: AppLoading()),
        error: (e, _) => const Center(child: AppLoading()),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Not signed in'));
          }

          final notificationsEnabled = user.notificationsEnabled;
          final reminderTime = user.notificationTime;

          final parts = reminderTime.split(':');
          final hour = int.tryParse(parts[0]) ?? 9;
          final minute = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;
          final timeOfDay = TimeOfDay(hour: hour, minute: minute);

          return ListView(
            children: [
              SwitchListTile(
                title: const Text('Push Notifications'),
                subtitle:
                    const Text('Enable daily reminders and streak alerts'),
                value: notificationsEnabled,
                onChanged: (v) {
                  ref.read(userRepositoryProvider).updateUser(
                    user.uid,
                    {'notificationsEnabled': v},
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text('Reminder Time'),
                subtitle: Text(timeOfDay.format(context)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: timeOfDay,
                  );
                  if (picked != null) {
                    final h = picked.hour.toString().padLeft(2, "0");
                    final m = picked.minute.toString().padLeft(2, "0");
                    ref.read(userRepositoryProvider).updateUser(
                      user.uid,
                      {'notificationTime': "$h:$m"},
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
