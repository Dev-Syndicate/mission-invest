import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/empty_state.dart';

class MissionListPage extends ConsumerWidget {
  const MissionListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Missions')),
      body: EmptyState(
        icon: Icons.flag_outlined,
        title: 'No missions yet',
        subtitle: 'Create your first savings mission and start saving!',
        actionLabel: 'Create Mission',
        onAction: () => context.pushNamed('missionCreate'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed('missionCreate'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
