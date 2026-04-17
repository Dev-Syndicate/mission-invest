import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../missions/data/models/mission_model.dart';
import '../../../ai/presentation/providers/ai_provider.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../providers/home_provider.dart';
import '../widgets/balance_hero_card.dart';
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
    final theme = Theme.of(context);

    final displayName = userProfile.valueOrNull?.displayName ?? '';
    final totalSaved = userProfile.valueOrNull?.totalSaved ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(120),
                fontWeight: FontWeight.w500,
              ),
            ),
            if (displayName.isNotEmpty)
              Text(
                displayName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.notifications_outlined,
                size: 20,
                color: theme.colorScheme.onSurface,
              ),
            ),
            onPressed: () => context.pushNamed('notificationSettings'),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: missionsAsync.when(
        loading: () => const Center(child: AppLoading()),
        error: (error, _) {
          debugPrint('Home missions error: $error');
          return const Center(child: AppLoading());
        },
        data: (missions) {
          // Compute sparkline data from missions saved amounts
          final recentAmounts = missions
              .map((m) => m.savedAmount)
              .toList();
          if (recentAmounts.isEmpty) recentAmounts.addAll([0, 0]);
          if (recentAmounts.length == 1) recentAmounts.insert(0, 0);

          // Compute weekly growth approximation
          final totalTarget = missions.fold<double>(
              0, (sum, m) => sum + m.targetAmount);
          final weeklyGrowth = totalTarget > 0
              ? (totalSaved / totalTarget) * 100
              : 0.0;

          if (missions.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(homeActiveMissionsProvider);
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  BalanceHeroCard(
                    totalSaved: totalSaved,
                    weeklyGrowth: weeklyGrowth,
                    recentAmounts: recentAmounts,
                  ).animate().fadeIn(duration: 500.ms).slideY(
                        begin: 0.05,
                        duration: 500.ms,
                        curve: Curves.easeOutCubic,
                      ),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 100),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(homeActiveMissionsProvider);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                // Hero balance card
                BalanceHeroCard(
                  totalSaved: totalSaved,
                  weeklyGrowth: weeklyGrowth,
                  recentAmounts: recentAmounts,
                ).animate().fadeIn(duration: 500.ms).slideY(
                      begin: 0.05,
                      duration: 500.ms,
                      curve: Curves.easeOutCubic,
                    ),
                const SizedBox(height: 20),

                // Streak banner
                const StreakBanner()
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 100.ms),
                const SizedBox(height: 16),

                // AI daily motivation
                _AiMotivationCard()
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 200.ms),
                const SizedBox(height: 24),

                // Active Missions header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Active Missions',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _AddButton(
                      onTap: () => context.pushNamed('missionCreate'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Mission cards with staggered animation
                ...missions.asMap().entries.map((entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: MissionCard(
                        missionId: entry.value.id,
                        title: entry.value.title,
                        categoryEmoji:
                            categoryEmoji(entry.value.category),
                        progress: entry.value.progressPercentage,
                        streak: entry.value.currentStreak,
                        daysLeft: entry.value.daysRemaining,
                        savedAmount: entry.value.savedAmount,
                        targetAmount: entry.value.targetAmount,
                        dailyTarget: entry.value.dailyTarget,
                        onTap: () =>
                            context.push('/missions/${entry.value.id}'),
                      )
                          .animate()
                          .fadeIn(
                            duration: 400.ms,
                            delay: (150 + entry.key * 80).ms,
                          )
                          .slideY(
                            begin: 0.05,
                            duration: 400.ms,
                            delay: (150 + entry.key * 80).ms,
                            curve: Curves.easeOutCubic,
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
                )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 300.ms),
                const SizedBox(height: 16),

                // Recent badges
                const RecentBadgesRow(),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withAlpha(20),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded,
                size: 16, color: theme.colorScheme.primary),
            const SizedBox(width: 4),
            Text(
              'New',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
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
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.onSurface.withAlpha(isDark ? 10 : 15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isDark ? 20 : 8),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
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
    );
  }
}

class _AiMotivationCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final motivationAsync = ref.watch(dailyMotivationProvider);
    final theme = Theme.of(context);

    return motivationAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (motivation) {
        if (motivation == null) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primaryContainer,
                theme.colorScheme.primaryContainer.withAlpha(140),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(
                Icons.smart_toy,
                color: theme.colorScheme.primary,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  motivation.message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
