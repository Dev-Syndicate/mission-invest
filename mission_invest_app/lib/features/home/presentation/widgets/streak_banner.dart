import 'package:flutter/material.dart';

class StreakBanner extends StatelessWidget {
  const StreakBanner({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Get actual streak from provider
    const globalStreak = 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
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
              const Icon(
                Icons.local_fire_department,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                '$globalStreak Day Streak',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            globalStreak == 0
                ? 'Start a mission to build your streak!'
                : 'Keep it going! Log a contribution today.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withAlpha(204),
                ),
          ),
        ],
      ),
    );
  }
}
