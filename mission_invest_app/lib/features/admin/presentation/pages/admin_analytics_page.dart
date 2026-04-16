import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/dashboard_card.dart';
import '../providers/admin_analytics_provider.dart';
import '../widgets/chart_widget.dart';

class AdminAnalyticsPage extends ConsumerWidget {
  const AdminAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(adminAnalyticsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.refresh_rounded,
                  size: 20, color: theme.colorScheme.onSurface),
            ),
            onPressed: () => ref.invalidate(adminAnalyticsProvider),
            tooltip: 'Refresh',
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: analyticsAsync.when(
        loading: () => const AppLoading(),
        error: (error, _) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(adminAnalyticsProvider),
        ),
        data: (data) => _buildDashboard(context, ref, data),
      ),
    );
  }

  Widget _buildDashboard(
      BuildContext context, WidgetRef ref, Map<String, dynamic> data) {
    final currencyFormat =
        NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    final theme = Theme.of(context);

    final totalUsers = data['totalUsers']?.toString() ?? '0';
    final activeUsers = data['activeUsers']?.toString() ?? '0';
    final totalMissions = data['totalMissions']?.toString() ?? '0';
    final completedMissions = data['completedMissions']?.toString() ?? '0';
    final totalSaved = currencyFormat.format(data['totalSaved'] ?? 0);
    final avgRate = data['avgCompletionRate'] ?? 0;
    final avgCompletionRate = '${(avgRate as num).toInt()}%';
    final retentionRate = data['retentionRate'] ?? 0;

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(adminAnalyticsProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPI Cards Row 1
            Row(
              children: [
                Expanded(
                  child: KpiCard(
                    title: 'Total Users',
                    value: totalUsers,
                    icon: Icons.people_rounded,
                    color: AppColors.info,
                    trend: '+12%',
                    trendUp: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: KpiCard(
                    title: 'Active Users',
                    value: activeUsers,
                    icon: Icons.person_rounded,
                    color: AppColors.success,
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 12),

            // KPI Cards Row 2
            Row(
              children: [
                Expanded(
                  child: KpiCard(
                    title: 'Total Saved',
                    value: totalSaved,
                    icon: Icons.savings_rounded,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: KpiCard(
                    title: 'Completion',
                    value: avgCompletionRate,
                    icon: Icons.trending_up_rounded,
                    color: AppColors.warning,
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
            const SizedBox(height: 12),

            // KPI Cards Row 3
            Row(
              children: [
                Expanded(
                  child: KpiCard(
                    title: 'Missions',
                    value: totalMissions,
                    icon: Icons.flag_rounded,
                    color: AppColors.streakFire,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: KpiCard(
                    title: 'Completed',
                    value: completedMissions,
                    icon: Icons.check_circle_rounded,
                    color: AppColors.progressGreen,
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
            const SizedBox(height: 20),

            // Retention Card
            DashboardCard(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withAlpha(20),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.replay_rounded,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Retention Rate',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color:
                                theme.colorScheme.onSurface.withAlpha(120),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$retentionRate%',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Mini progress ring
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: (retentionRate as num).toDouble() / 100,
                          strokeWidth: 4,
                          backgroundColor:
                              theme.colorScheme.primary.withAlpha(25),
                          valueColor: AlwaysStoppedAnimation(
                              theme.colorScheme.primary),
                          strokeCap: StrokeCap.round,
                        ),
                        Text(
                          '$retentionRate',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
            const SizedBox(height: 20),

            // Bar chart — weekly activity
            BarChartWidget(
              title: 'Weekly Activity',
              values: const [12, 18, 8, 22, 15, 28, 20],
              labels: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
            ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
            const SizedBox(height: 16),

            // Donut chart — category distribution
            DonutChartWidget(
              title: 'Mission Categories',
              data: const {
                'Trip': 35,
                'Gadget': 25,
                'Education': 20,
                'Emergency': 12,
                'Other': 8,
              },
            ).animate().fadeIn(duration: 400.ms, delay: 500.ms),

            // Extra space for floating nav
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
