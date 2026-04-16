import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/dashboard_card.dart';
import 'quick_contribute_button.dart';

class MissionCard extends StatelessWidget {
  final String? missionId;
  final String title;
  final String? subtitle;
  final String? categoryEmoji;
  final double progress;
  final int streak;
  final int daysLeft;
  final double? savedAmount;
  final double? targetAmount;
  final double? dailyTarget;
  final VoidCallback? onTap;

  const MissionCard({
    super.key,
    this.missionId,
    required this.title,
    this.subtitle,
    this.categoryEmoji,
    required this.progress,
    required this.streak,
    required this.daysLeft,
    this.savedAmount,
    this.targetAmount,
    this.dailyTarget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DashboardCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: emoji + title + streak
          Row(
            children: [
              if (categoryEmoji != null) ...[
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withAlpha(20),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(categoryEmoji!,
                        style: const TextStyle(fontSize: 22)),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(120),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (streak > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6D00), Color(0xFFFF9800)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        size: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '$streak',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Progress bar + amounts
          if (savedAmount != null && targetAmount != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${CurrencyFormatter.compact(savedAmount!)} / ${CurrencyFormatter.compact(targetAmount!)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _progressColor(progress),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            AnimatedProgressBar(
              progress: progress,
              color: _progressColor(progress),
              height: 6,
            ),
          ] else ...[
            Row(
              children: [
                CircularPercentIndicator(
                  radius: 24,
                  lineWidth: 5,
                  percent: progress.clamp(0.0, 1.0),
                  center: Text(
                    '${(progress * 100).toInt()}%',
                    style: theme.textTheme.labelSmall,
                  ),
                  progressColor: _progressColor(progress),
                  backgroundColor:
                      theme.colorScheme.primary.withAlpha(25),
                  circularStrokeCap: CircularStrokeCap.round,
                  animation: true,
                  animationDuration: 800,
                ),
              ],
            ),
          ],

          const SizedBox(height: 12),

          // Bottom row: days left + quick contribute
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (daysLeft > 0)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 14,
                      color: theme.colorScheme.onSurface.withAlpha(120),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$daysLeft days left',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(120),
                      ),
                    ),
                  ],
                )
              else
                const SizedBox.shrink(),
              if (missionId != null && dailyTarget != null)
                QuickContributeButton(
                  missionId: missionId!,
                  missionTitle: title,
                  dailyTarget: dailyTarget!,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _progressColor(double p) {
    if (p >= 0.75) return AppColors.progressGreen;
    if (p >= 0.50) return AppColors.progressYellow;
    return AppColors.progressRed;
  }
}
