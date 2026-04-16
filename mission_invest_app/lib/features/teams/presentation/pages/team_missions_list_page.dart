import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../home/presentation/providers/home_provider.dart';
import '../../data/models/team_mission_model.dart';
import '../providers/team_provider.dart';

class TeamMissionsListPage extends ConsumerWidget {
  const TeamMissionsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamsAsync = ref.watch(currentUserTeamMissionsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Missions'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('New Team'),
      ),
      body: teamsAsync.when(
        loading: () => const Center(child: AppLoading()),
        error: (error, _) => AppErrorWidget(
          message: 'Failed to load teams: $error',
          onRetry: () => ref.invalidate(currentUserTeamMissionsProvider),
        ),
        data: (teams) {
          if (teams.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(currentUserTeamMissionsProvider);
              },
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: const Center(
                      child: EmptyState(
                        icon: Icons.groups_outlined,
                        title: 'No team missions yet',
                        subtitle:
                            'Create a team mission and invite friends to save together!',
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(currentUserTeamMissionsProvider);
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: teams.length,
              itemBuilder: (context, index) {
                final team = teams[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _TeamCard(team: team, theme: theme),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final targetController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create Team Mission'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Mission Title',
                hintText: 'e.g. Family Trip Fund',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: targetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Target Amount',
                prefixText: '\u20B9 ',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final title = titleController.text.trim();
              final target =
                  double.tryParse(targetController.text.trim()) ?? 0;
              if (title.isEmpty || target <= 0) return;

              Navigator.of(ctx).pop();
              _createTeam(context, ref, title, target);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Future<void> _createTeam(
    BuildContext context,
    WidgetRef ref,
    String title,
    double target,
  ) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;

    final mission = TeamMissionModel(
      id: '',
      title: title,
      targetAmount: target,
      memberIds: [userId],
      contributions: const {},
      status: 'active',
      createdAt: DateTime.now(),
      createdBy: userId,
    );

    final teamId = await ref
        .read(teamActionNotifierProvider.notifier)
        .createTeamMission(mission);

    if (teamId != null && context.mounted) {
      context.push('/teams/$teamId');
    }
  }
}

class _TeamCard extends StatelessWidget {
  final TeamMissionModel team;
  final ThemeData theme;

  const _TeamCard({required this.team, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => context.push('/teams/${team.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title + status
              Row(
                children: [
                  const Icon(Icons.groups, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      team.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: team.isCompleted
                          ? AppColors.success.withAlpha(25)
                          : theme.colorScheme.primary.withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      team.isCompleted ? 'Completed' : 'Active',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: team.isCompleted
                            ? AppColors.success
                            : theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Progress bar (no amounts — privacy)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${team.memberCount} members',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(153),
                    ),
                  ),
                  Text(
                    '${(team.progressPercentage * 100).toInt()}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: team.progressPercentage.clamp(0.0, 1.0),
                  minHeight: 6,
                  backgroundColor: theme.colorScheme.primary.withAlpha(38),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _progressColor(team.progressPercentage),
                  ),
                ),
              ),
            ],
          ),
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
