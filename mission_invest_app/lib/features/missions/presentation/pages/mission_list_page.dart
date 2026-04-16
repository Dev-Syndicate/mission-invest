import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../home/presentation/providers/home_provider.dart';
import '../../data/models/mission_model.dart';
import '../providers/mission_list_provider.dart';

class MissionListPage extends ConsumerWidget {
  const MissionListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missionsAsync = ref.watch(allMissionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Missions')),
      body: missionsAsync.when(
        loading: () => const Center(child: AppLoading()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (missions) {
          if (missions.isEmpty) {
            return EmptyState(
              icon: Icons.flag_outlined,
              title: 'No missions yet',
              subtitle:
                  'Create your first savings mission and start saving!',
              actionLabel: 'Create Mission',
              onAction: () => context.pushNamed('missionCreate'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: missions.length,
            itemBuilder: (context, index) {
              final mission = missions[index];
              final progress = mission.progressPercentage;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .primary
                        .withAlpha(30),
                    child: Text(
                      mission.missionEmoji ??
                          categoryEmoji(mission.category),
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  title: Text(
                    mission.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: progress,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(progress * 100).toStringAsFixed(0)}% \u2022 '
                        '${mission.daysRemaining} days left \u2022 '
                        '\u{1F525} ${mission.currentStreak}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  trailing: _StatusChip(status: mission.status),
                  onTap: () =>
                      context.pushNamed('missionDetail', pathParameters: {
                    'missionId': mission.id,
                  }),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed('missionCreate'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'active' => Colors.green,
      'completed' => Colors.blue,
      'failed' => Colors.red,
      'paused' => Colors.orange,
      _ => Colors.grey,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
