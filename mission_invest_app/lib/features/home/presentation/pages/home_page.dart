import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../missions/data/models/mission_model.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../providers/home_provider.dart';
import '../widgets/mission_card.dart';
import '../widgets/streak_banner.dart';
import '../widgets/recent_badges_row.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final greeting = ref.watch(homeGreetingProvider);
    final userProfile = ref.watch(currentUserProfileProvider);
    final missionsAsync = ref.watch(homeActiveMissionsProvider);

    final displayName =
        userProfile.valueOrNull?.displayName ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withAlpha(153),
                  ),
            ),
            if (displayName.isNotEmpty)
              Text(
                displayName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.pushNamed('notificationSettings'),
          ),
        ],
      ),
      body: missionsAsync.when(
        loading: () => const Center(child: AppLoading()),
        error: (error, _) {
          // Transient errors (e.g. permission settling) — show loading briefly
          // instead of flashing an error screen.
          debugPrint('Home missions error: $error');
          return const Center(child: AppLoading());
        },
        data: (missions) {
          if (missions.isEmpty) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const StreakBanner(),
                const SizedBox(height: 32),
                EmptyState(
                  icon: Icons.rocket_launch_outlined,
                  title: 'No active missions',
                  subtitle:
                      'Create your first mission and start saving towards your goal!',
                  actionLabel: 'Create Your First Mission',
                  onAction: () => context.pushNamed('missionCreate'),
                ),
                const RecentBadgesRow(),
              ],
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const StreakBanner(),
              const SizedBox(height: 24),

              // Active Missions header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Active Missions',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextButton.icon(
                    onPressed: () => context.pushNamed('missionCreate'),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('New'),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Mission cards
              ...missions.map((mission) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: MissionCard(
                      missionId: mission.id,
                      title: mission.title,
                      categoryEmoji: categoryEmoji(mission.category),
                      progress: mission.progressPercentage,
                      streak: mission.currentStreak,
                      daysLeft: mission.daysRemaining,
                      savedAmount: mission.savedAmount,
                      targetAmount: mission.targetAmount,
                      dailyTarget: mission.dailyTarget,
                      onTap: () => context.push('/missions/${mission.id}'),
                    ),
                  )),

              // Seasons & Teams entry points
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _HomeEntryCard(
                      icon: Icons.emoji_events_outlined,
                      label: 'Seasons',
                      onTap: () => context.push('/seasons'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _HomeEntryCard(
                      icon: Icons.groups_outlined,
                      label: 'Teams',
                      onTap: () => context.push('/teams'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Recent badges
              const RecentBadgesRow(),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}

class _HomeEntryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _HomeEntryCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
