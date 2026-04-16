import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/display_mode.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/dashboard_card.dart';
import '../../../../shared/widgets/display_mode_toggle.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../home/presentation/providers/home_provider.dart';
import '../widgets/confidence_score_dial.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(currentUserProfileProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          const DisplayModeToggle(),
          const SizedBox(width: 8),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.settings_rounded,
                  size: 20, color: theme.colorScheme.onSurface),
            ),
            onPressed: () => context.pushNamed('settings'),
          ),
          const SizedBox(width: 4),
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

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(currentUserProfileProvider);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                // Avatar + info
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.primary.withAlpha(120),
                        ],
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 46,
                      backgroundColor: theme.colorScheme.surface,
                      backgroundImage: user.photoUrl != null
                          ? NetworkImage(user.photoUrl!)
                          : null,
                      child: user.photoUrl == null
                          ? Icon(Icons.person_rounded,
                              size: 46,
                              color: theme.colorScheme.onSurface
                                  .withAlpha(120))
                          : null,
                    ),
                  ),
                ).animate().fadeIn(duration: 400.ms).scale(
                      begin: const Offset(0.9, 0.9),
                      duration: 400.ms,
                      curve: Curves.easeOutCubic,
                    ),
                const SizedBox(height: 16),

                Center(
                  child: Text(
                    user.displayName,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    user.email,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(120),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Confidence score dial
                const ConfidenceScoreDial()
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 100.ms),
                const SizedBox(height: 20),

                // Stats grid
                Row(
                  children: [
                    Expanded(
                      child: _MiniStatCard(
                        label: 'Missions',
                        value: '${user.totalMissionsCreated}',
                        icon: Icons.flag_rounded,
                        color: AppColors.info,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MiniStatCard(
                        label: 'Rate',
                        value: user.totalMissionsCreated > 0
                            ? '${((user.totalMissionsCompleted / user.totalMissionsCreated) * 100).round()}%'
                            : '0%',
                        icon: Icons.check_circle_rounded,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _MiniStatCard(
                        label: 'Best Streak',
                        value: '${user.longestGlobalStreak}',
                        icon: Icons.local_fire_department_rounded,
                        color: AppColors.streakFire,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MiniStatCard(
                        label: 'Total Saved',
                        value: CurrencyFormatter.compact(user.totalSaved),
                        icon: Icons.savings_rounded,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms, delay: 250.ms),
                const SizedBox(height: 20),

                // Display mode toggle card
                _DisplayModeCard(ref: ref)
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 300.ms),
                const SizedBox(height: 12),

                // Admin panel
                if (user.isAdmin)
                  DashboardCard(
                    onTap: () => context.push('/admin'),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withAlpha(20),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.admin_panel_settings_rounded,
                              color: AppColors.warning, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Admin Panel',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded,
                            color:
                                theme.colorScheme.onSurface.withAlpha(80)),
                      ],
                    ),
                  ),

                if (user.isAdmin) const SizedBox(height: 12),

                // Notification settings
                DashboardCard(
                  onTap: () => context.pushNamed('notificationSettings'),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.info.withAlpha(20),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.notifications_rounded,
                            color: AppColors.info, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Notification Settings',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded,
                          color: theme.colorScheme.onSurface.withAlpha(80)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Sign out button
                OutlinedButton.icon(
                  onPressed: () {
                    ref.read(authNotifierProvider.notifier).signOut();
                  },
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Sign Out'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    foregroundColor: theme.colorScheme.error,
                    side: BorderSide(
                        color: theme.colorScheme.error.withAlpha(60)),
                  ),
                ),

                // Extra space for floating nav
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MiniStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DashboardCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(120),
                  ),
                ),
              ],
            ),
          ),
        ],
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

    return DashboardCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isWin
                  ? Colors.amber.withAlpha(20)
                  : theme.colorScheme.onSurface.withAlpha(15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isWin ? Icons.celebration_rounded : Icons.self_improvement,
              color: isWin ? Colors.amber : theme.colorScheme.onSurface,
              size: 20,
            ),
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
                    color: theme.colorScheme.onSurface.withAlpha(120),
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
    );
  }
}
