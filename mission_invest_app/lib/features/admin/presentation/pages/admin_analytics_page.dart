import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../providers/admin_analytics_provider.dart';
import '../widgets/stat_card.dart';

class AdminAnalyticsPage extends ConsumerWidget {
  const AdminAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(adminAnalyticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(adminAnalyticsProvider),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: analyticsAsync.when(
        loading: () => const AppLoading(),
        error: (error, _) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(adminAnalyticsProvider),
        ),
        data: (data) => _buildDashboard(context, data),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, Map<String, dynamic> data) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    final percentFormat = NumberFormat.percentPattern();

    final totalUsers = data['totalUsers']?.toString() ?? '0';
    final activeUsers = data['activeUsers']?.toString() ?? '0';
    final totalMissions = data['totalMissions']?.toString() ?? '0';
    final completedMissions = data['completedMissions']?.toString() ?? '0';
    final totalSaved = currencyFormat.format(data['totalSaved'] ?? 0);
    final avgCompletionRate = percentFormat
        .format((data['avgCompletionRate'] ?? 0) / 100);
    final retentionRate = data['retentionRate'] ?? 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              StatCard(
                title: 'Total Users',
                value: totalUsers,
                icon: Icons.people,
                color: Colors.blue,
              ),
              StatCard(
                title: 'Active Users',
                value: activeUsers,
                icon: Icons.person_outline,
                color: Colors.green,
              ),
              StatCard(
                title: 'Total Missions',
                value: totalMissions,
                icon: Icons.flag,
                color: Colors.orange,
              ),
              StatCard(
                title: 'Completed Missions',
                value: completedMissions,
                icon: Icons.check_circle,
                color: Colors.teal,
              ),
              StatCard(
                title: 'Total Saved',
                value: totalSaved,
                icon: Icons.savings,
                color: Colors.purple,
              ),
              StatCard(
                title: 'Avg Completion Rate',
                value: avgCompletionRate,
                icon: Icons.trending_up,
                color: Colors.indigo,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.replay,
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Retention Rate',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$retentionRate%',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
