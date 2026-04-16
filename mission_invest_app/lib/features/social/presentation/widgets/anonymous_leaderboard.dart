import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../seasons/presentation/providers/season_provider.dart';

/// An anonymous leaderboard widget that shows the user's rank as "Top X%"
/// with a distribution bar. No usernames or amounts are ever displayed.
class AnonymousLeaderboard extends ConsumerWidget {
  final String seasonId;

  const AnonymousLeaderboard({super.key, required this.seasonId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rankAsync = ref.watch(currentUserSeasonRankProvider(seasonId));
    final theme = Theme.of(context);

    return rankAsync.when(
      loading: () => const SizedBox(
        height: 80,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (rank) => _LeaderboardContent(rank: rank, theme: theme),
    );
  }
}

class _LeaderboardContent extends StatelessWidget {
  final int rank;
  final ThemeData theme;

  const _LeaderboardContent({required this.rank, required this.theme});

  @override
  Widget build(BuildContext context) {
    final userPosition = rank / 100.0; // 0.0 = best, 1.0 = worst

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.leaderboard_rounded,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Your Ranking',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // "Top X%" badge
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: _rankColor(rank).withAlpha(25),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _rankColor(rank).withAlpha(100),
                  ),
                ),
                child: Text(
                  'Top $rank%',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _rankColor(rank),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Distribution bar
            Text(
              'Distribution',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(153),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 24,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final markerPos = (userPosition * width).clamp(8.0, width - 8);

                  return Stack(
                    children: [
                      // Gradient bar
                      Container(
                        height: 12,
                        margin: const EdgeInsets.only(top: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.progressGreen,
                              AppColors.progressYellow,
                              AppColors.progressRed,
                            ],
                          ),
                        ),
                      ),
                      // User marker
                      Positioned(
                        left: markerPos - 6,
                        top: 0,
                        child: Column(
                          children: [
                            Container(
                              width: 12,
                              height: 24,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.onSurface,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: theme.colorScheme.surface,
                                  width: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top performers',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(102),
                    fontSize: 10,
                  ),
                ),
                Text(
                  'Getting started',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(102),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _rankColor(int rank) {
    if (rank <= 10) return AppColors.progressGreen;
    if (rank <= 30) return AppColors.success;
    if (rank <= 60) return AppColors.progressYellow;
    return AppColors.progressRed;
  }
}
