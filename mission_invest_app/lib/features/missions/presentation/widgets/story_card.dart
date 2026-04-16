import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';

/// Displays the emotional "Why This Mission Matters" story attached to a mission.
///
/// Shows a headline, optional personal note, and mission emoji in a card
/// with a subtle gradient background that matches the mission category.
class StoryCard extends StatelessWidget {
  final String storyHeadline;
  final String? personalNote;
  final String missionEmoji;
  final String category;

  const StoryCard({
    super.key,
    required this.storyHeadline,
    this.personalNote,
    required this.missionEmoji,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradientColors = _categoryGradient(category, theme);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: emoji + section title
            Row(
              children: [
                Text(
                  missionEmoji,
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Why This Mission Matters',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(153),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Story headline
            Text(
              storyHeadline,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),

            // Personal note (if set)
            if (personalNote != null && personalNote!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withAlpha(102),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  personalNote!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: theme.colorScheme.onSurface.withAlpha(179),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.05, end: 0, duration: 400.ms);
  }

  /// Returns a subtle gradient pair based on the mission category.
  List<Color> _categoryGradient(String category, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final alpha = isDark ? 40 : 25;

    return switch (category) {
      'trip' => [
          Colors.blue.withAlpha(alpha),
          Colors.cyan.withAlpha(alpha),
        ],
      'gadget' => [
          Colors.purple.withAlpha(alpha),
          Colors.indigo.withAlpha(alpha),
        ],
      'vehicle' => [
          Colors.orange.withAlpha(alpha),
          Colors.deepOrange.withAlpha(alpha),
        ],
      'emergency' => [
          AppColors.progressRed.withAlpha(alpha),
          Colors.red.withAlpha(alpha),
        ],
      'course' => [
          Colors.teal.withAlpha(alpha),
          AppColors.progressGreen.withAlpha(alpha),
        ],
      'gift' => [
          Colors.pink.withAlpha(alpha),
          Colors.pinkAccent.withAlpha(alpha),
        ],
      _ => [
          theme.colorScheme.primary.withAlpha(alpha),
          theme.colorScheme.secondary.withAlpha(alpha),
        ],
    };
  }
}
