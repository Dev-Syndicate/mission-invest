import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/mission_model.dart';
import '../../data/models/mission_phase.dart';

/// A horizontal journey-map widget showing 4 phase nodes connected by lines
/// with checkpoint markers at 25%, 50%, 75%.
class MissionMap extends StatelessWidget {
  final MissionModel mission;

  const MissionMap({super.key, required this.mission});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final daysElapsed = mission.daysElapsed;
    final totalDays = mission.durationDays;
    final currentPhase = MissionPhaseHelper.getPhase(daysElapsed);
    final currentIndex = MissionPhaseHelper.index(currentPhase);
    final progress = mission.progressPercentage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Phase label
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withAlpha(25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${MissionPhaseHelper.emoji(currentPhase)}  ${MissionPhaseHelper.label(currentPhase)}',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Map nodes
        SizedBox(
          height: 100,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final totalWidth = constraints.maxWidth;
              return Stack(
                children: [
                  // Background connecting line
                  Positioned(
                    top: 24,
                    left: 24,
                    right: 24,
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface.withAlpha(38),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Progress line
                  Positioned(
                    top: 24,
                    left: 24,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                      height: 3,
                      width: _progressLineWidth(
                        currentIndex,
                        currentPhase,
                        daysElapsed,
                        totalDays,
                        totalWidth - 48,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.secondary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Checkpoint markers at 25%, 50%, 75%
                  ..._buildCheckpoints(
                    context,
                    progress,
                    totalWidth,
                  ),

                  // Phase nodes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      MissionPhase.values.length,
                      (i) {
                        final phase = MissionPhase.values[i];
                        final isPast = i < currentIndex;
                        final isCurrent = i == currentIndex;
                        final isFuture = i > currentIndex;

                        return _PhaseNode(
                          phase: phase,
                          isPast: isPast,
                          isCurrent: isCurrent,
                          isFuture: isFuture,
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  double _progressLineWidth(
    int currentIndex,
    MissionPhase currentPhase,
    int daysElapsed,
    int totalDays,
    double totalWidth,
  ) {
    final segmentWidth = totalWidth / 3; // 3 segments between 4 nodes
    final withinPhase = MissionPhaseHelper.phaseProgress(
      currentPhase,
      daysElapsed,
      totalDays,
    );
    return (currentIndex * segmentWidth) + (withinPhase * segmentWidth);
  }

  List<Widget> _buildCheckpoints(
    BuildContext context,
    double progress,
    double totalWidth,
  ) {
    final theme = Theme.of(context);
    final checkpoints = [0.25, 0.50, 0.75];
    final lineWidth = totalWidth - 48; // padding on each side

    return checkpoints.map((cp) {
      final reached = progress >= cp;
      // Position checkpoint proportionally along the line
      final left = 24 + (cp * lineWidth);

      return Positioned(
        top: 16,
        left: left - 8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: reached
                    ? AppColors.badgeGold
                    : theme.colorScheme.surface,
                border: Border.all(
                  color: reached
                      ? AppColors.badgeGold
                      : theme.colorScheme.onSurface.withAlpha(51),
                  width: 2,
                ),
              ),
              child: reached
                  ? const Icon(Icons.star, size: 10, color: Colors.white)
                  : Icon(
                      Icons.shield_outlined,
                      size: 8,
                      color: theme.colorScheme.onSurface.withAlpha(76),
                    ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

class _PhaseNode extends StatelessWidget {
  final MissionPhase phase;
  final bool isPast;
  final bool isCurrent;
  final bool isFuture;

  const _PhaseNode({
    required this.phase,
    required this.isPast,
    required this.isCurrent,
    required this.isFuture,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final nodeColor = isPast
        ? theme.colorScheme.primary
        : isCurrent
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface.withAlpha(38);

    final iconColor = isPast || isCurrent
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurface.withAlpha(76);

    final textColor = isPast || isCurrent
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.withAlpha(102);

    Widget node = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: nodeColor,
            boxShadow: isCurrent
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withAlpha(76),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: isPast
                ? Icon(Icons.check, size: 22, color: iconColor)
                : Text(
                    MissionPhaseHelper.emoji(phase),
                    style: TextStyle(
                      fontSize: isFuture ? 16 : 20,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 72,
          child: Text(
            MissionPhaseHelper.label(phase),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );

    // Pulse animation for current phase
    if (isCurrent) {
      node = node
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .scale(
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.06, 1.06),
            duration: 1200.ms,
            curve: Curves.easeInOut,
          );
    }

    return node;
  }
}
