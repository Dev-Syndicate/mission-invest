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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: globalStreak > 0
              ? [AppColors.streakFire, const Color(0xFFFF9800)]
              : [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withAlpha(180),
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (globalStreak > 0
                    ? AppColors.streakFire
                    : theme.colorScheme.primary)
                .withAlpha(isDark ? 60 : 40),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.local_fire_department,
                      color: Colors.white,
                      size: globalStreak > 0 ? 28 : 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$globalStreak Day Streak',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _motivationText(globalStreak),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withAlpha(200),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (globalStreak >= 7)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(30),
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: Colors.white.withAlpha(40)),
                      ),
                      child: Text(
                        _streakLabel(globalStreak),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                ],
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
