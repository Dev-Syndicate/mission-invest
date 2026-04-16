import 'package:flutter/material.dart';

class MilestoneIndicator extends StatelessWidget {
  final double progress;

  const MilestoneIndicator({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final milestones = [0.25, 0.50, 0.75, 1.0];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: milestones.map((m) {
        final reached = progress >= m;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            children: [
              Icon(
                reached ? Icons.check_circle : Icons.circle_outlined,
                size: 24,
                color: reached
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
              ),
              const SizedBox(height: 4),
              Text(
                '${(m * 100).toInt()}%',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
