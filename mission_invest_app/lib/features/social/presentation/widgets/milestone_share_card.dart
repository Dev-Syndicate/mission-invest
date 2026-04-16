import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// A styled card that displays milestone info for sharing.
/// Privacy-safe: does NOT show rupee amounts by default.
class MilestoneShareCard extends StatelessWidget {
  final String goalName;
  final double progressPercent; // 0.0 – 1.0
  final int streakCount;
  final bool showAmounts;
  final double? savedAmount;
  final double? targetAmount;

  const MilestoneShareCard({
    super.key,
    required this.goalName,
    required this.progressPercent,
    required this.streakCount,
    this.showAmounts = false,
    this.savedAmount,
    this.targetAmount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = (progressPercent * 100).toInt();

    return Container(
      width: 340,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withAlpha(200),
            theme.colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withAlpha(60),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App branding
          Row(
            children: [
              Icon(
                Icons.rocket_launch_rounded,
                color: Colors.white.withAlpha(230),
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                'Mission Invest',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.white.withAlpha(200),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Goal name
          Text(
            goalName,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // Progress ring and stats
          Row(
            children: [
              // Progress circle
              SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        value: progressPercent.clamp(0.0, 1.0),
                        strokeWidth: 6,
                        backgroundColor: Colors.white.withAlpha(50),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Text(
                      '$percent%',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 20),

              // Stats column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Streak
                    if (streakCount > 0) ...[
                      Row(
                        children: [
                          const Icon(
                            Icons.local_fire_department,
                            color: AppColors.streakFire,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$streakCount day streak',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],

                    // Optional amounts (privacy toggle)
                    if (showAmounts &&
                        savedAmount != null &&
                        targetAmount != null)
                      Text(
                        'Saved towards goal',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withAlpha(180),
                        ),
                      )
                    else
                      Text(
                        'Making progress!',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withAlpha(180),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progressPercent.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: Colors.white.withAlpha(50),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),

          const SizedBox(height: 16),

          // Footer
          Text(
            'Join me on Mission Invest!',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withAlpha(180),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
