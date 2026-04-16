import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/empty_state.dart';

class BadgesPage extends ConsumerWidget {
  const BadgesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Watch userBadgesProvider
    return Scaffold(
      appBar: AppBar(title: const Text('Rewards')),
      body: const EmptyState(
        icon: Icons.emoji_events_outlined,
        title: 'No badges earned yet',
        subtitle: 'Complete missions and build streaks to earn badges!',
      ),
    );
  }
}
