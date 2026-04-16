import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/home_provider.dart';

class StreakBanner extends ConsumerWidget {
  const StreakBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(currentUserProfileProvider);
    final globalStreak = userProfile.valueOrNull?.currentGlobalStreak ?? 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: globalStreak > 0
              ? [AppColors.streakFire, AppColors.warning]
              : [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_fire_department,
                color: Colors.white,
                size: globalStreak > 0 ? 32 : 28,
              ),
              const SizedBox(width: 8),
              Text(
                '$globalStreak Day Streak',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (globalStreak >= 7) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(51),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _streakLabel(globalStreak),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _motivationText(globalStreak),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withAlpha(204),
                ),
          ),
        ],
      ),
    );
  }

  String _motivationText(int streak) {
    if (streak == 0) return 'Start a mission to build your streak!';
    if (streak < 3) return 'Great start! Keep going to build momentum.';
    if (streak < 7) return 'You\'re on fire! Don\'t break the chain.';
    if (streak < 30) return 'Incredible discipline! Keep it going!';
    return 'Legendary streak! You\'re unstoppable!';
  }

  String _streakLabel(int streak) {
    if (streak >= 30) return 'LEGENDARY';
    if (streak >= 14) return 'ON FIRE';
    return 'WARRIOR';
  }
}
