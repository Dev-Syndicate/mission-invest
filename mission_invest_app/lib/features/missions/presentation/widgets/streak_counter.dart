import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class StreakCounter extends StatelessWidget {
  final int streak;

  const StreakCounter({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.local_fire_department,
          size: 32,
          color: streak > 0 ? AppColors.streakFire : Colors.grey,
        ),
        const SizedBox(height: 4),
        Text(
          '$streak',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: streak > 0 ? AppColors.streakFire : Colors.grey,
              ),
        ),
        Text(
          'Day Streak',
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}
