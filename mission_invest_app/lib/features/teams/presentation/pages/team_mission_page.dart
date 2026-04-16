import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../home/presentation/providers/home_provider.dart';
import '../../data/models/team_mission_model.dart';
import '../providers/team_provider.dart';

class TeamMissionPage extends ConsumerWidget {
  final String teamId;

  const TeamMissionPage({super.key, required this.teamId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamAsync = ref.watch(watchTeamMissionProvider(teamId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Mission'),
      ),
      body: teamAsync.when(
        loading: () => const Center(child: AppLoading()),
        error: (error, _) => AppErrorWidget(
          message: 'Failed to load team: $error',
          onRetry: () => ref.invalidate(watchTeamMissionProvider(teamId)),
        ),
        data: (team) {
          if (team == null) {
            return const Center(child: Text('Team mission not found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Team header
                _TeamHeader(team: team, theme: theme),
                const SizedBox(height: 24),

                // Overall progress
                _OverallProgress(team: team, theme: theme),
                const SizedBox(height: 24),

                // Member contributions (privacy-safe: percentage bars only)
                Text(
                  'Member Contributions',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _MemberContributions(team: team, theme: theme),
                const SizedBox(height: 24),

                // Action buttons
                _ActionButtons(
                  teamId: teamId,
                  team: team,
                  theme: theme,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TeamHeader extends StatelessWidget {
  final TeamMissionModel team;
  final ThemeData theme;

  const _TeamHeader({required this.team, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.groups_rounded,
                size: 32,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    team.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${team.memberCount} members',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(153),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: team.isCompleted
                    ? AppColors.success.withAlpha(25)
                    : theme.colorScheme.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                team.isCompleted ? 'Completed' : 'Active',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: team.isCompleted
                      ? AppColors.success
                      : theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OverallProgress extends StatelessWidget {
  final TeamMissionModel team;
  final ThemeData theme;

  const _OverallProgress({required this.team, required this.theme});

  @override
  Widget build(BuildContext context) {
    final percent = (team.progressPercentage * 100).toInt();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Progress',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            // Large percentage display
            Center(
              child: SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: team.progressPercentage.clamp(0.0, 1.0),
                        strokeWidth: 10,
                        backgroundColor:
                            theme.colorScheme.primary.withAlpha(38),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _progressColor(team.progressPercentage),
                        ),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$percent%',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'funded',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color:
                                theme.colorScheme.onSurface.withAlpha(153),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
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

class _MemberContributions extends StatelessWidget {
  final TeamMissionModel team;
  final ThemeData theme;

  const _MemberContributions({required this.team, required this.theme});

  @override
  Widget build(BuildContext context) {
    final percentages = team.memberContributionPercentages;

    if (team.memberIds.isEmpty) {
      return Text(
        'No members yet',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface.withAlpha(153),
        ),
      );
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            for (int i = 0; i < team.memberIds.length; i++)
              Padding(
                padding: EdgeInsets.only(
                  bottom: i < team.memberIds.length - 1 ? 12 : 0,
                ),
                child: _MemberBar(
                  memberLabel: 'Member ${i + 1}',
                  percentage: percentages[team.memberIds[i]] ?? 0.0,
                  theme: theme,
                  colorIndex: i,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MemberBar extends StatelessWidget {
  final String memberLabel;
  final double percentage;
  final ThemeData theme;
  final int colorIndex;

  const _MemberBar({
    required this.memberLabel,
    required this.percentage,
    required this.theme,
    required this.colorIndex,
  });

  static const _memberColors = [
    AppColors.info,
    AppColors.success,
    AppColors.streakFire,
    AppColors.progressYellow,
    AppColors.pastelPrimary,
  ];

  @override
  Widget build(BuildContext context) {
    final color = _memberColors[colorIndex % _memberColors.length];
    final pct = (percentage * 100).toInt();

    return Row(
      children: [
        // Avatar placeholder
        CircleAvatar(
          radius: 16,
          backgroundColor: color.withAlpha(40),
          child: Icon(Icons.person, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    memberLabel,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '$pct% of total',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(153),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: percentage.clamp(0.0, 1.0),
                  minHeight: 6,
                  backgroundColor: color.withAlpha(30),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionButtons extends ConsumerWidget {
  final String teamId;
  final TeamMissionModel team;
  final ThemeData theme;

  const _ActionButtons({
    required this.teamId,
    required this.team,
    required this.theme,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actionState = ref.watch(teamActionNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Add contribution
        FilledButton.icon(
          onPressed: team.isCompleted || actionState.isLoading
              ? null
              : () => _showContributeDialog(context, ref),
          icon: const Icon(Icons.add),
          label: const Text('Add Contribution'),
        ),
        const SizedBox(height: 8),

        // Invite friend
        OutlinedButton.icon(
          onPressed: actionState.isLoading
              ? null
              : () => _showInviteDialog(context, ref),
          icon: const Icon(Icons.person_add),
          label: const Text('Invite Friend'),
        ),
      ],
    );
  }

  void _showContributeDialog(BuildContext context, WidgetRef ref) {
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Contribution'),
        content: TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Amount',
            prefixText: '\u20B9 ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final amount =
                  double.tryParse(amountController.text.trim()) ?? 0;
              if (amount <= 0) return;

              final userId = ref.read(currentUserIdProvider);
              if (userId == null) return;

              Navigator.of(ctx).pop();
              ref.read(teamActionNotifierProvider.notifier).addContribution(
                    teamId: teamId,
                    userId: userId,
                    amount: amount,
                  );
            },
            child: const Text('Contribute'),
          ),
        ],
      ),
    );
  }

  void _showInviteDialog(BuildContext context, WidgetRef ref) {
    final userIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Invite Friend'),
        content: TextField(
          controller: userIdController,
          decoration: const InputDecoration(
            labelText: 'Friend\'s User ID',
            hintText: 'Enter their user ID',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final friendId = userIdController.text.trim();
              if (friendId.isEmpty) return;

              Navigator.of(ctx).pop();
              ref.read(teamActionNotifierProvider.notifier).inviteMember(
                    teamId: teamId,
                    userId: friendId,
                  );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Invitation sent!')),
              );
            },
            child: const Text('Invite'),
          ),
        ],
      ),
    );
  }
}
