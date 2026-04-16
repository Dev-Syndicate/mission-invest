import 'package:flutter/material.dart';


class MilestoneIndicator extends StatelessWidget {
  final double progress;

  const MilestoneIndicator({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final milestones = [0.25, 0.50, 0.75, 1.0];
    final labels = ['25%', '50%', '75%', '100%'];
    final icons = [
      Icons.emoji_events_outlined,
      Icons.star_outline,
      Icons.rocket_launch_outlined,
      Icons.celebration_outlined,
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(milestones.length, (index) {
        final reached = progress >= milestones[index];
        // Next target: not yet reached but previous one is
        final isNext = !reached &&
            (index == 0 || progress >= milestones[index - 1]);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: reached
                      ? Theme.of(context).colorScheme.primary
                      : isNext
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withAlpha(51)
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withAlpha(25),
                  border: isNext
                      ? Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        )
                      : null,
                ),
                child: Icon(
                  reached ? Icons.check : icons[index],
                  size: 20,
                  color: reached
                      ? Theme.of(context).colorScheme.onPrimary
                      : isNext
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                labels[index],
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: reached ? FontWeight.bold : FontWeight.normal,
                      color: reached
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                    ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
