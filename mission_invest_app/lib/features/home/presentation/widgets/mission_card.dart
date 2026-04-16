import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MissionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final double progress;
  final int streak;
  final int daysLeft;
  final VoidCallback? onTap;

  const MissionCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.progress,
    required this.streak,
    required this.daysLeft,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircularPercentIndicator(
                radius: 32,
                lineWidth: 6,
                percent: progress.clamp(0.0, 1.0),
                center: Text(
                  '${(progress * 100).toInt()}%',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                progressColor: Theme.of(context).colorScheme.primary,
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withAlpha(38),
                circularStrokeCap: CircularStrokeCap.round,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
              if (streak > 0 || daysLeft > 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (streak > 0)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.local_fire_department,
                            size: 16,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '$streak',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                          ),
                        ],
                      ),
                    if (daysLeft > 0) ...[
                      const SizedBox(height: 4),
                      Text(
                        '$daysLeft days left',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
