import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/dashboard_card.dart';
import '../../data/models/badge_model.dart';
import '../providers/badges_provider.dart';
import '../providers/marketplace_provider.dart';

class BadgesPage extends ConsumerWidget {
  const BadgesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badgesAsync = ref.watch(userBadgesProvider);
    final xpBalance = ref.watch(userXpBalanceProvider);
    final xpTotal = ref.watch(userXpTotalEarnedProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards'),
        actions: [
          // XP display pill
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber.withAlpha(20),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber.withAlpha(40)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star_rounded,
                    size: 18, color: Colors.amber.shade600),
                const SizedBox(width: 4),
                Text(
                  '$xpBalance XP',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // XP Hero card
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: DashboardCard(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.accent,
                  AppColors.accentDark,
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total XP Earned',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withAlpha(180),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '$xpTotal XP',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () => context.push('/rewards/marketplace'),
                    icon: const Icon(Icons.storefront_rounded, size: 18),
                    label: const Text('Marketplace'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white.withAlpha(30),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(
                  begin: 0.05,
                  duration: 400.ms,
                  curve: Curves.easeOutCubic,
                ),
          ),

          // Section header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Your Badges',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Badges list
          Expanded(
            child: badgesAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (err, _) =>
                  Center(child: Text('Error loading badges: $err')),
              data: (badges) {
                if (badges.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(userBadgesProvider);
                      ref.invalidate(userXpBalanceProvider);
                      ref.invalidate(userXpTotalEarnedProvider);
                    },
                    child: LayoutBuilder(
                      builder: (context, constraints) =>
                          SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight: constraints.maxHeight),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.emoji_events_outlined,
                                  size: 64,
                                  color: theme.colorScheme.primary
                                      .withAlpha(80),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No badges earned yet',
                                  style: theme.textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Complete missions and build streaks to earn badges!',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withAlpha(120),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(userBadgesProvider);
                    ref.invalidate(userXpBalanceProvider);
                    ref.invalidate(userXpTotalEarnedProvider);
                  },
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                    itemCount: badges.length,
                    itemBuilder: (context, index) {
                      final badge = badges[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _BadgeListTile(badge: badge),
                      )
                          .animate()
                          .fadeIn(
                            duration: 350.ms,
                            delay: (50 * index).ms,
                          )
                          .slideX(
                            begin: 0.04,
                            duration: 350.ms,
                            delay: (50 * index).ms,
                            curve: Curves.easeOutCubic,
                          );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeListTile extends StatelessWidget {
  final BadgeModel badge;

  const _BadgeListTile({required this.badge});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DashboardCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.badgeGold.withAlpha(15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.badgeGold.withAlpha(30),
              ),
            ),
            child: Center(
              child: Text(
                badge.emoji,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  badge.displayName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  badge.missionTitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(120),
                  ),
                ),
              ],
            ),
          ),
          Text(
            _formatDate(badge.earnedAt),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(100),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}
