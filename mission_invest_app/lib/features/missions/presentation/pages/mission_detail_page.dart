import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../home/presentation/providers/home_provider.dart';
import '../../../ai/presentation/providers/ai_provider.dart';
import '../../../ai/presentation/widgets/ai_nudge_card.dart';
import '../../../ai/presentation/widgets/ai_suggestion_bottom_sheet.dart';
import '../../../ai/data/models/adapt_response.dart';
import '../../data/models/mission_model.dart';
import '../../data/repositories/mission_repository.dart';
import '../providers/mission_detail_provider.dart';
import '../widgets/mission_map.dart';
import '../widgets/morphing_vision_card.dart';
import '../widgets/progress_ring.dart';
import '../widgets/streak_counter.dart';
import '../widgets/contract_status_badge.dart';
import '../widgets/milestone_indicator.dart';
import '../widgets/story_card.dart';
import '../../data/models/contract_model.dart';

class MissionDetailPage extends ConsumerWidget {
  final String missionId;

  const MissionDetailPage({super.key, required this.missionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missionAsync = ref.watch(missionDetailProvider(missionId));

    return missionAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Mission Details')),
        body: const Center(child: AppLoading()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text('Mission Details')),
        body: AppErrorWidget(
          message: 'Failed to load mission: $error',
          onRetry: () => ref.invalidate(missionDetailProvider(missionId)),
        ),
      ),
      data: (mission) {
        if (mission == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Mission Details')),
            body: const Center(
              child: Text('Mission not found'),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(mission.title),
            actions: [
              if (mission.isActive)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => context.pushNamed(
                    'missionEdit',
                    pathParameters: {'missionId': missionId},
                  ),
                ),
            ],
          ),
          body: _MissionDetailBody(mission: mission, missionId: missionId),
        );
      },
    );
  }
}

class _MissionDetailBody extends ConsumerWidget {
  final MissionModel mission;
  final String missionId;

  const _MissionDetailBody({
    required this.mission,
    required this.missionId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(missionDetailProvider(missionId));
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
      children: [
        // Status badge (if not active)
        if (!mission.isActive) ...[
          Center(child: _StatusChip(status: mission.status)),
          const SizedBox(height: 16),
        ],

        // Morphing vision card (replaces static vision image)
        MorphingVisionCard(
          visionImageUrl: mission.visionImageUrl,
          progressPercentage: mission.progressPercentage,
          category: mission.category,
        ),
        const SizedBox(height: 20),

        // Story card (if story headline is set)
        if (mission.storyHeadline != null &&
            mission.storyHeadline!.isNotEmpty) ...[
          StoryCard(
            storyHeadline: mission.storyHeadline!,
            personalNote: mission.personalNote,
            missionEmoji: mission.missionEmoji ?? categoryEmoji(mission.category),
            category: mission.category,
          ),
          const SizedBox(height: 16),
        ],

        // AI nudge card (shown when user is struggling)
        if (mission.isActive) _AiNudgeSection(mission: mission),

        // AI prediction chip
        if (mission.isActive) _AiPredictionSection(mission: mission),

        // Mission journey map
        MissionMap(mission: mission),
        const SizedBox(height: 20),

        // Progress ring
        Center(
          child: ProgressRing(
            progress: mission.progressPercentage,
            size: 160,
          ),
        ),
        const SizedBox(height: 16),

        // Title + category + contract badge
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                mission.missionEmoji ?? categoryEmoji(mission.category),
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  mission.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              if (mission.contractType != 'none') ...[
                const SizedBox(width: 8),
                ContractStatusBadge(
                  contractType: ContractType.values.firstWhere(
                    (e) => e.name == mission.contractType,
                    orElse: () => ContractType.none,
                  ),
                  contractStatus: ContractStatus.values.firstWhere(
                    (e) => e.name == mission.contractStatus,
                    orElse: () => ContractStatus.none,
                  ),
                ),
              ],
            ],
          ),
        ),

        // Motivation message
        if (mission.motivationMessage != null &&
            mission.motivationMessage!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '"${mission.motivationMessage!}"',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],

        const SizedBox(height: 24),

        // Streak + Milestones row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StreakCounter(streak: mission.currentStreak),
            Column(
              children: [
                Text(
                  '${mission.daysRemaining}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: mission.daysRemaining <= 7
                        ? AppColors.progressRed
                        : null,
                  ),
                ),
                Text(
                  'Days Left',
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Milestone indicators
        Center(
          child: MilestoneIndicator(progress: mission.progressPercentage),
        ),

        const SizedBox(height: 24),

        // Financial details card
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _InfoRow(
                  label: 'Target',
                  value: CurrencyFormatter.format(mission.targetAmount),
                ),
                const Divider(height: 24),
                _InfoRow(
                  label: 'Saved',
                  value: CurrencyFormatter.format(mission.savedAmount),
                  valueColor: AppColors.success,
                ),
                const Divider(height: 24),
                _InfoRow(
                  label: 'Remaining',
                  value: CurrencyFormatter.format(mission.amountRemaining),
                ),
                const Divider(height: 24),
                _InfoRow(
                  label: 'Days Left',
                  value: '${mission.daysRemaining}',
                ),
                const Divider(height: 24),
                _InfoRow(
                  label: 'Daily Target',
                  value: CurrencyFormatter.format(mission.dailyTarget),
                  valueColor: theme.colorScheme.primary,
                ),
                const Divider(height: 24),
                _InfoRow(
                  label: 'Longest Streak',
                  value: '${mission.longestStreak} days',
                ),
              ],
            ),
          ),
        ),

        // AI adaptation suggestion
        if (mission.isActive) _AiAdaptSection(mission: mission),

        const SizedBox(height: 24),

        // Action buttons
        if (mission.isActive) ...[
          FilledButton.icon(
            onPressed: () => context.pushNamed(
              'logContribution',
              pathParameters: {'missionId': missionId},
            ),
            icon: const Icon(Icons.add),
            label: const Text('Log Contribution'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],

        OutlinedButton.icon(
          onPressed: () => context.pushNamed(
            'contributionHistory',
            pathParameters: {'missionId': missionId},
          ),
          icon: const Icon(Icons.history),
          label: const Text('View History'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        // Certificate button for completed missions
        if (mission.isCompleted) ...[
          const SizedBox(height: 12),
          FilledButton.tonal(
            onPressed: () => context.pushNamed(
              'certificate',
              pathParameters: {'missionId': missionId},
            ),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.workspace_premium),
                SizedBox(width: 8),
                Text('View Certificate'),
              ],
            ),
          ),
        ],

        const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    String label;

    switch (status) {
      case 'completed':
        color = AppColors.success;
        icon = Icons.check_circle;
        label = 'Completed';
      case 'paused':
        color = AppColors.warning;
        icon = Icons.pause_circle;
        label = 'Paused';
      case 'failed':
        color = AppColors.progressRed;
        icon = Icons.cancel;
        label = 'Failed';
      default:
        color = AppColors.info;
        icon = Icons.play_circle;
        label = 'Active';
    }

    return Chip(
      avatar: Icon(icon, color: color, size: 18),
      label: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
      backgroundColor: color.withAlpha(25),
      side: BorderSide(color: color.withAlpha(76)),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(179),
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
        ),
      ],
    );
  }
}

// ── AI Helpers ──

String _adaptLabel(String suggestion) {
  switch (suggestion) {
    case 'reduce_daily':
      return 'AI suggests reducing your daily target';
    case 'extend_timeline':
      return 'AI suggests extending your timeline';
    case 'split_mission':
      return 'AI suggests splitting this mission';
    default:
      return 'AI has a suggestion for you';
  }
}

void _showAdaptSheet(
  BuildContext context,
  WidgetRef ref,
  MissionModel mission,
  AdaptResponse adapt,
) {
  final hasChanges =
      adapt.newDailyAmount != null || adapt.newEndDate != null;

  AiSuggestionBottomSheet.show(
    context,
    suggestion: hasChanges
        ? _adaptLabel(adapt.suggestion)
        : 'You\'re on track!',
    reasoning: adapt.reasoning,
    onAccept: hasChanges
        ? () async {
            final repo = ref.read(missionRepositoryProvider);
            final updates = <String, dynamic>{};

            if (adapt.newDailyAmount != null) {
              updates['dailyTarget'] = adapt.newDailyAmount;
            }
            if (adapt.newEndDate != null) {
              updates['endDate'] = adapt.newEndDate;
            }

            try {
              await repo.updateMission(mission.id, updates);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Mission updated with AI suggestion!')),
                );
                ref.invalidate(missionDetailProvider(mission.id));
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to update: $e')),
                );
              }
            }
          }
        : null,
  );
}

// ── AI Integration Widgets ──

class _AiNudgeSection extends ConsumerWidget {
  final MissionModel mission;

  const _AiNudgeSection({required this.mission});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nudgeAsync = ref.watch(missionNudgeProvider(mission));

    return nudgeAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Card(
          color: Theme.of(context).colorScheme.errorContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(Icons.smart_toy, color: Theme.of(context).colorScheme.onErrorContainer, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'AI suggestions unavailable',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, size: 20),
                  onPressed: () => ref.invalidate(missionNudgeProvider(mission)),
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ],
            ),
          ),
        ),
      ),
      data: (nudge) {
        if (nudge == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: AiNudgeCard(
            message: nudge.message,
            actionSuggestion: nudge.actionSuggestion,
            onAccept: () {
              final adaptAsync =
                  ref.read(missionAdaptProvider(mission));
              adaptAsync.whenData((adapt) {
                if (adapt != null && context.mounted) {
                  _showAdaptSheet(context, ref, mission, adapt);
                }
              });
            },
            onDismiss: () =>
                ref.invalidate(missionNudgeProvider(mission)),
          ),
        );
      },
    );
  }
}

class _AiPredictionSection extends ConsumerWidget {
  final MissionModel mission;

  const _AiPredictionSection({required this.mission});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final predictionAsync = ref.watch(missionPredictionProvider(mission));
    final theme = Theme.of(context);

    return predictionAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (error, _) => const SizedBox.shrink(),
      data: (prediction) {
        if (prediction == null) return const SizedBox.shrink();

        final probability = prediction.completionProbability;
        final riskLevel = prediction.riskLevel;
        final Color riskColor;
        final IconData riskIcon;

        switch (riskLevel) {
          case 'low':
            riskColor = AppColors.success;
            riskIcon = Icons.check_circle_outline;
          case 'medium':
            riskColor = AppColors.warning;
            riskIcon = Icons.info_outline;
          case 'high':
            riskColor = AppColors.progressRed;
            riskIcon = Icons.warning_amber_rounded;
          case 'critical':
            riskColor = AppColors.progressRed;
            riskIcon = Icons.error_outline;
          default:
            riskColor = AppColors.info;
            riskIcon = Icons.analytics_outlined;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: riskColor.withAlpha(76)),
            ),
            color: riskColor.withAlpha(20),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(riskIcon, color: riskColor, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${(probability * 100).toStringAsFixed(0)}% chance of completion',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: riskColor,
                          ),
                        ),
                        if (prediction.factors.isNotEmpty)
                          Text(
                            prediction.factors.first,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withAlpha(153),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AiAdaptSection extends ConsumerWidget {
  final MissionModel mission;

  const _AiAdaptSection({required this.mission});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adaptAsync = ref.watch(missionAdaptProvider(mission));

    return adaptAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.only(top: 12),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Card(
          color: Theme.of(context).colorScheme.errorContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(Icons.smart_toy, color: Theme.of(context).colorScheme.onErrorContainer, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'AI plan unavailable',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, size: 20),
                  onPressed: () => ref.invalidate(missionAdaptProvider(mission)),
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ],
            ),
          ),
        ),
      ),
      data: (adapt) {
        if (adapt == null || adapt.suggestion == 'on_track') {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Card(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _showAdaptSheet(context, ref, mission, adapt),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(
                      Icons.smart_toy,
                      color: Theme.of(context)
                          .colorScheme
                          .onTertiaryContainer,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _adaptLabel(adapt.suggestion),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onTertiaryContainer,
                            ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Theme.of(context)
                          .colorScheme
                          .onTertiaryContainer
                          .withAlpha(153),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
