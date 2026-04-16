import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/dashboard_card.dart';

class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Admin',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(120),
              ),
            ),
            Text(
              'Dashboard',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Quick Stats Row
          Row(
            children: [
              Expanded(
                child: _QuickStatPill(
                  icon: Icons.people_rounded,
                  label: 'Users',
                  color: AppColors.info,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _QuickStatPill(
                  icon: Icons.flag_rounded,
                  label: 'Missions',
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _QuickStatPill(
                  icon: Icons.savings_rounded,
                  label: 'Savings',
                  color: AppColors.warning,
                ),
              ),
            ],
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 20),

          // Admin tiles
          ..._adminItems.asMap().entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _AdminTile(
                  icon: entry.value.icon,
                  title: entry.value.title,
                  subtitle: entry.value.subtitle,
                  color: entry.value.color,
                  onTap: () => context.push(entry.value.route),
                )
                    .animate()
                    .fadeIn(
                      duration: 400.ms,
                      delay: (100 + entry.key * 60).ms,
                    )
                    .slideX(
                      begin: 0.03,
                      duration: 400.ms,
                      delay: (100 + entry.key * 60).ms,
                      curve: Curves.easeOutCubic,
                    ),
              )),
          // Extra space for floating nav
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _AdminItemData {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
  final Color color;

  const _AdminItemData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.color,
  });
}

const _adminItems = [
  _AdminItemData(
    icon: Icons.people_rounded,
    title: 'Users',
    subtitle: 'View and manage users',
    route: '/admin/users',
    color: AppColors.info,
  ),
  _AdminItemData(
    icon: Icons.analytics_rounded,
    title: 'Analytics',
    subtitle: 'DAU, retention, completion rates',
    route: '/admin/analytics',
    color: AppColors.success,
  ),
  _AdminItemData(
    icon: Icons.category_rounded,
    title: 'Templates',
    subtitle: 'Manage mission templates',
    route: '/admin/templates',
    color: AppColors.warning,
  ),
  _AdminItemData(
    icon: Icons.emoji_events_rounded,
    title: 'Challenges',
    subtitle: 'Platform-wide savings challenges',
    route: '/admin/challenges',
    color: AppColors.badgeGold,
  ),
  _AdminItemData(
    icon: Icons.notifications_rounded,
    title: 'Broadcast',
    subtitle: 'Send push notifications',
    route: '/admin/notifications',
    color: AppColors.streakFire,
  ),
  _AdminItemData(
    icon: Icons.toggle_on_rounded,
    title: 'Feature Flags',
    subtitle: 'Toggle features on/off',
    route: '/admin/feature-flags',
    color: AppColors.accentLight,
  ),
  _AdminItemData(
    icon: Icons.smart_toy_rounded,
    title: 'AI Review',
    subtitle: 'Review AI-generated messages',
    route: '/admin/ai-review',
    color: AppColors.info,
  ),
];

class _QuickStatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _QuickStatPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(30)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(150),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _AdminTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DashboardCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(120),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: theme.colorScheme.onSurface.withAlpha(80),
          ),
        ],
      ),
    );
  }
}
