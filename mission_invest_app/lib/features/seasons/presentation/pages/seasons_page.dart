import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mission_invest_app/features/missions/data/models/mission_model.dart';

import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../home/presentation/providers/home_provider.dart';
import '../../data/models/season_model.dart';
import '../providers/season_provider.dart';
import '../../../social/presentation/widgets/anonymous_leaderboard.dart';

class SeasonsPage extends ConsumerWidget {
  const SeasonsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seasonsAsync = ref.watch(currentActiveSeasonsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenge Seasons'),
      ),
      body: seasonsAsync.when(
        loading: () => const Center(child: AppLoading()),
        error: (error, _) => AppErrorWidget(
          message: 'Failed to load seasons: $error',
          onRetry: () => ref.invalidate(currentActiveSeasonsProvider),
        ),
        data: (seasons) {
          if (seasons.isEmpty) {
            return const EmptyState(
              icon: Icons.emoji_events_outlined,
              title: 'No active seasons',
              subtitle: 'Check back soon for new challenge seasons!',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: seasons.length,
            itemBuilder: (context, index) {
              final season = seasons[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _SeasonBannerCard(season: season),
              );
            },
          );
        },
      ),
    );
  }
}

class _SeasonBannerCard extends ConsumerWidget {
  final SeasonModel season;

  const _SeasonBannerCard({required this.season});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM d');
    final uid = ref.watch(currentUserIdProvider);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner image or gradient header
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                ],
              ),
              image: season.bannerImageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(season.bannerImageUrl!),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withAlpha(60),
                        BlendMode.darken,
                      ),
                    )
                  : null,
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(40),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    season.category.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  season.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dates row
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: theme.colorScheme.onSurface.withAlpha(153),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${dateFormat.format(season.startDate)} – ${dateFormat.format(season.endDate)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(153),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.people_outline,
                      size: 14,
                      color: theme.colorScheme.onSurface.withAlpha(153),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${season.participantCount} joined',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(153),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Completion rate bar
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cohort completion rate',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withAlpha(153),
                            ),
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: season.completionRate.clamp(0.0, 1.0),
                              minHeight: 6,
                              backgroundColor:
                                  theme.colorScheme.primary.withAlpha(38),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${(season.completionRate * 100).toInt()}%',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Anonymous leaderboard
                if (uid != null)
                  AnonymousLeaderboard(seasonId: season.id),

                const SizedBox(height: 12),

                // Join button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => _showJoinDialog(context, ref, season),
                    icon: const Icon(Icons.add),
                    label: const Text('Join Season'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showJoinDialog(
    BuildContext context,
    WidgetRef ref,
    SeasonModel season,
  ) {
    final uid = ref.read(currentUserIdProvider);
    if (uid == null) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Join "${season.title}"'),
        content: const Text(
          'Select one of your active missions to link to this season. '
          'Your progress will be anonymously ranked among other participants.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _showMissionPicker(context, ref, season, uid);
            },
            child: const Text('Choose Mission'),
          ),
        ],
      ),
    );
  }

  void _showMissionPicker(
    BuildContext context,
    WidgetRef ref,
    SeasonModel season,
    String userId,
  ) {
    final missionsAsync = ref.read(homeActiveMissionsProvider);

    missionsAsync.whenData((missions) {
      if (missions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You need an active mission to join a season.'),
          ),
        );
        return;
      }

      showModalBottomSheet(
        context: context,
        builder: (ctx) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Pick a mission',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              ...missions.map(
                (mission) => ListTile(
                  leading: Text(
                    categoryEmoji(mission.category),
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(mission.title),
                  subtitle: Text(
                    '${(mission.progressPercentage * 100).toInt()}% complete',
                  ),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    ref.read(joinSeasonNotifierProvider.notifier).join(
                          userId: userId,
                          seasonId: season.id,
                          missionId: mission.id,
                        );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Joined "${season.title}" with ${mission.title}'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
