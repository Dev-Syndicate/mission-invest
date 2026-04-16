import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/progress_ring.dart';
import '../widgets/streak_counter.dart';
import '../widgets/milestone_indicator.dart';

class MissionDetailPage extends ConsumerWidget {
  final String missionId;

  const MissionDetailPage({super.key, required this.missionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Watch missionDetailProvider(missionId)
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mission Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () =>
                context.pushNamed('missionEdit', pathParameters: {
              'missionId': missionId,
            }),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(child: ProgressRing(progress: 0, size: 160)),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'Mission Title',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StreakCounter(streak: 0),
              MilestoneIndicator(progress: 0),
            ],
          ),
          const SizedBox(height: 24),
          _InfoRow(label: 'Target', value: '\u20B90'),
          _InfoRow(label: 'Saved', value: '\u20B90'),
          _InfoRow(label: 'Remaining', value: '\u20B90'),
          _InfoRow(label: 'Days Left', value: '0'),
          _InfoRow(label: 'Daily Target', value: '\u20B90'),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () =>
                context.pushNamed('logContribution', pathParameters: {
              'missionId': missionId,
            }),
            icon: const Icon(Icons.add),
            label: const Text('Log Contribution'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () =>
                context.pushNamed('contributionHistory', pathParameters: {
              'missionId': missionId,
            }),
            icon: const Icon(Icons.history),
            label: const Text('View History'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
