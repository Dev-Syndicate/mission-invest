import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../../core/theme/app_colors.dart';

class ProgressRing extends StatelessWidget {
  final double progress;
  final double size;

  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 120,
  });

  Color get _progressColor {
    if (progress >= 0.75) return AppColors.progressGreen;
    if (progress >= 0.50) return AppColors.progressYellow;
    return AppColors.progressRed;
  }

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: size / 2,
      lineWidth: size * 0.08,
      percent: progress.clamp(0.0, 1.0),
      center: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${(progress * 100).toInt()}%',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            'funded',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      progressColor: _progressColor,
      backgroundColor: _progressColor.withAlpha(38),
      circularStrokeCap: CircularStrokeCap.round,
      animation: true,
      animationDuration: 800,
    );
  }
}
