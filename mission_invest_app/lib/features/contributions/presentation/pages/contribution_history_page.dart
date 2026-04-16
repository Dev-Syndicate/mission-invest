import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../widgets/contribution_tile.dart';

class ContributionHistoryPage extends ConsumerWidget {
  final String missionId;

  const ContributionHistoryPage({super.key, required this.missionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Watch missionContributionsProvider(missionId)
    return Scaffold(
      appBar: AppBar(title: const Text('Contribution History')),
      body: const EmptyState(
        icon: Icons.history,
        title: 'No contributions yet',
        subtitle: 'Log your first contribution to start tracking progress.',
      ),
    );
  }
}
