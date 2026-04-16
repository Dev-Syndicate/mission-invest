import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
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

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: emoji + title + streak
              Row(
                children: [
                  if (categoryEmoji != null) ...[
                    Text(categoryEmoji!, style: const TextStyle(fontSize: 24)),
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
                              color: theme.colorScheme.onSurface.withAlpha(153),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (streak > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.streakFire.withAlpha(25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.local_fire_department,
                            size: 16,
                            color: AppColors.streakFire,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '$streak',
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.streakFire,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12),

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
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 6,
                    backgroundColor:
                        theme.colorScheme.primary.withAlpha(38),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _progressColor(progress),
                    ),
                  ),
                ),
              ] else ...[
                // Fallback: circular indicator for simple cards
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
                      progressColor: theme.colorScheme.primary,
                      backgroundColor:
                          theme.colorScheme.primary.withAlpha(38),
                      circularStrokeCap: CircularStrokeCap.round,
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
                          Icons.schedule,
                          size: 14,
                          color: theme.colorScheme.onSurface.withAlpha(153),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$daysLeft days left',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color:
                                theme.colorScheme.onSurface.withAlpha(153),
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
        ),
      ),
    );
  }

  Color _progressColor(double p) {
    if (p >= 0.75) return AppColors.progressGreen;
    if (p >= 0.50) return AppColors.progressYellow;
    return AppColors.progressRed;
  }
}
