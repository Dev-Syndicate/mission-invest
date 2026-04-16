import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../rewards/data/models/badge_model.dart';
import '../providers/home_provider.dart';

class RecentBadgesRow extends ConsumerWidget {
  const RecentBadgesRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badgesAsync = ref.watch(homeRecentBadgesProvider);
    final theme = Theme.of(context);

    return badgesAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (badges) {
        if (badges.isEmpty) return const SizedBox.shrink();

        final recent = badges.take(10).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              'Recent Badges',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 140,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: recent.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final badge = recent[index];
                  return _BadgeChip(badge: badge);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BadgeChip extends StatelessWidget {
  final BadgeModel badge;

  const _BadgeChip({required this.badge});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat.MMMd().format(badge.earnedAt);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.badgeGold.withAlpha(isDark ? 50 : 80),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.badgeGold.withAlpha(isDark ? 15 : 10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(badge.emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 6),
          Text(
            badge.displayName,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            dateStr,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(100),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
