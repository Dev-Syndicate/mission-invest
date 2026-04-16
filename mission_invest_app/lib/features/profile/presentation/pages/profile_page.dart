import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/display_mode.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/display_mode_toggle.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../home/presentation/providers/home_provider.dart';
import '../widgets/confidence_score_dial.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(currentUserProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          const DisplayModeToggle(),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.pushNamed('settings'),
          ),
        ],
      ),
      body: userProfileAsync.when(
        loading: () => const Center(child: AppLoading()),
        error: (error, _) => Center(
          child: Text('Failed to load profile: $error'),
        ),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('No profile found.'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Avatar
              Center(
                child: CircleAvatar(
                  radius: 48,
                  backgroundImage: user.photoUrl != null
                      ? NetworkImage(user.photoUrl!)
                      : null,
                  child: user.photoUrl == null
                      ? const Icon(Icons.person, size: 48)
                      : null,
                ),
              ),
              const SizedBox(height: 16),

              // Display name
              Center(
                child: Text(
                  user.displayName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Center(
                child: Text(
                  user.email,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(153),
                      ),
                ),
              ),

              const SizedBox(height: 24),

              // Financial Confidence Score dial
              const ConfidenceScoreDial(),

              const SizedBox(height: 24),

              // Stats card
              _StatCard(
                children: [
                  _StatItem(
                    label: 'Total\nMissions',
                    value: '${user.totalMissionsCreated}',
                  ),
                  _StatItem(
                    label: 'Completion\nRate',
                    value: user.totalMissionsCreated > 0
                        ? '${((user.totalMissionsCompleted / user.totalMissionsCreated) * 100).round()}%'
                        : '0%',
                  ),
                  _StatItem(
                    label: 'Longest\nStreak',
                    value: '${user.longestGlobalStreak}',
                  ),
                  _StatItem(
                    label: 'Total\nSaved',
                    value: CurrencyFormatter.format(user.totalSaved),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Display mode toggle (inline card)
              _DisplayModeCard(ref: ref),

              const SizedBox(height: 16),

              // Admin panel (only visible for admins)
              if (user.isAdmin)
                ListTile(
                  leading: const Icon(Icons.admin_panel_settings),
                  title: const Text('Admin Panel'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/admin'),
                ),

              // Navigation items
              ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: const Text('Notification Settings'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.pushNamed('notificationSettings'),
              ),

              const SizedBox(height: 8),

              // Sign out button
              OutlinedButton.icon(
                onPressed: () {
                  ref.read(authNotifierProvider.notifier).signOut();
                },
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
              ),

              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }
}

class _DisplayModeCard extends StatelessWidget {
  final WidgetRef ref;

  const _DisplayModeCard({required this.ref});

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(displayModeProvider);
    final isWin = mode == DisplayMode.win;
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              isWin ? Icons.celebration : Icons.self_improvement,
              color: isWin ? Colors.amber : theme.colorScheme.onSurface,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isWin ? 'Win Mode' : 'Focus Mode',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    isWin
                        ? 'Celebrations & confetti enabled'
                        : 'Clean & minimal experience',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(153),
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: isWin,
              onChanged: (_) =>
                  ref.read(displayModeProvider.notifier).toggle(),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final List<_StatItem> children;

  const _StatCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: children,
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
