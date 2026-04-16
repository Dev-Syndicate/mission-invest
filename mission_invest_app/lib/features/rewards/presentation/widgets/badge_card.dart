import 'package:flutter/material.dart';

class BadgeCard extends StatelessWidget {
  final String name;
  final String emoji;
  final String missionTitle;
  final DateTime earnedAt;
  final bool earned;

  const BadgeCard({
    super.key,
    required this.name,
    required this.emoji,
    required this.missionTitle,
    required this.earnedAt,
    this.earned = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 8),
            Text(
              name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              missionTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
