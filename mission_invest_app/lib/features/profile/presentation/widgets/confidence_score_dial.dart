import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../data/models/confidence_score.dart';
import '../../data/services/confidence_score_service.dart';

/// A circular dial widget that displays the user's Financial Confidence Score.
///
/// Shows a coloured arc (tinted by tier), the numeric score in the centre,
/// the tier label below, and an optional expandable breakdown section.
class ConfidenceScoreDial extends ConsumerWidget {
  const ConfidenceScoreDial({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreAsync = ref.watch(confidenceScoreProvider);

    return scoreAsync.when(
      loading: () => const Center(
        child: SizedBox(
          width: 48,
          height: 48,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (err, _) => Center(
        child: Text(
          'Unable to load score',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      data: (score) => _DialContent(score: score),
    );
  }
}

class _DialContent extends StatefulWidget {
  final ConfidenceScore score;

  const _DialContent({required this.score});

  @override
  State<_DialContent> createState() => _DialContentState();
}

class _DialContentState extends State<_DialContent> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tierColor = _tierColor(widget.score.tier);
    final percent = (widget.score.score / 1000).clamp(0.0, 1.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularPercentIndicator(
          radius: 80.0,
          lineWidth: 12.0,
          percent: percent,
          animation: true,
          animationDuration: 1200,
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: tierColor,
          backgroundColor: tierColor.withValues(alpha: 0.15),
          center: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${widget.score.score}',
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: tierColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'of 1000',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          widget.score.label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: tierColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Tier ${widget.score.tier}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 8),
        // Expandable breakdown
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Score Breakdown',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                _expanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 18,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
        ),
        if (_expanded) ...[
          const SizedBox(height: 12),
          _BreakdownSection(breakdown: widget.score.breakdown),
        ],
      ],
    );
  }

  Color _tierColor(int tier) {
    switch (tier) {
      case 1:
        return Colors.grey;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.teal;
      case 4:
        return Colors.orange;
      case 5:
        return Colors.amber.shade700;
      default:
        return Colors.grey;
    }
  }
}

/// Displays the per-component score breakdown as labelled linear bars.
class _BreakdownSection extends StatelessWidget {
  final Map<String, double> breakdown;

  const _BreakdownSection({required this.breakdown});

  @override
  Widget build(BuildContext context) {
    final entries = [
      _BreakdownEntry('Streak Ratio', breakdown['streakRatio'] ?? 0, 300),
      _BreakdownEntry(
          'Checkpoint Completion', breakdown['checkpointCompletion'] ?? 0, 250),
      _BreakdownEntry(
          'Mission Completion', breakdown['missionCompletion'] ?? 0, 250),
      _BreakdownEntry(
          'Recovery Success', breakdown['recoverySuccess'] ?? 0, 100),
      _BreakdownEntry(
          'Consistency Bonus', breakdown['consistencyBonus'] ?? 0, 100),
    ];

    return Column(
      children: entries
          .map((e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: _BreakdownRow(entry: e),
              ))
          .toList(),
    );
  }
}

class _BreakdownEntry {
  final String label;
  final double points;
  final int maxPoints;

  _BreakdownEntry(this.label, this.points, this.maxPoints);
}

class _BreakdownRow extends StatelessWidget {
  final _BreakdownEntry entry;

  const _BreakdownRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fraction =
        entry.maxPoints > 0 ? (entry.points / entry.maxPoints).clamp(0.0, 1.0) : 0.0;

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            entry.label,
            style: theme.textTheme.bodySmall,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 6,
              backgroundColor:
                  theme.colorScheme.onSurface.withValues(alpha: 0.1),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 48,
          child: Text(
            '${entry.points.round()}/${entry.maxPoints}',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
